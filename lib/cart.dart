import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'package:tejas_vegetables/callback/alert_btn_callback.dart';
import 'address_list.dart';
import 'auth/login_screen.dart';
import 'common/constant.dart';
import 'model/list_model.dart';
import 'model/product_list_model.dart';

class Cart extends StatefulWidget {
  final List<ProductListModel> _cart;

  Cart(this._cart);

  @override
  _CartState createState() => _CartState(this._cart);
}

class _CartState extends State<Cart> implements AlertBtnCallback{
  _CartState(this._cart);

  SharedPreferences pref;
  List<ProductListModel> _cart= List<ProductListModel>();
  // List<ProductListModel> _cart2 = new List<ProductListModel>();
  int totalAmount = 0;
  int finalAmount = 0;
  String finalMsg = "";

  String ddlWeight;
  String ddlPiece;
  String _qtyWisePrice="";

  int qty = 1;
  int qtyPos = 0;
  int weight;
  int amount, price;
  int amountRemainingForFreeDel = 0;
  bool showDelivery = true;
  List<String> selectedItemWeightValue = List<String>();
  List<String> selectedItemPieceValue = List<String>();

  @override
  void initState() {
    super.initState();
    // _cart2.addAll(_cart);
    getSharedPrefData();
//    for (var item in _cart) {
//      totalAmount = totalAmount + int.parse(item.finalPrice);
//    }
//    checkDeliveryCharges();
    calculateTotalPrice();
    setState(() {});
    //placeOrder();
  }

  getSharedPrefData() async {
    pref = await SharedPreferences.getInstance();
     _cart = pref.getString("_cartList") as List<ProductListModel>;
    // _cart = json.decode(pref.getString("_cartList"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: _buildListView(),
          ),
          SizedBox(
            height: 1,
            child: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.blueAccent)),
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Total Amount",
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Rs." + totalAmount.toString(),
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.bold),
                          ),
                          Visibility(
                            visible: showDelivery,
                            child: Text(
                              "+Rs." +
                                  Constant.deliveryCharges.toString() +
                                  " Delivery Charges",
                              style: TextStyle(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ),
                          Visibility(
                            visible: showDelivery,
                            child: Text(
                              "Buy More Rs." +
                                  amountRemainingForFreeDel.toString() +
                                  " to get free delivery",
                              style: TextStyle(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(border: Border.all()),
                      child: RaisedButton(
                        onPressed: () {
                          placeOrder();
                        },
                        color: Colors.deepOrange,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            "Place Order",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

//      _buildListView(),
    );
  }

  ListView _buildListView() {
    return ListView.builder(
        itemCount: _cart.length,
        itemBuilder: (context, index) {
          var item = _cart[index];
          int pos = index;
          String proId = item.productId;
          String prodName = item.productName;
          String proWeight = item.weight;
          String proPrice = item.finalPrice;
          int proQty = (item.qty != null) ? item.qty : 1;
          String unite = item.uniteType;
          int qtyPos = item.qtyPos;
          String qtyWisePrice =(item.qtyWisePrice != null) ? item.qtyWisePrice : item.finalPrice;

          // selectedItemWeightValue.add("250 grams");
          // selectedItemPieceValue.add("1");
          selectedItemWeightValue.add(Constant.weightArrayList2[qtyPos]);
          selectedItemPieceValue.add(Constant.pieceArrayList2[qtyPos]);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: Card(
              elevation: 4.0,
              child: Stack(
                children: [
                  ListTile(
                    leading: Image.network(item.img, height: 70, width: 70,),
                    title: Text(prodName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Rs." + proPrice,
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(proWeight + " " + unite),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text("Qty  "),
                                SizedBox(width:10.0),
                                Container(
                                    child: (unite == "Grams")
                                        ? DropdownButton(
                                      value: selectedItemWeightValue[index].toString(),
                                      items: _dropDownWeightItem(),
                                      onChanged: (newVal) {
                                        qtyPos = Constant.weightArrayList2.indexOf(newVal);
                                        selectedItemWeightValue[index] = newVal;
                                        setState(() {
                                          ddlWeight = newVal;
                                          var abc = ddlWeight.split(" ");
                                          String dwight = abc[0];
                                          double pqr = double.parse(dwight);
                                          double pqty;
                                          if (pqr > 100) {
                                            pqty = pqr / 250;
                                          } else {
                                            pqr = pqr * 1000;
                                            pqty = pqr / 250;
                                          }
                                          qty = pqty.toInt();
                                          int totalPrice = (pqty * int.parse(proPrice)).toInt();
                                          qtyWisePrice = (totalPrice).toString();
                                          final tile = _cart.firstWhere(
                                                  (item) => item.productId == proId);
                                          tile.qtyPos = qtyPos;
                                          tile.qty = qty;
                                          tile.qtyWisePrice = qtyWisePrice;

                                          calculateTotalPrice();
                                        });
                                      },
                                    )
                                        : DropdownButton(
                                      value: selectedItemPieceValue[index].toString(),
                                      items: _dropDownPieceItem(),
                                      onChanged: (newVal) {
                                        qtyPos = Constant.pieceArrayList2.indexOf(newVal);
                                        selectedItemPieceValue[index] = newVal;
                                        setState(() {
                                          ddlPiece = newVal;

                                          qty = int.parse(ddlPiece);
                                          qtyWisePrice = (qty * int.parse(proPrice)).toString();
                                          final tile = _cart.firstWhere(
                                                  (item) => item.productId == proId);
                                          tile.qty = qty;
                                          tile.qtyPos = qtyPos;
                                          tile.qtyWisePrice = qtyWisePrice;

                                          calculateTotalPrice();
                                        });
                                      },
                                    )),
                              ],
                            ),

                            Text("  Rs."+qtyWisePrice),

                          ],
                        ),
                      ],
                    ),
                  ),

                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GestureDetector(
                        child: Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                        onTap: () {
                          setState(() {
                            _cart.remove(item);
                            // _cart.remove(item);
                            pref.setString("_cartList", json.encode(_cart));
                            calculateTotalPrice();
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),

            ),
          );
        });
  }

  List<DropdownMenuItem<String>> _dropDownWeightItem() {
    List<String> ddl = Constant.weightArrayList2;
    return ddl
        .map((value) => DropdownMenuItem(
              value: value,
              child: Text(
                value,
                style: TextStyle(fontSize: 14),
              ),
            ))
        .toList();
  }

  List<DropdownMenuItem<String>> _dropDownPieceItem() {
    List<String> ddl = Constant.pieceArrayList2;
    return ddl
        .map((value) => DropdownMenuItem(
              value: value,
              child: Text(
                value,
                style: TextStyle(fontSize: 14),
              ),
            ))
        .toList();
  }

  void checkDeliveryCharges() {
    if (finalAmount > Constant.deliveryChargesBelow) {
      amountRemainingForFreeDel = 0;
      showDelivery = false;

      finalMsg = finalMsg + ",Delivery Charges = " + "0";
    } else {
      amountRemainingForFreeDel = Constant.deliveryChargesBelow - finalAmount;
      showDelivery = true;

      finalAmount = finalAmount + Constant.deliveryCharges;

      finalMsg = finalMsg +
          ",Delivery Charges = " +
          Constant.deliveryCharges.toString()+" Rs.";
    }

    finalMsg = finalMsg + ",Total Amount = " + finalAmount.toString()+" Rs.";
    print(finalMsg);
  }

  void calculateTotalPrice() {
    String pName, pAmount, msg = ",";
    int no = 0, pQty, total = 0, fTotal = 0;
    if (_cart.length > 0) {
      for (var item in _cart) {
        no++;
        pName = item.productName;
        pQty = (item.qty != null) ? item.qty : 1;
        String qtyWisePrice = (item.qtyWisePrice != null) ? item.qtyWisePrice : item.finalPrice;
        pAmount = item.finalPrice;
        total = pQty * int.parse(pAmount);
        // total = int.parse(qtyWisePrice);
        fTotal = fTotal + total;

        String uniteType = item.uniteType;
        String unite = "";
        String mydata ="";
        if (uniteType == "0") {
          unite = "grams";
          mydata =  "   Qty: " + Constant.weightArrayList2[item.qtyPos];
        } else {
          unite = "piece";
          mydata =  "   Qty: " + pQty.toString() + " * " + " " + pAmount.toString();
        }

//      print(pName+" "+pQty.toString()+" "+pAmount.toString()+" "+total.toString());
//here ,(comma works as a next line)
        msg = msg +
            no.toString() + ". " +
            pName + ", " +
           mydata+
            " = " +
            total.toString() +
            " Rs. ,";
      }
      msg = msg + ",Amount = " + fTotal.toString()+" Rs.";

      finalAmount = fTotal;
      totalAmount = finalAmount;
      finalMsg = msg;
      //  print(msg);
      checkDeliveryCharges();
    } else {
      showDelivery =false;
      finalAmount = 0;
      totalAmount = 0;
      finalMsg = "";
    }

//    totalAmount = finalAmount;
    setState(() {});
  }

  Future<void> placeOrder() async {
    // FlutterOpenWhatsapp.sendSingleMessage("+91 70212 80750", msg);
    SharedPreferences pref = await SharedPreferences.getInstance();

    bool isLogin = CommonMethods.checkLogin(pref);
    pref.setString("_cartList", json.encode(_cart));

    if (isLogin == true) {

      pref.setString(Constant.orderItemMsg, finalMsg);
      pref.setString(Constant.orderTotalAmount, finalAmount.toString());

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AddressListPage()));
    } else {
      CommonMethods.showAlert("Confirmation","You have not logged in yet. Do want to login?","Yes","No",context,this);
    }
  }

  getWeightQty(Product item, String ddlValue, String proId) {
    var itemPrice = item.finalPrice;

    var abc = ddlValue.split(" ");
    int pqr = int.parse(abc[0]);

    var pqty;
    if (pqr > 100) {
      pqty = pqr / 250;
    } else {
      pqr = pqr * 1000;
      pqty = pqr / 250;
    }
    var pamt = int.parse(itemPrice) * pqty;
    // print("aaa: " + pamt.toString());
    calculateAmount(item, pqty, proId);
  }

  getPieceQty(Product item, String ddlValue, String proId) {
    var itemPrice = item.finalPrice;
    int pqty = int.parse(ddlValue);
    var pamt = int.parse(itemPrice) * pqty;
    // print("aaa: " + pamt.toString());
    calculateAmount(item, pqty, proId);
  }

  calculateAmount(Product item, pqty, String proId) {
    final tile = _cart.firstWhere((item) => item.productId == proId);
    tile.qty = qty;
    calculateTotalPrice();
  }

  @override
  void positiveBtnClicked() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
