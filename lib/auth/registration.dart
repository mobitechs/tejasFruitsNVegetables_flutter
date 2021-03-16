import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tejas_vegetables/common/constant.dart';
import 'package:tejas_vegetables/common/loader.dart';
import 'package:tejas_vegetables/model/list_model.dart';
import '../home.dart';

class Registration extends StatefulWidget {

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {

  bool isLoading = false;


  String userName="", emailId="", mobileNo="", password="",confPassword="";
  int imgFor;
  String clientBusinessId = Constant.clientBusinessId;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }


  checkRegistrationDetails() {
    if (userName == "") {
      CommonMethods.showColoredToast("Please enter username.", Colors.red);
    } else if (mobileNo == "") {
      CommonMethods.showColoredToast("Please enter mobile No.", Colors.red);
    } else if (emailId == "") {
      CommonMethods.showColoredToast("Enter enter email Id.", Colors.red);
    } else if (password == "") {
      CommonMethods.showColoredToast("Enter enter password.", Colors.red);
    } else if (confPassword == "") {
      CommonMethods.showColoredToast("Enter enter confirm password.", Colors.red);
    }else {
      if(password != confPassword){
        CommonMethods.showColoredToast("Passwords and confirm password is not same", Colors.red);
      }else{
        isLoading = true;
        loadProgress(isLoading);
        callAPI();
      }
    }
  }

  loadProgress(bool loadingStatus) {
    setState(() {
      isLoading = loadingStatus;
    });
  }

  callAPI() async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String bodyObj =
        '{"method":"userRegister","clientBusinessId":"$clientBusinessId","userName":"$userName","emailId":"$emailId","mobileNo":"$mobileNo","password":"$password"}';

    Response res = await post(Constant.url, headers: headers, body: bodyObj);
    print('pratik body' + bodyObj);
    var data = json.decode(res.body);


    if (data["Response"] == 'REGISTRATION_FAILED') {
      //login failed
      print('pratik Error');
      CommonMethods.showColoredToast("Registration Failed", Colors.red);
    }
    else if (data["Response"] == 'USER_ALREADY_REGISTER') {
      //login failed
      print('pratik Error');
      CommonMethods.showColoredToast("You are already registered with us", Colors.red);
    } else {
      CommonMethods.showColoredToast("Registration Successful", Colors.blue);
      print('pratik successs');
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool(Constant.isLogin, true);
      pref.setString(
          Constant.userId, data["Response"][0]["userId"].toString());
      pref.setString(
          Constant.userType, data["Response"][0]["userType"].toString());
      pref.setString(
          Constant.userName, data["Response"][0]["userName"].toString());
      pref.setString(
          Constant.mobileNo, data["Response"][0]["mobileNo"].toString());
      pref.setString(
          Constant.emailId, data["Response"][0]["emailId"].toString());

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()));
    }
    loadProgress(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.green,
      body:
      Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            child:
                            Column(
                              children: <Widget>[

                                TextField(
                                  onChanged: (text) {
                                    userName = text;
                                  },
                                  autofocus: false,
                                  autocorrect: false,
                                  decoration: InputDecoration(
                                      labelText: 'Username',
//                          errorText: 'Enter Product Name',
                                      border: OutlineInputBorder()),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                TextField(
                                  onChanged: (text) {
                                    emailId = text;
                                  },
                                  keyboardType: TextInputType.text,
                                  autofocus: false,
                                  autocorrect: false,
                                  decoration: InputDecoration(
                                      labelText: 'Email Id',
//                          errorText: 'Enter Mobile No',
                                      border: OutlineInputBorder()),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                TextField(
                                  onChanged: (text) {
                                    mobileNo = text;
                                  },
                                  keyboardType: TextInputType.number,
                                  autofocus: false,
                                  autocorrect: false,
                                  decoration: InputDecoration(
                                      labelText: 'Mobile No',
                                      border: OutlineInputBorder()),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                TextField(
                                  onChanged: (text) {
                                    password = text;
                                  },
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                  autofocus: false,
                                  autocorrect: false,
                                  decoration: InputDecoration(
                                      labelText: 'Password',
                                      border: OutlineInputBorder()),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                TextField(
                                  onChanged: (text) {
                                    confPassword = text;
                                  },
                                  obscureText: true,
                                  keyboardType: TextInputType.text,
                                  autofocus: false,
                                  autocorrect: false,
                                  decoration: InputDecoration(
                                      labelText: 'Confirm Password',
                                      border: OutlineInputBorder()),
                                ),
                                SizedBox(height: 10.0,),
                                RaisedButton(
                                  onPressed: checkRegistrationDetails,
                                  child: Text(
                                    "Submit",
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
                                maintainSize: true,
                                maintainAnimation: true,
                                maintainState: true,
                                visible: isLoading,
                                child: Container(
                                    margin:
                                    EdgeInsets.only(top: 50, bottom: 30),
                                    child: CircularProgressIndicator())),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
