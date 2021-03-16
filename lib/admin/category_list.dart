import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tejas_vegetables/common/constant.dart';
import 'package:tejas_vegetables/common/loader.dart';
import 'package:tejas_vegetables/model/list_model.dart';

import 'add_category.dart';

class CategoryList extends StatefulWidget {

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {


  String selectedId ="";
  bool isLoading = true;
  String clientBusinessId = "";

  loadProgress(bool loadingStatus) {
    setState(() {
      isLoading = loadingStatus;
    });
  }

  Future<List<CategoryListItems>> _getCategoryList() async {

    clientBusinessId = Constant.clientBusinessId;

    var res = await http.get(Constant.url + "?method=GetCategoryList&clientBusinessId="+clientBusinessId);
    var jsonObjRes = json.decode(res.body);
    List<CategoryListItems> listItems = [];

    if (jsonObjRes["Response"] == "LIST_NOT_AVAILABLE") {
      CommonMethods.showColoredToast("Data Not Available.", Colors.red);
    } else {
      for (var u in jsonObjRes["Response"]) {
        CategoryListItems item =
        CategoryListItems(u["categoryId"], u["categoryName"]);
        listItems.add(item);
      }
    }
    isLoading = false;
    loadProgress(isLoading);
    return listItems;
  }

  _deleteCategory() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userId = pref.getString(Constant.userId);

    Map<String, String> headers = {"Content-type": "application/json"};
    String bodyObj =
        '{"method":"DeleteCategory","categoryId":"$selectedId","clientBusinessId":"$clientBusinessId"}';

    http.Response res =
    await http.post(Constant.url, headers: headers, body: bodyObj);
    var data = json.decode(res.body);

    if (data["Response"] == 'SUCCESS') {
      CommonMethods.showColoredToast("Successfully Deleted", Colors.green);

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => CategoryList()));
    } else {
      CommonMethods.showColoredToast("Failed to Delete", Colors.red);
    }

    isLoading = false;
    loadProgress(isLoading);
  }

  itemDeleteClicked(itemData) {
    selectedId = itemData.categoryId;
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
              isLoading = true;
              loadProgress(isLoading);
              _deleteCategory();
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category', style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        child:
        FutureBuilder(
          future: _getCategoryList(),
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
                      child: Card(
                        elevation: 10.0,
                        child: ListTile(
                          onTap: () {},
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
//                          Text("Flat No: " +itemData.wingName+" "+ itemData.flatNo),
                              Text("Category: " + itemData.categoryName),
                            ],
                          ),
                        ),
                      ),
                      actionExtentRatio: 0.25,
                      actions: <Widget>[
                        IconSlideAction(
                          caption: 'Edit',
                          color: Colors.blue,
                          icon: Icons.mode_edit,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AddCategory(itemData),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddCategory(null),
          ));
        },
        elevation: 10.0,
        child: Icon(Icons.add),
      ),
    );
  }
}
