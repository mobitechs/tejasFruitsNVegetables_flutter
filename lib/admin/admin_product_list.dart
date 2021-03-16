import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tejas_vegetables/common/constant.dart';
import 'package:tejas_vegetables/common/loader.dart';
import 'package:tejas_vegetables/model/list_model.dart';
import 'add_product.dart';


class AdminProductList extends StatefulWidget {
  @override
  _AdminProductListState createState() => _AdminProductListState();
}

class _AdminProductListState extends State<AdminProductList> {

  List<Product> _dishes = List<Product>();

  bool isLoading = true;
  String clientBusinessId = "";
  String selectedId = "";

  @override
  void initState() {
    super.initState();
    _getProductList();
  }

  loadProgress(bool loadingStatus) {
    setState(() {
      isLoading = loadingStatus;
    });
  }

  Future<List<Product>> _getProductList() async {
    clientBusinessId = Constant.clientBusinessId;

    var res = await http.get(Constant.url +
        "?method=GetProductList&clientBusinessId=" +
        clientBusinessId);
    var jsonObjRes = json.decode(res.body);

    List<Product> listItems = [];

    if (jsonObjRes["Response"] == "LIST_NOT_AVAILABLE") {
      CommonMethods.showColoredToast("Data Not Available.", Colors.red);
    } else {
      for (var u in jsonObjRes["Response"]) {
        Product item = Product(
            u["productId"],
            u["categoryId"],
            u["categoryName"],
            u["productName"],
            u["description"],
            u["amount"],
            u["finalPrice"],
            u["uniteType"],
            u["weight"],
            u["img"],
            1);
//        print("Pratik event"+ eventItem.toString());
        listItems.add(item);
      }
    }
    isLoading = false;
    loadProgress(isLoading);
    return listItems;
  }

  _deleteProduct() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userId = pref.getString(Constant.userId);

    Map<String, String> headers = {"Content-type": "application/json"};
    String bodyObj =
        '{"method":"DeleteProduct","productId":"$selectedId","clientBusinessId":"$clientBusinessId"}';

    http.Response res =
    await http.post(Constant.url, headers: headers, body: bodyObj);
    var data = json.decode(res.body);

    if (data["Response"] == 'SUCCESS') {
      CommonMethods.showColoredToast("Successfully Deleted", Colors.green);

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AdminProductList()));
    } else {
      CommonMethods.showColoredToast("Failed to Delete", Colors.red);
    }

    isLoading = false;
    loadProgress(isLoading);
  }

  itemDeleteClicked(itemData) {
    selectedId = itemData.flatId;
    showAlertDialog("Confirmation", "Do you really want to delete this?");
  }

  void showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false, //to avoid outside click to cancel
      builder: (context) =>
          AlertDialog(
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
                  _deleteProduct();
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
        title: Text("Product", style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getProductList(),
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
                      child:
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 2.0,
                        ),
                        child: Card(
                          elevation: 4.0,
                          child: ListTile(
                            leading: Image.network(
                              // Constant.imgUrl + itemData.imgUrl,
                             itemData.imgUrl,
                            ),
                            title: Text(itemData.productName),
                            subtitle: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(itemData.weight + " grams"),
                                  ],
                                ),
                                SizedBox(height: 5.0,),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Offer Rs." + itemData.finalPrice,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Rs." + itemData.amount,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 14,
                                          decoration: TextDecoration
                                              .lineThrough),
                                    ),
                                  ],
                                ),
                              ],
                            ),

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
                              builder: (context) => AddProduct(itemData),
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
            builder: (context) => AddProduct(null),
          ));
        },
        elevation: 10.0,
        child: Icon(Icons.add),
      ),
    );
  }
}
