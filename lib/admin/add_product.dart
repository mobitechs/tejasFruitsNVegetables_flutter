import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tejas_vegetables/common/constant.dart';
import 'package:tejas_vegetables/common/loader.dart';
import 'package:tejas_vegetables/model/list_model.dart';

import 'admin_product_list.dart';

class AddProduct extends StatefulWidget {
  var itemData;

  AddProduct(this.itemData);

  @override
  _AddProductState createState() => _AddProductState(itemData);
}

class _AddProductState extends State<AddProduct> {
  var itemData;

  _AddProductState(this.itemData);

  String btnText = "Add Product";
  String pageTitle = 'Add Product Details';
  String imFor = "Add";
  String successMsg = "Product details successfully added.";
  String errorMsg = "Failed to add product details.";
  String imgBtnText = "Add Image";
  TextEditingController _controllerProductName, _controllerDescription, _controllerAmount, _controllerFinalPrice, _controllerWeight;

  bool isLoading = false,weightVisiblity = false;

  String userId, userType, productName, productId, categoryId, categoryName, description, amount="", finalPrice, weight,uniteType,productImgPath;
  int imgFor;
  String clientBusinessId = Constant.clientBusinessId;

  List<CategoryListItems> categoryListItems = [];

  File image, productImg;
  final picker = ImagePicker();


  void getSharedPrefData() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    userId = pref.getString(Constant.userId);
    userType = pref.getString(Constant.userType);
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefData();
    this._getCategoryList();

    if (itemData != null) {
      print("itemmmmmm "+itemData.toString());
      productId = itemData.productId;
      productName = itemData.productName;
      // productImgPath = Constant.imgUrl + itemData.imgUrl;
      productImgPath = itemData.imgUrl;
      description = itemData.description;
      amount = itemData.amount.toString();
      finalPrice = itemData.finalPrice;
      weight = itemData.weight;
      categoryId = itemData.categoryId;
      categoryName = itemData.categoryName;
      uniteType = itemData.uniteType;
      weightVisiblity = true;

      imFor = "Update";
      btnText = "Update Product";
      pageTitle = 'Update Product Details';
      successMsg = "Product details successfully updated.";
      errorMsg = "Failed to update Product details.";
      imgBtnText = "Change Image";

      _controllerProductName = new TextEditingController(text: productName);
      _controllerDescription = new TextEditingController(text: description);
      _controllerAmount = new TextEditingController(text: amount);
      _controllerFinalPrice = new TextEditingController(text: finalPrice);
      _controllerWeight = new TextEditingController(text: weight);
      setState(() {});
    }
  }

  Future<String> _getCategoryList() async {
    var res = await http.get(Constant.url +
        '?method=GetCategoryList&clientBusinessId=' +
        clientBusinessId);
    var jsonObj = json.decode(res.body);

    if (jsonObj["Response"] == "LIST_NOT_AVAILABLE") {
      CommonMethods.showColoredToast("Data Not Available.", Colors.red);
    } else {
      print("category data" + jsonObj.toString());
      for (var u in jsonObj["Response"]) {
        CategoryListItems item =
            CategoryListItems(u["categoryId"], u["categoryName"]);
        categoryListItems.add(item);
      }
    }
    setState(() {});
    return "Sucess";
  }

  showImagePickerDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Column(
          children: <Widget>[
            Text('Select Image From'),
            SizedBox(
              height: 40.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  onTap: getImageFromCamera,
                  child: Column(
                    children: <Widget>[Text('Camera'),SizedBox(
                      height: 10.0,
                    ), Icon(Icons.camera)],
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                InkWell(
                  onTap: getImageFromGallery,
                  child: Column(
                    children: <Widget>[
                      Text('Gallery'),SizedBox(
                        height: 10.0,
                      ),
                      Icon(Icons.photo_album)
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        elevation: 10.0,
      ),
    );
  }

  Future getImageFromCamera() async {
    print("Camera get called");
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    Navigator.pop(context);
    setState(() {
      image = File(pickedFile.path);
      imageFor();
    });
  }

  Future getImageFromGallery() async {
    print("gallery get called");
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    Navigator.pop(context);
    setState(() {
      image = File(pickedFile.path);
      imageFor();
    });
  }

  imageFor() {
    if (imgFor == 1) {
      productImg = image;
      productImgPath = productImg.path;
    }

    setState(() {

    });
  }

  addingProductDetails() {
    if (productName == "") {
      CommonMethods.showColoredToast("Enter product name.", Colors.red);
    } else if (amount == null) {
      CommonMethods.showColoredToast("Please amount.", Colors.red);
    } else if (finalPrice == "") {
      CommonMethods.showColoredToast("Enter final amount.", Colors.red);
    } else if (weight == "") {
      CommonMethods.showColoredToast("Enter weight.", Colors.red);
    }else if (uniteType == "") {
      CommonMethods.showColoredToast("Select Unite Type.", Colors.red);
    } else {
      isLoading = true;
      loadProgress(isLoading);
      callAPI();
    }
  }

  loadProgress(bool loadingStatus) {
    setState(() {
      isLoading = loadingStatus;
    });
  }

  callAPI() async {
    Map<String, String> header = {"Content-type": "application/json"};

    try {
      var request = http.MultipartRequest('POST', Uri.parse(Constant.url));
      String method="";
      if (imFor == "Add") {
        method = "AddProduct";
      } else {
        if(productImg != null){
          request.files.add(await http.MultipartFile.fromPath('img', productImg.path));
          print("Pathhhhh: "+productImg.path);
        }
        method = "UpdateProduct";
        request.fields['productId'] = productId;
      }
      request.fields['method'] = method;
      request.fields['productName'] = productName;
      request.fields['categoryId'] = categoryId;
      request.fields['description'] = description;
      request.fields['amount'] = amount;
      request.fields['finalPrice'] = finalPrice;
      request.fields['weight'] = weight;
      request.fields['weight'] = weight;
      request.fields['uniteType'] = uniteType;
      request.fields['clientBusinessId'] = clientBusinessId;
      request.headers.addAll(header);

      var res = await request.send();
      var response = await http.Response.fromStream(res);

      var data = json.decode(response.body);
      print("my data: "+data.toString());
      if (data["Response"] == "SUCCESS") {
        CommonMethods.showColoredToast(successMsg, Colors.green);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AdminProductList()));
      } else {
        CommonMethods.showColoredToast(errorMsg, Colors.red);
      }
    } catch (e) {
      print("errr: "+e.toString());
    }
    loadProgress(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(pageTitle, style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 2.0,
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('Select Category'),
                          SizedBox(
                            width: 20.0,
                          ),
                          new DropdownButton<String>(
                            items: categoryListItems.map((item) {
                              return new DropdownMenuItem(
                                child: Text(item.categoryName),
                                value: item.categoryId,
                              );
                            }).toList(),
                            onChanged: (String newVal) {
                              setState(() {
                                categoryId = newVal;
                              });
                            },
                            value: categoryId,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextField(
                        controller: _controllerProductName,
                        onChanged: (text) {
                          productName = text;
                        },
                        autofocus: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                            labelText: 'Product Name',
//                          errorText: 'Enter Product Name',
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextField(
                        controller: _controllerDescription,
                        onChanged: (text) {
                          description = text;
                        },
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                            labelText: 'Description',
//                          errorText: 'Enter Mobile No',
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextField(
                        controller: _controllerAmount,
                        onChanged: (text) {
                          amount = text;
                        },
                        keyboardType: TextInputType.number,
                        autofocus: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                            labelText: 'Amount',
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextField(
                        controller: _controllerFinalPrice,
                        onChanged: (text) {
                          finalPrice = text;
                        },
                        keyboardType: TextInputType.number,
                        autofocus: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                            labelText: 'Offer Amount',
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(height: 10.0,),
                      Row(
                        children: <Widget>[
                          Text(
                              "Type:"
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          DropdownButton(
                            items: _dropDownItem(),
                            onChanged: (newVal) {
                              uniteType = newVal;
                              weightVisiblity = true;
                              setState(() {

                              });
                            },
                            value: uniteType,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Visibility(
                        visible: isLoading,
                        child: TextField(
                          controller: _controllerWeight,
                          onChanged: (text) {
                            weight = text;
                          },
                          keyboardType: TextInputType.text,
                          autofocus: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                              labelText: 'Weight',
                              border: OutlineInputBorder()),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                              height: 70,
                              width:70,
                              child:
                              Container(
                                height: 200,
                                child: productImg == null
                                    ? Image.network(productImgPath, height: 70, width: 70,)
                                    : Image.file(productImg),)
//                              productImgPath != null
//                                  ? Image.network(productImgPath,
//                                height: 70,
//                                width:70,
//                              )
//                                  : Container(),
                             ),

                          SizedBox(width: 20,),
                          RaisedButton(
                            onPressed: () {
                              imgFor = 1;
                              showImagePickerDialog();
                            },
                            child: Text(
                              imgBtnText,
                            ),

                          ),
                        ],
                      ),

                      RaisedButton(
                        onPressed: addingProductDetails,
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
            ),
            Visibility(
              visible: isLoading,
              child: MyLoader(),
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItem() {
    List<String> ddl = Constant.unitTypeArray;
    return ddl
        .map((value) => DropdownMenuItem(
      value: value,
      child: Text(value,style: TextStyle(fontSize: 14),),
    ))
        .toList();
  }

}
