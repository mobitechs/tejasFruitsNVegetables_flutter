import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tejas_vegetables/auth/registration.dart';
import 'package:tejas_vegetables/common/constant.dart';
import 'package:tejas_vegetables/model/category_list_model.dart';
import 'package:tejas_vegetables/model/list_model.dart';
import 'dart:convert';

import 'dart:async';

import '../home.dart';
import 'forgot_password_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = false;
  bool isLoading = false;
  bool visible = false;

  String userLoginId = "";
  String userLoginIdError = "";
  String password = "";
  String passwordError = "";
  String clientBusinessId = "";


  @override
  void initState() {
    super.initState();
    _getCategoryList();
  }


  loadProgress(bool visiblity) {
    setState(() {
      visible = visiblity;
    });
  }

  loginBtnClicked() {
    if (userLoginId == "") {
      CommonMethods.showColoredToast("Please enter Email/Mobile No.", Colors.red);
    } else if (password == "") {
      CommonMethods.showColoredToast("Please enter Password.", Colors.red);
    } else {
      visible = true;
      loadProgress(visible);
      callLoginAPI();
    }
  }

  void forgotPasswordbtnClicked() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ForgotPasswordPage(),
    ));
  }
  void registerBtnClicked() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Registration(),
    ));
  }

  callLoginAPI() async {
    clientBusinessId = Constant.clientBusinessId;
    Map<String, String> headers = {"Content-type": "application/json"};
    String bodyObj =
        '{"method":"userLogin","clientBusinessId":"$clientBusinessId","userLoginId":"$userLoginId","password":"$password"}';

    Response res = await post(Constant.url, headers: headers, body: bodyObj);
    print('pratik body' + bodyObj);
    var data = json.decode(res.body);

    visible = false;
    loadProgress(visible);
    if (data["Response"] == 'FAILED_LOGIN') {
      //login failed
      print('pratik Error');
      isLogin = false;
      CommonMethods.showColoredToast("Login Failed", Colors.red);
    } else {
      CommonMethods.showColoredToast("Login Success", Colors.blue);
      isLogin = true;
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

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => HomePage()),
        ModalRoute.withName('/'),
      );
    }
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
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 25.0),
                                  child: TextField(
                                    onChanged: (text) {
                                      userLoginId = text;
                                    },
                                    autofocus: false,
                                    autocorrect: false,
                                    decoration: InputDecoration(
                                      labelText: 'Email/Mobile',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: TextField(
                                    obscureText: true,
                                    onChanged: (text) {
                                      password = text;
                                    },
                                    autofocus: false,
                                    autocorrect: false,
                                    decoration: InputDecoration(
                                        labelText: 'Password',
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: forgotPasswordbtnClicked,
                                      child: Text(
                                        'Forgot Password',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0,bottom: 10.0),
                                  child:
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        MaterialButton(
                                          onPressed: registerBtnClicked,
                                          child: Text(
                                            'Register',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                          color: Colors.red,
                                        ),
                                        SizedBox(width: 10.0,),
                                        MaterialButton(
                                          onPressed: loginBtnClicked,
                                          child: Text(
                                            'Login',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                          color: Colors.red,
                                        ),
                                      ],
                                    ),

                                ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: <Widget>[
                                //     InkWell(
                                //       onTap: registerBtnClicked,
                                //       child: Text(
                                //         'Register Your Self',
                                //         style: TextStyle(
                                //             fontWeight: FontWeight.bold),
                                //       ),
                                //     )
                                //
                                //   ],
                                // ),
                              ],
                            ),
                          ),

                          Center(
                            child: Visibility(
                                maintainSize: true,
                                maintainAnimation: true,
                                maintainState: true,
                                visible: visible,
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

  _getCategoryList() async {
    SharedPreferences pref;
    pref = await SharedPreferences.getInstance();


    String clientBusinessId = Constant.clientBusinessId;

    var res = await get(Constant.url + "?method=GetCategoryList&clientBusinessId=" + clientBusinessId);
    var jsonObjRes = json.decode(res.body);
    List<CategoryListItems> listItems = [];
    List<String> nameArray = [];
    List<String> idArray = [];

    if (jsonObjRes["Response"] == "LIST_NOT_AVAILABLE") {
      CommonMethods.showColoredToast("Data Not Available.", Colors.red);
    } else {
      for (var u in jsonObjRes["Response"]) {
        CategoryListItems item =
        CategoryListItems(u["categoryId"], u["categoryName"]);

        CategoryListModel cm = CategoryListModel.fromJson(u);
        // print("Cmmmm:  " + json.encode(cm.toJson()));

        listItems.add(item);
        nameArray.add(item.categoryName);
        idArray.add(item.categoryId);
      }
      pref.setStringList("nameArray", nameArray);
      pref.setStringList("idArray", idArray);
      // pref.setString("categoryList", json.encode(listItems));
    }
  }
}
