import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tejas_vegetables/auth/login_screen.dart';
import 'package:tejas_vegetables/callback/alert_btn_callback.dart';

import '../home.dart';

class Constant {
  static String clientBusinessId = "1";
  static String url = "https://mobitechs.in/KisanFreashAPI/api/KisanFreshApi.php";
  static String url2 = "http://mobitechs.in/LaundroCart/api.php";
  static String imgUrl = "https://mobitechs.in/KisanFreashAPI/images/";

  static String isLogin = "isLogin";
  static String userId = "userId";
  static String userType = "userType";
  static String userName = "userName";
  static String mobileNo = "mobileNo";
  static String emailId = "emailId";
  static String orderItemMsg = "orderItemMsg";
  static String orderTotalAmount = "orderTotalAmount";
  static int deliveryCharges = 100;
  static int deliveryChargesBelow = 500;

  static List<String> orderStatusArray = [
    "Received",
    "Accepted",
    "Placed",
    "Completed"
  ];
  static List<String> unitTypeArray = ["Grams", "Piece", "Packet", "Dozen", "Bunch", "Stick"];

  static List<String> weightArrayList2 = [
    "250 grams",
    "500 grams",
    "750 grams",
    "1 kg",
    "1.5 kg",
    "2 kg",
    "2.5 kg ",
    "3 kg",
    "3.5 kg",
    "4 kg",
    "4.5 kg",
    "5 kg"
  ];
  static List<String> pieceArrayList2 = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12"
  ];
  static List<double> weightArrayList = [
    0.250,
    500,
    750,
    1,
    1.5,
    2,
    2.5,
    3,
    3.5,
    4,
    4.5,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25
  ];
}

class CommonMethods {
  static void showColoredToast(String msg, Color red) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: red,
        textColor: Colors.white);
  }

  static bool checkLogin(SharedPreferences pref)  {
    bool isLogin = false;

    if (pref.getBool("isLogin") == true) {
      isLogin = true;
      // Navigator.of(context)
      //     .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      // Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (context) => LoginPage() //LoginPage
      //         ));
      isLogin = false;
    }

    return isLogin;
  }

  static void showAlert(String title, String message, String positiveBtnText,
      String negativeBtnText,BuildContext context,AlertBtnCallback alertBtnCallback) {
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
              negativeBtnText,
              style: TextStyle(color: Colors.red),
            ),
          ),
          FlatButton(
            onPressed: () {
              alertBtnCallback.positiveBtnClicked();
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
}
