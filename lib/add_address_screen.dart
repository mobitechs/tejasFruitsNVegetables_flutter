import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'address_list.dart';
import 'common/constant.dart';
import 'common/loader.dart';

class AddAddressDetails extends StatefulWidget {
  var itemData;

  AddAddressDetails(this.itemData);

  @override
  _AddAddressDetailsState createState() => _AddAddressDetailsState(itemData);
}

class _AddAddressDetailsState extends State<AddAddressDetails> {
  var itemData;

  _AddAddressDetailsState(this.itemData);

  String btnText = "Add Address";
  String pageTitle = 'Add Address Details';
  String imFor = "Add";
  String successMsg = "Address details successfully added.";
  String errorMsg = "Failed to add Address details.";
  TextEditingController _controllerAddress, _controllerLandMark,_controllerArea,_controllerCity,_controllerPincode;

  bool isLoading = false;
  String errorText = "",
      addressId,
      address = "",
      landMark = "",
      area = "",
      pincode = "",
      city = "";

  @override
  void initState() {
    super.initState();

    if (itemData != null) {
      addressId = itemData.addressId;
      address = itemData.address;
      landMark = itemData.landMark;
      area = itemData.area;
      city = itemData.city;
      pincode = itemData.pincode;

      imFor = "Update";
      btnText = "Update Address";
      pageTitle = 'Update Address Details';
      successMsg = "Address details successfully updated.";
      errorMsg = "Failed to update Address details.";

      _controllerAddress = new TextEditingController(text: address);
      _controllerLandMark = new TextEditingController(text: landMark);
      _controllerArea = new TextEditingController(text: area);
      _controllerCity = new TextEditingController(text: city);
      _controllerPincode = new TextEditingController(text: pincode);

      setState(() {});
    }
  }

  AddAddressDetails() {
    if (address == "") {
      CommonMethods.showColoredToast("Enter Address", Colors.red);
    }
//    else if (landMark == "") {
//      CommonMethods.showColoredToast("Enter Event Description", Colors.red);
//    }
//    else if (area == null) {
//      CommonMethods.showColoredToast("Select Event Date", Colors.red);
//    }
//    else if (city == null) {
//      CommonMethods.showColoredToast("Select Event TIme", Colors.red);
//    }
    else {
      isLoading = true;
      loadProgress(isLoading);
      callAPI();
    }
  }

  void callAPI() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userId = pref.getString(Constant.userId);

    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      String bodyObj ="";
      String method ="";
      if (imFor == "Add") {
        method = "AddAddress";
        bodyObj = '{"method":"$method","userId":"$userId","address":"$address","landMark":"$landMark","area":"$area","city":"$city","pincode":"$pincode"}';
      } else {
        method = "UpdateAddress";
        bodyObj = '{"method":"$method","addressId":"$addressId","userId":"$userId","address":"$address","landMark":"$landMark","area":"$area","city":"$city","pincode":"$pincode"}';
      }

      Response res = await post(Constant.url, headers: headers, body: bodyObj);
      print('pratik body' + bodyObj);
      var data = json.decode(res.body);

      if (data["Response"] == 'SUCCESS_ADD') {
        CommonMethods.showColoredToast(successMsg, Colors.green);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AddressListPage()));
      } else {
        CommonMethods.showColoredToast(errorMsg, Colors.red);
      }

    } catch (e) {
      print("errr: " + e.toString());
    }
  }

  loadProgress(bool loadingStatus) {
    setState(() {
      isLoading = loadingStatus;
    });
  }

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        area = selectedDate.toLocal().toString();
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime
    );

    if(pickedTime!=null && pickedTime != selectedTime){
      setState(() {
        selectedTime = pickedTime;
        city = selectedTime.toString();
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(pageTitle, style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 2.0,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _controllerAddress,
                      onChanged: (text) {
                        address = text;
                      },
                      autocorrect: false,
                      autofocus: false,
                      decoration: InputDecoration(
                          labelText: 'Address',
//                          errorText: errorText,
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _controllerLandMark,
                      onChanged: (text) {
                        landMark = text;
                      },
                      autocorrect: false,
                      autofocus: false,
                      decoration: InputDecoration(
                          labelText: 'Landmark',
//                          errorText: errorText,
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    TextField(
                      controller: _controllerArea,
                      onChanged: (text) {
                        area = text;
                      },
                      autocorrect: false,
                      autofocus: false,
                      decoration: InputDecoration(
                          labelText: 'Area',
//                          errorText: errorText,
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _controllerCity,
                      onChanged: (text) {
                        city = text;
                      },
                      autocorrect: false,
                      autofocus: false,
                      decoration: InputDecoration(
                          labelText: 'City',
//                          errorText: errorText,
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _controllerPincode,
                      onChanged: (text) {
                        pincode = text;
                      },
                      autocorrect: false,
                      autofocus: false,
                      decoration: InputDecoration(
                          labelText: 'Pin Code',
//                          errorText: errorText,
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      onPressed: AddAddressDetails,
                      child: Text(
                        btnText,
                        style: TextStyle(color: Colors.white),
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      color: Colors.redAccent,
                    ),
                  ],
                ),
              ),
              Center(
                child: Visibility(
                  visible: isLoading,
                  child: MyLoader(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
