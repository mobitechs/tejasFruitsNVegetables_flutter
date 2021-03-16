import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tejas_vegetables/search_demo.dart';

import 'auth/login_screen.dart';
import 'common/constant.dart';
import 'home.dart';
import 'model/category_list_model.dart';
import 'model/list_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tejas Vegetables & Fruits',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences pref;
  List<CategoryListItems> listItems = [];
  List<String> nameArray = [];
  List<String> idArray = [];
  List<CategoryListModel> categoriesModel = List<CategoryListModel>();

  @override
  void initState() {
    super.initState();
    _getCategoryList();
    // checkLogin();
  }

  _getCategoryList() async {

    String clientBusinessId = Constant.clientBusinessId;
    var res = await get(Constant.url +
        "?method=GetCategoryList&clientBusinessId=" +
        clientBusinessId);
    var jsonObjRes = json.decode(res.body);

    if (jsonObjRes["Response"] == "LIST_NOT_AVAILABLE") {
      CommonMethods.showColoredToast("Data Not Available.", Colors.red);
    } else {
      List<CategoryListModel> list = [];
      for (var u in jsonObjRes["Response"]) {
        CategoryListItems item =
            CategoryListItems(u["categoryId"], u["categoryName"]);

        CategoryListModel cm = CategoryListModel.fromJson(u);
        list.add(cm);
        listItems.add(item);
        nameArray.add(item.categoryName);
        idArray.add(item.categoryId);
      }
      //CommonMethods.showColoredToast("Data ."+list[0].categoryName, Colors.purple);

      categoriesModel = list;
      // setSharedPrefData();
      checkLogin();
    }
  }

  setSharedPrefData() async {
    // CommonMethods.showColoredToast("Im her Bhai", Colors.blue);
    pref = await SharedPreferences.getInstance();
    pref.setString("key", "Pratik");
    // pref.setStringList("nameArray", nameArray);
    // pref.setStringList("idArray", idArray);
    pref.setString("categoriesModel", json.encode(categoriesModel));
    // pref.setString("categoryList", json.encode(listItems));

    // CommonMethods.showColoredToast("Im inside check login", Colors.purple);
    // Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (context) => HomePage() //LoginPage//SearchList//HomePage
    //     ));

  }

  checkLogin()  {
    // CommonMethods.showColoredToast("Im inside check login", Colors.red);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage() //LoginPage//SearchList//HomePage
        ));
  }

  // checkLogin() async {
  //   CommonMethods.showColoredToast("Im inside check login", Colors.red);
  //   Navigator.of(context).pushReplacement(
  //     MaterialPageRoute(builder: (context) => HomePage() //LoginPage//SearchList//HomePage
  //         ));
  // }

  @override
  Widget build(BuildContext context) {
    Future<void> checkLogin() async {
      SharedPreferences pref = await SharedPreferences.getInstance();

      if (pref.getBool("isLogin") == true) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginPage() //LoginPage
                ));
      }
    }

//    Timer(
//      Duration(seconds: 3),
//          ()=> checkLogin(),
//    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.lightGreen,
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/images/ic_launcher.png'),
                height: 300,
                width: 300,
              ),
//              Text(
//                'Tejas Fruits and Vegetables',
//                style: TextStyle(
//                    fontSize: 35.0,
//                    fontWeight: FontWeight.w700,
//                    color: Colors.white),
//              ),
            ],
          ),
        ),
      ),
    );
  }
}
