import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'add_address_screen.dart';
import 'common/constant.dart';
import 'common/loader.dart';
import 'model/list_model.dart';
import 'home.dart';
import 'package:auto_size_text/auto_size_text.dart';

class AddressListPage extends StatefulWidget {
  @override
  _AddressListPageState createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  String selectedId = "";
  bool isLoading = false;

  String selectedAddressId = "";
  String selectedAddress = "";
  bool isSelected = false;

  String userId = "";
  String orderItemMsg = "";
  String orderTotalAmount = "";
  String dialogFor = "";
  String positiveBtnText = "";

  Future<List<AddressListItems>> _getAddressList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    userId = pref.getString(Constant.userId);
    orderItemMsg = pref.getString(Constant.orderItemMsg);
    orderTotalAmount = pref.getString(Constant.orderTotalAmount);

    // var res = await http.get(Constant.url + "?method=GetAllAddress&userId=" + userId);
    var res = await http.get(Constant.url2 + "?method=getShopList");
    var jsonObjRes = json.decode(res.body);

    List<AddressListItems> listItems = [];
//
    if (jsonObjRes["Response"] == "NOT_AVAILABLE") {
      CommonMethods.showColoredToast("Address Not Available.", Colors.red);
    } else {
      for (var u in jsonObjRes["Response"]) {
//        print("Pratik u" + u.toString());
        AddressListItems item = AddressListItems(u["id"], u["name"],
            u["shopName"], u["mobile"], u["email"], u["address"], u["pincode"]);
        listItems.add(item);
      }
    }
    isLoading = false;
    return listItems;
  }

  showOrderPreview() {
    if (selectedAddress != "") {
      dialogFor = "Preview";
      positiveBtnText = "Place Order";
      String result =
          "Your Order Details: " + orderItemMsg.replaceAll(',', '\n');
      showAlertDialog("Order Preview",
          result + "\n\nAddress Details:-\n" + selectedAddress);
    } else {
      CommonMethods.showColoredToast("Address Not Selected.", Colors.red);
    }
  }

  itemDeleteClicked(itemData) {
    selectedId = itemData.eventId;
    dialogFor = "Delete";
    positiveBtnText = "Delete";
    showAlertDialog("Confirmation", "Do you really want to delete this?");
  }

  void showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false, //to avoid outside click to cancel
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(
          message,
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.red),
            ),
          ),
          FlatButton(
            onPressed: () {
              alertDialogPositiveBtnClicked();
            },
            child: Text(
              positiveBtnText,
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  alertDialogPositiveBtnClicked() {
    Navigator.of(context).pop();
    isLoading = true;
    loadProgress(isLoading);
    if (dialogFor == "Delete") {
      _deleteAddress();
    } else {
      _placeUserOrder();
    }
  }

  loadProgress(bool loadingStatus) {
    setState(() {
      isLoading = loadingStatus;
    });
  }

  _placeUserOrder() async {
    print("im insideee");
    String clientBusinessId = Constant.clientBusinessId;
    Map<String, String> headers = {"Content-type": "application/json"};
    String bodyObj = '{"method":"AddOrder","userId":"$userId","addressId":"$selectedAddressId","orderDetails":"$orderItemMsg","Amount":"$orderTotalAmount","clientBusinessId":"$clientBusinessId"}';

    print("body: " + bodyObj);
    http.Response res =
        await http.post(Constant.url, headers: headers, body: bodyObj);
    var data = json.decode(res.body);

    print("ressssss: " + data["Response"]);

    if (data["Response"] == 'EMAIL_SUCCESSFULLY_SENT') {
      CommonMethods.showColoredToast("Order Placed Successfully", Colors.green);
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.remove("_cartList");
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      CommonMethods.showColoredToast("Order Failed", Colors.red);
    }

    isLoading = false;
    loadProgress(isLoading);
  }

  _deleteAddress() async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String bodyObj =
        '{"method":"DeleteEvent","addressId":"$selectedAddressId","accessByUserId":"$userId"}';

    http.Response res =
        await http.post(Constant.url, headers: headers, body: bodyObj);
    var data = json.decode(res.body);

    if (data["Response"] == 'SUCCESS_EVENT_DETAILS_DELETE') {
      CommonMethods.showColoredToast("Successfully Deleted", Colors.green);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AddressListPage()));
    } else {
      CommonMethods.showColoredToast("Failed to Delete", Colors.red);
    }

    isLoading = false;
    loadProgress(isLoading);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Address',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddAddressDetails(null),
          ));
        },
        elevation: 10.0,
        child: Icon(Icons.add),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              flex: 8,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                child: FutureBuilder(
                  future: _getAddressList(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return MyLoader();
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            var itemData = snapshot.data[index];
                            return Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              child: Card(
                                  elevation: 10.0,

                                  child: RadioListTile(
                                    title: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        AutoSizeText(
                                          "Address:  " + itemData.address,
                                          maxLines: 2,
                                          minFontSize: 12,
                                          textAlign: TextAlign.start,
                                        ),
                                        AutoSizeText(
                                          "Land Mark: " + itemData.name,
                                          maxLines: 2,
                                          minFontSize: 12,
                                          textAlign: TextAlign.start,
                                        ),
                                        AutoSizeText(
                                          "Area: " + itemData.shopName,
                                          maxLines: 2,
                                          minFontSize: 12,
                                          textAlign: TextAlign.start,
                                        ),
                                        AutoSizeText(
                                          "City: " + itemData.mobile,
                                          maxLines: 2,
                                          minFontSize: 12,
                                          textAlign: TextAlign.start,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              "Pincode: " + itemData.pincode,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    groupValue: selectedAddressId,
                                    value: itemData.addressId,
                                    onChanged: (val) {
                                      setState(() {
                                        selectedAddress = "Address: " +
                                            itemData.address +
                                            " \nLandmark: " +
                                            itemData.landMark +
                                            " \nArea: " +
                                            itemData.area +
                                            " \nCity: " +
                                            itemData.city +
                                            " \nPincode: " +
                                            itemData.pincode;
                                        selectedAddressId = itemData.addressId;
                                      });
                                    },
                                  )),
                              actions: <Widget>[
                                IconSlideAction(
                                  caption: 'Edit',
                                  color: Colors.blue,
                                  icon: Icons.mode_edit,
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          AddAddressDetails(itemData),
                                    ));
                                  },
                                ),
                              ],
                              secondaryActions: <Widget>[
                                IconSlideAction(
                                  caption: 'Delete',
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () {
                                    itemDeleteClicked(itemData);
                                  },
                                ),
                              ],
                            );
                          });
                    }
                  },
                ),
              )),
          Expanded(
            child: Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          child: RaisedButton(
                            onPressed: () {
                              showOrderPreview();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Colors.deepOrange,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "Confirm & Place Order",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
