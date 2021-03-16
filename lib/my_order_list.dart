import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'common/constant.dart';
import 'common/loader.dart';
import 'model/list_model.dart';
import 'order_details.dart';


class MyOrderList extends StatefulWidget {
  @override
  _MyOrderListState createState() => _MyOrderListState();
}

class _MyOrderListState extends State<MyOrderList> {
  String selectedId = "";
  bool isLoading = false;

  String selectedAddressId = "";
  String selectedAddress = "";
  bool isSelected = false;

  String userId = "";
  String clientBusinessId = "";

  Future<List<OrderListItems>> _getMyOrderList() async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    userId = pref.getString(Constant.userId);
    clientBusinessId = Constant.clientBusinessId;
   var res = await http.get(Constant.url + "?method=GetMyOrder&userId=" + userId+"&clientBusinessId="+clientBusinessId);
    var jsonObjRes = json.decode(res.body);
//    print(res);
    List<OrderListItems> listItems = [];

    if (jsonObjRes["Response"] == "LIST_NOT_AVAILABLE") {
      CommonMethods.showColoredToast("Orders Not Available.", Colors.red);
    } else {
      for (var u in jsonObjRes["Response"]) {
        print("Pratik u" + u.toString());
        OrderListItems item = OrderListItems(u["orderId"], u["orderDetails"],
            u["Amount"], u["status"], u["paymentDetails"], u["createdDate"], u["address"],
            u["landMark"], u["area"], u["city"], u["pincode"], u["userName"], u["mobileNo"], u["emailId"]);
        listItems.add(item);
      }
    }
    return listItems;
  }

  //order no amount date status
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders', style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              flex: 8,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                child: FutureBuilder(
                  future: _getMyOrderList(),
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
                              child:
                              InkWell(
                                child: Card(
                                  elevation: 10.0,
                                  child:
                                  Container(
                                    child:
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 4.0,
                                              bottom: 8.0,
                                            ),
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child:
                                              (itemData.status == "Completed") ?
                                              Icon(
                                                Icons.done,
                                                color: Colors.blue,
                                              ):Text(''),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "Order No: " + itemData.orderId,style: TextStyle(color: Colors.redAccent,fontSize: 15.0,fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                "Date: " + itemData.createdDate,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10.0,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "Amount: " + itemData.Amount,
                                              ),
                                              Text(
                                                "Status: " + itemData.status,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10.0,),
//                                          Row(
//                                            children: <Widget>[
//                                              Text("Name: " + itemData.userName),
//                                            ],
//                                          ),
//                                          SizedBox(height: 10.0,),
//                                          Row(
//                                            children: <Widget>[
//                                              Text(
//                                                "Mobile No: " + itemData.mobileNo,
//                                              ),
//                                            ],
//                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: (){
                                  //call details page
                                  Navigator.of(context).push(MaterialPageRoute (
                                      builder: (context) => OrderDetails(itemData)
                                  ));
                                },
                              ),
                              actions: <Widget>[
                                IconSlideAction(
                                  caption: 'Complete',
                                  color: Colors.blue,
                                  icon: Icons.mode_edit,
                                  onTap: () {
//                                    Navigator.of(context)
//                                        .push(MaterialPageRoute(
//                                      builder: (context) =>
//                                          AddAddressDetails(itemData),
//                                    ));
                                  },
                                ),
                              ],
                              secondaryActions: <Widget>[
                                IconSlideAction(
                                  caption: 'Cancel',
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () {
//                                    itemDeleteClicked(itemData);
                                  },
                                ),
                              ],
                            );
                          });
                    }
                  },
                ),
              )),
        ],
      ),
    );
  }
}
