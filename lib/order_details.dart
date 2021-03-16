import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetails extends StatefulWidget {
  var orderItem;
  OrderDetails(this.orderItem);

  @override
  _OrderDetailsState createState() => _OrderDetailsState(this.orderItem);
}

class _OrderDetailsState extends State<OrderDetails> {
  _OrderDetailsState(this.orderItem);

  SharedPreferences pref;
  String title = "";
  String userType = "";

  var orderItem;
  String orderItemsDetails="";

  @override
  void initState() {
    super.initState();
    getSharedPrefData();

    orderItemsDetails = orderItem.orderDetails;
    orderItemsDetails = orderItemsDetails.replaceAll(',', '\n');

  }

  getSharedPrefData() async {
    pref = await SharedPreferences.getInstance();
    userType = pref.getString("userType");
    if (userType == "Admin") {
      title = "Customer Details";
    } else {
      title = "Owner Details";
    }

    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Order', style: TextStyle(color: Colors.white),),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body:Container(
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('Order Details', style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                ],
              ), SizedBox(height: 10.0,),
              Row(
                children: <Widget>[
                  Text(orderItemsDetails),
                ],
              ),
              SizedBox(height: 20.0,),
              Row(
                children: <Widget>[
                  Text('Address Details', style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                ],
              ),
              SizedBox(height: 10.0,),
              Row(
                children: <Widget>[
                  Text("Address: "+orderItem.address),
                ],
              ),
              Row(
                children: <Widget>[
                  Text("Landmark: "+orderItem.landMark),
                ],
              ),
              Row(
                children: <Widget>[
                  Text("Area: "+orderItem.area),
                ],
              ),
              Row(
                children: <Widget>[
                  Text("City: "+orderItem.city),
                ],
              ),
              Row(
                children: <Widget>[
                  Text("Pincode: "+orderItem.pincode),
                ],
              ),
              SizedBox(height: 20.0,),
              Row(
                children: <Widget>[
                  Text(title, style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                ],
              ),
              SizedBox(height: 10.0,),
              Row(
                children: <Widget>[
                  Text("Name: "+orderItem.userName),
                ],
              ),
              Row(
                children: <Widget>[
                  Text("Mobile No: "+orderItem.mobileNo),
                ],
              ),
              Row(
                children: <Widget>[
                  Text("Email: "+orderItem.emailId),
                ],
              ),

            ],
          ),
        )
    );
  }
}
