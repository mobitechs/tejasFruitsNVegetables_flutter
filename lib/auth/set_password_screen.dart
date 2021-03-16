import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tejas_vegetables/auth/login_screen.dart';
import 'package:tejas_vegetables/common/constant.dart';
import 'package:http/http.dart';

class SetPasswordPage extends StatefulWidget {
  var email;
  SetPasswordPage(this.email);

  @override
  _SetPasswordPageState createState() => _SetPasswordPageState(email);
}

class _SetPasswordPageState extends State<SetPasswordPage> {
  var email;
  _SetPasswordPageState(this.email);

  String otp = "",password,confPassword;
  String validOTP = "";
  bool isLoading = false;
  String clientBusinessId = Constant.clientBusinessId;




  submitBtnClicked() {
    if (otp == "") {
      CommonMethods.showColoredToast("Enter enter OTP.", Colors.red);
    }else if (password == "") {
      CommonMethods.showColoredToast("Enter enter password.", Colors.red);
    } else if (confPassword == "") {
      CommonMethods.showColoredToast("Enter enter confirm password.", Colors.red);
    }else {
     if(password != confPassword){
        CommonMethods.showColoredToast("Passwords and confirm password is not same", Colors.red);
      }
      else{
        isLoading = true;
        loadProgress(isLoading);
        callSetPasswordAPI();
      }
    }
  }

  loadProgress(bool loadingStatus) {
    setState(() {
      isLoading = loadingStatus;
    });
  }

  callSetPasswordAPI() async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String bodyObj =
        '{"method":"SetPassword","clientBusinessId":"$clientBusinessId","otp":"$otp","email":"$email","password":"$password"}';

    Response res = await post(Constant.url, headers: headers, body: bodyObj);
    print('pratik body' + bodyObj);
    var data = json.decode(res.body);


    if (data["Response"] == 'NEW_PASSWORD_SUCCESSFULLY_SET') {
      CommonMethods.showColoredToast("Password Successfully set.", Colors.blue);

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()));
    }
    else {
      print('pratik Error');
      CommonMethods.showColoredToast("Failed to set password.", Colors.red);

    }
    loadProgress(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Stack(
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
                      child: Column(
                        children: <Widget>[
                          TextField(
                            onChanged: (text) {
                              otp = text;
                            },
                            autofocus: false,
                            autocorrect: false,
                            decoration: InputDecoration(
                              labelText: 'OTP',
                              border: OutlineInputBorder(),
                            ),
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
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 25.0),
                            child: MaterialButton(
                              onPressed: submitBtnClicked,
                              child: Text(
                                'Submit',
                                style: TextStyle(color: Colors.white),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              color: Colors.red,
                            ),
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
