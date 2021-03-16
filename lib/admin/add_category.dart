import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tejas_vegetables/common/constant.dart';
import 'package:tejas_vegetables/common/loader.dart';

import 'category_list.dart';

class AddCategory extends StatefulWidget {

  var itemData;
  AddCategory(this.itemData);

  @override
  _AddCategoryState createState() => _AddCategoryState(itemData);
}

class _AddCategoryState extends State<AddCategory> {
  var itemData;
  _AddCategoryState(this.itemData);

  TextEditingController _controller;

  bool isLoading = false;
  String categoryId = "";
  String categoryName = "";
  String errorText = "";
  String btnText ="Add Category";
  String pageTitle ='Add Category Details';
  String imFor = "Add";
  String successMsg = "Category details successfully added.";
  String errorMsg = "Failed to add category details.";
//  String clientBusinessId = "";
  String clientBusinessId = Constant.clientBusinessId;

  @override
  void initState() {
    super.initState();
    if(itemData != null){
      categoryName = itemData.categoryName;
      categoryId = itemData.categoryId;


      imFor = "Update";
      btnText = "Update Category";
      pageTitle ='Update Category Details';
      successMsg = "Category details successfully updated.";
      errorMsg = "Failed to update category details.";

      _controller = new TextEditingController(text: categoryName);

      setState(() {

      });
    }
  }

  addCategoryDetails() {
    if (categoryName == "") {
      errorText = "Please Enter Category Name";
    } else {
      isLoading = true;
      loadProgress(isLoading);
      callAPI();
    }
  }

  void callAPI() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userId = pref.getString(Constant.userId);
    clientBusinessId = Constant.clientBusinessId;
    
    Map<String, String> headers = {"Content-type": "application/json"};
    String param;

    if(imFor=="Add"){
      param =
      '{"method":"AddCategory","clientBusinessId":"$clientBusinessId","categoryName":"$categoryName"}';
    }else{
      param =
      '{"method":"UpdateCategory","clientBusinessId":"$clientBusinessId","categoryId":"$categoryId","categoryName":"$categoryName"}';
    }

    Response res = await post(Constant.url, headers: headers, body: param);

    isLoading = false;
    loadProgress(isLoading);
    var data = json.decode(res.body);

    if (data["Response"] == "SUCCESS") {
      CommonMethods.showColoredToast(successMsg, Colors.green);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => CategoryList()));
    } else {
      CommonMethods.showColoredToast(errorMsg, Colors.red);
    }
  }

  loadProgress(bool loadingStatus) {
    setState(() {
      isLoading = loadingStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle, style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _controller,
                      onChanged: (text) {
                        categoryName = text;
                      },
                      autocorrect: false,
                      autofocus: false,
                      decoration: InputDecoration(
                          labelText: 'Category Name',
                          errorText: errorText,
                          border: OutlineInputBorder()),
                    ),
                  ),
                  RaisedButton(
                    onPressed: addCategoryDetails,
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
          ),
          Center(
            child: Visibility(
              visible: isLoading,
              child: MyLoader(),
            ),
          )
        ],
      ),
    );
  }
}

