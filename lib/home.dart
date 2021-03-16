import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'cart.dart';
import 'common/constant.dart';
import 'common/navigation_drawer.dart';
import 'model/list_model.dart';
import 'model/product_list_model.dart';

class HomePage extends StatefulWidget {
  HomePage({ Key key }) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  SharedPreferences pref;
  var drawerItem;
  List<ProductListModel> _productList = List<ProductListModel>();
  List<ProductListModel> _searchList = List<ProductListModel>();
  List<ProductListModel> _cartList = List<ProductListModel>();
  bool isLoading = false;

  List<String> categories = [""];
  List<String> categoriesId = [""];
  List<CategoryListItems> categoryListItems = [];

//  List<CategoryListItems> categories = [];
  TabController tabController;
  TextStyle tabStyle = TextStyle(fontSize: 16);
  var selectedTab = 0;
  var categoryId = "";
  var fcmToken ="";
  var text;

  Icon actionIcon = new Icon(Icons.search, color: Colors.white,);
  Widget appBarTitle = new Text("Vegetables", style: new TextStyle(color: Colors.white),);
  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQueryController = new TextEditingController();
  bool _IsSearching = false;
  String _searchText = "";


  @override
  void initState() {
    super.initState();
    categories.clear();
    categoriesId.clear();

    categories.add("Vegetables");
    categoriesId.add("1");

    categories.add("Exotic Vegetables");
    categoriesId.add("2");

    categories.add("Fruits");
    categoriesId.add("3");
    getSharedPrefData();
  }

  getSharedPrefData() async {
    pref = await SharedPreferences.getInstance();


    var name = pref.getString("key");
    // CommonMethods.showColoredToast(name, Colors.red);

    // categories = pref.getStringList("nameArray");
    // categoriesId = pref.getStringList("idArray");

    if (pref.getString("_cartList") != null) {
      json.decode(pref.getString("_cartList")).forEach((v) {
        _cartList.add(new ProductListModel.fromJson(v));
      });
    }

    categoryId = categoriesId[0];
    _getProductList(categoryId);

    tabController = TabController(length: categories.length, vsync: this, initialIndex: 0);
    tabController.addListener(_handleTabSelection);

    setState(() {});
  }

  void _handleTabSelection() {
    setState(() {
      selectedTab = tabController.index;
      categoryId = categoriesId[selectedTab];
      _getProductList(categoryId);
      print("Changed tab to: ${selectedTab.toString().split('.').last} , index: ${tabController.index}");
    });
  }

  loadProgress(bool loadingStatus) {
    // print("statusss " + isLoading.toString());
    setState(() {
      isLoading = loadingStatus;
    });
  }

  void _handleSearchStart() {
    setState(() {
      _IsSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(Icons.search, color: Colors.white,);
      this.appBarTitle =
      new Text("Vegetables", style: new TextStyle(color: Colors.white),);
      _IsSearching = false;
      _searchQueryController.clear();
      onSearchTextChanged('');
    });
  }



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      key: key,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          drawer: MyDrawer(),
          appBar: buildAppBar(context),
          body:
          TabBarView(
            controller: tabController,
            children: List<Widget>.generate(
              categories.length,
                  (int index) {
//                    if (index == 0) {
                return Container(child: _searchList.length != 0 || _searchQueryController.text.isNotEmpty
                    ? _buildSearchGridView()
                    : _buildGridView()
//                Text(categories[index]),
//                FutureBuilder(
//                  future: _getProductList(categoriesId[index]),
//                  builder: (BuildContext context, AsyncSnapshot snapshot) {
//                    return _buildGridView();
//                  },
//                ),
                );
//                    } else {
//                return Text(categories[index]);
//                }
              },
            ),
          ),



      ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchList.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _productList.forEach((listItem) {
      if (listItem.productName.contains(text) || listItem.productName.toLowerCase().contains(text))
        _searchList.add(listItem);
    });

    setState(() {});
  }


  Widget buildAppBar(BuildContext context) {
    return new  AppBar(
        title: appBarTitle,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8.0),
            child: Row(
              children: <Widget>[
                new IconButton(icon: actionIcon, onPressed: () {
                  setState(() {
                    if (this.actionIcon.icon == Icons.search) {
                      this.actionIcon = new Icon(Icons.close, color: Colors.white,);
                      this.appBarTitle = new TextField(
                        onChanged: onSearchTextChanged,
                        controller: _searchQueryController,
                        style: new TextStyle(
                          color: Colors.white,
                        ),
                        decoration: new InputDecoration(
                            prefixIcon: new Icon(Icons.search, color: Colors.white),
                            hintText: "Search...",
                            hintStyle: new TextStyle(color: Colors.white)
                        ),
                      );
                      _handleSearchStart();
                    }
                    else {
                      _handleSearchEnd();
                    }
                  });
                },),
                SizedBox(
                  width: 15.0,
                ),
                GestureDetector(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                      if (_cartList.length > 0)
                        Padding(
                          padding: const EdgeInsets.only(left: 2.0),
                          child: CircleAvatar(
                            radius: 8.0,
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            child: Text(
                              _cartList.length.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  onTap: () {
                    if (_cartList.isNotEmpty)
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Cart(_cartList),
                        ),
                      );
                  },
                ),
              ],
            ),
          )
        ],
      bottom: new TabBar(
        isScrollable: true,
        indicatorColor: Colors.blue,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black54,
        controller: tabController,
        tabs: List<Widget>.generate(categories.length, (int index) {
          return new Tab(
              child: Text(categories[index],
                  style: TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 15.0)));
        }),
      ),
    );


  }


  GridView _buildGridView() {
    return GridView.builder(
        padding: const EdgeInsets.all(4.0),
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: _productList.length,
        itemBuilder: (context, index) {
          // return index == 0 ? _searchBar() : _listItem(index-1);
          return _listItem(_productList,index);
        });
  }

  GridView _buildSearchGridView() {
    return GridView.builder(
        padding: const EdgeInsets.all(4.0),
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: _searchList.length,
        itemBuilder: (context, index) {
          // return index == 0 ? _searchBar() : _listItem(index-1);
          return _listItem(_searchList,index);
        });
  }

  _listItem(listItems, int index) {
    var item = listItems[index];
    var isInTheCart = _cartList.where((row) => (row.productId.contains(item.productId)));

    String unite = item.uniteType;
    // String unite = "";
    // if (uniteType == "0") {
    //   unite = "grams";
    // } else {
    //   unite = "piece";
    // }

    return Card(
        elevation: 4.0,
        child: Stack(
          fit: StackFit.loose,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Image.network(
                    // Constant.imgUrl + item.img,
                    item.img,
                    height: 520,
                    width: 520,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, top: 5),
                  child:
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AutoSizeText(
                      item.productName,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      minFontSize: 12,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 10,
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        item.weight + unite,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.subhead,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, top: 5, bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Offer Rs." + item.finalPrice,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Rs." + item.amount,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                right: 8.0,
                bottom: 8.0,
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  child: (isInTheCart.length >= 1)
                      ? Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                  )
                      : Icon(
                    Icons.add_circle,
                    color: Colors.green,
                  ),
                  onTap: () {
                    setState(() {
                      if (!_cartList.contains(item))
                        _cartList.add(item);
                      else
                        _cartList.remove(item);
                      pref.setString("_cartList", json.encode(_cartList));

                    });
                  },
                ),
              ),
            ),
          ],
        ));
  }

  Future<List<ProductListModel>> _getProductList(String categoriesId) async {
//    var res = await get(Constant.url + "?method=GetProductList&clientBusinessId=" +
    var res = await get(Constant.url +
        "?method=GetCategoryWiseProductList&clientBusinessId=" +
        Constant.clientBusinessId +
        "&categoryId=" +
        categoriesId);
    var jsonObjRes = json.decode(res.body);
    List<ProductListModel> list = [];

    isLoading = false;
    loadProgress(isLoading);
    if (jsonObjRes["Response"] == "LIST_NOT_AVAILABLE") {
      // CommonMethods.showColoredToast("Data Not Available.", Colors.red);
    } else {
      // CommonMethods.showColoredToast("Data Available."+categoriesId , Colors.purple);
      for (var u in jsonObjRes["Response"]) {
        ProductListModel pm = ProductListModel.fromJson(u);
        list.add(pm);
      }
    }
    setState(() {
      _productList = list;
      // CommonMethods.showColoredToast("Data."+_productList[0].productName, Colors.purple);
    });
    return list;
  }

}
