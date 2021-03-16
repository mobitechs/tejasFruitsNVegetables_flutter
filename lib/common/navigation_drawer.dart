import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tejas_vegetables/admin/admin_product_list.dart';
import 'package:tejas_vegetables/admin/category_list.dart';
import 'package:tejas_vegetables/auth/login_screen.dart';
import 'package:tejas_vegetables/callback/alert_btn_callback.dart';

import '../address_list.dart';
import '../home.dart';
import '../admin/admin_order_list.dart';
import '../my_profile_screen.dart';
import '../my_order_list.dart';
import 'constant.dart';
import 'drawer_menu_list_items.dart';

class MyDrawer extends StatefulWidget {
//  var drawerItem;
//  MyDrawer(List<DrawerMenuItems> drawerItem);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> implements AlertBtnCallback {
//  var drawerItem;
//  _MyDrawerState(this.drawerItem);

  SharedPreferences pref;
  String userName = "";
  String email = "";
  String mobileNo = "";
  String userType = "";
  bool isImageUrlNull = true;
  String userNameChar = "";
  String dialogFor = "";
  var drawerItem = drawerMenuItems;
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    getSharedPrefData();
  }

  getSharedPrefData() async {
    pref = await SharedPreferences.getInstance();
    userName = pref.getString("userName");
    email = pref.getString("emailId");
    mobileNo = pref.getString("mobileNo");
//    imageUrl = pref.getString("userImg");
    userType = pref.getString("userType");

    userNameChar = userName[0];

    isLogin = CommonMethods.checkLogin(pref);
    print("unn: " + userName);

    if (userType == "Admin") {
      drawerItem = adminDrawerMenuItems;
    } else {
      drawerItem = drawerMenuItems;
    }

    setState(() {});
  }

  navigateToPage(String menuName) {
    var page;
    if (isLogin == true || menuName == "Home") {
      if (menuName == "Home") {
        page = HomePage();
      } else if (menuName == "Profile") {
        page = MyProfilePage();
      } else if (menuName == "My Order") {
        if (userType == "Admin") {
          page = AdminOrderList();
        } else {
          page = MyOrderList();
        }
      } else if (menuName == "My Address") {
        page = AddressListPage();
      } else if (menuName == "My Product") {
        page = AdminProductList();
      } else if (menuName == "Category") {
        page = CategoryList();
      } else {
        page = HomePage();
      }

      if (menuName == "Logout") {
        dialogFor = "Logout";
        CommonMethods.showAlert("Confirmation", "Are you sure? Do you want to logout?", "Yes", "No", context, this);
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => page));
      }
    } else {
      dialogFor = "Login";
      CommonMethods.showAlert("Confirmation", "You have not logged in yet. Do want to login?", "Yes", "No", context, this);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(userName != null ? userName : ""),
            accountEmail: Text(email != null ? email : ""),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                userNameChar,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
//              onDetailsPressed: (){},
          ),
          Expanded(
            child: Container(
              height: double.maxFinite,
              child: ListView.builder(
                itemCount: drawerItem.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: ListTile(
                      leading: drawerItem[index].menuIcon,
                      title: Text(drawerItem[index].menuName),
                      onTap: () {
                        navigateToPage(drawerItem[index].menuName);
                      },
//                  selected: false,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void positiveBtnClicked() {
    if (dialogFor == "Logout") {
      pref.setBool(Constant.isLogin, false);
      pref.clear();
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));

    // Navigator.pushNamedAndRemoveUntil(context, "/LoginPage", (r) => false);
  }


}
