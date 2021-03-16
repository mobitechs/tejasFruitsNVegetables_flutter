import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tejas_vegetables/common/loader.dart';
import '../common/constant.dart';
import '../model/list_model.dart';
import '../order_details.dart';


class AdminOrderList extends StatefulWidget {
  @override
  _AdminOrderListState createState() => _AdminOrderListState();
}

class _AdminOrderListState extends State<AdminOrderList> {
  String selectedId = "";
  bool isLoading = false;

  String selectedAddressId = "";
  String selectedAddress = "";
  bool isSelected = false;

  String userId = "";
  String clientBusinessId = "";
  String orderStatus = Constant.orderStatusArray[0];
  List<String> selectedItemOrderValue = List<String>();

  Future<List<OrderListItems>> _getAdminOrderList() async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    userId = pref.getString(Constant.userId);
    clientBusinessId = Constant.clientBusinessId;
    userId = "1";
    var res = await get(Constant.url + "?method=GetAllOrder&clientBusinessId="+clientBusinessId);
//    var res = await http.get(Constant.url + "?method=GetMyOrder&userId=" + userId+"&clientBusinessId="+clientBusinessId);
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

  changeOrderStatusAPI(String orderId,String orderStatus) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userId = pref.getString(Constant.userId);
    clientBusinessId = Constant.clientBusinessId;

    Map<String, String> headers = {"Content-type": "application/json"};
    String param =
    '{"method":"ChangeOrderStatus","clientBusinessId":"$clientBusinessId","orderId":"$orderId","orderStatus":"$orderStatus"}';

    Response res = await post(Constant.url, headers: headers, body: param);


    var data = json.decode(res.body);

    if (data["Response"] == "SUCCESS") {
      CommonMethods.showColoredToast("Status successfully changed.", Colors.green);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AdminOrderList()));
    } else {
      CommonMethods.showColoredToast("Failed to change status.", Colors.red);
    }
  }

  deleteOrderAPI(String orderId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userId = pref.getString(Constant.userId);
    clientBusinessId = Constant.clientBusinessId;

    Map<String, String> headers = {"Content-type": "application/json"};
    String param =
    '{"method":"DeleteOrder","clientBusinessId":"$clientBusinessId","orderId":"$orderId"}';

    Response res = await post(Constant.url, headers: headers, body: param);


    var data = json.decode(res.body);

    if (data["Response"] == "SUCCESS") {
      CommonMethods.showColoredToast("Order entry deleted successfully", Colors.green);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AdminOrderList()));
    } else {
      CommonMethods.showColoredToast("Error to delete order entry ", Colors.red);
    }
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
                  future: _getAdminOrderList(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return MyLoader();
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            var itemData = snapshot.data[index];
                            orderStatus =itemData.status;
                            selectedItemOrderValue.add(orderStatus);
                            return Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              child:
                              InkWell(
                                child: Card(

                                  elevation: 10.0,
                                  child: Container(
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
                                                "Status:"
                                              ),
                                              DropdownButton(
//                                                value: selectedItemOrderValue[index].toString(),
                                                items: _dropDownItem(),
                                                onChanged: (newVal) {
                                                  orderStatus = newVal;
                                                  changeOrderStatusAPI(itemData.orderId,newVal);
                                                },
                                                value: orderStatus,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10.0,),
                                          Row(
                                            children: <Widget>[
                                              Text("Name: " + itemData.userName),
                                            ],
                                          ),
                                          SizedBox(height: 10.0,),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                "Mobile No: " + itemData.mobileNo,
                                              ),
                                            ],
                                          ),

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
                                  caption: 'Completed',
                                  color: Colors.blue,
                                  icon: Icons.done,
                                  onTap: () {
                                    changeOrderStatusAPI(itemData.orderId,"Completed");
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
                                  deleteOrderAPI(itemData.orderId);
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

  List<DropdownMenuItem<String>> _dropDownItem() {
    List<String> ddl = Constant.orderStatusArray;
    return ddl
        .map((value) => DropdownMenuItem(
      value: value,
      child: Text(value,style: TextStyle(fontSize: 14),),
    ))
        .toList();
  }
}
