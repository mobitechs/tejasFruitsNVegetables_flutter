import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:tejas_vegetables/auth/set_password_screen.dart';
import 'package:tejas_vegetables/common/constant.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String email="";
  String emailError="";
  bool isLoading = false;
  String clientBusinessId = Constant.clientBusinessId;

  submitBtnClicked(){
    if (email == "") {
      CommonMethods.showColoredToast("Enter enter email.", Colors.red);
    }else {
      print("hioooooo");
      isLoading = true;
      loadProgress(isLoading);
      callForgotPasswordAPI();
    }
  }


  loadProgress(bool loadingStatus) {
    setState(() {
      isLoading = loadingStatus;
    });
  }

  callForgotPasswordAPI() async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String bodyObj =
        '{"method":"ForgotPassword","clientBusinessId":"$clientBusinessId","email":"$email"}';
    print("hieeeee"+bodyObj);
    Response res = await post(Constant.url, headers: headers, body: bodyObj);
    print('pratik body' + bodyObj);
    var data = json.decode(res.body);


    if (data["Response"] == 'RANDOM_NO_SUCCESSFULLY_UPDATED') {
      CommonMethods.showColoredToast("OTP sent on your email.", Colors.blue);

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SetPasswordPage(email)));
    }
    else {
      print('pratik Error');
      CommonMethods.showColoredToast("This email id not registered with us.", Colors.red);

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
                          Padding(
                            padding: EdgeInsets.only(top: 25.0),
                            child: TextField(
                              onChanged: (text) {
                                email = text;
                              },
                              autofocus: false,
                              autocorrect: false,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 25.0),
                            child: MaterialButton(
                              onPressed:  submitBtnClicked,
                              child: Text(
                                'Submit',
                                style: TextStyle(color: Colors.white),
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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
