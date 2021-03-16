import 'package:flutter/material.dart';

class DrawerMenuItems {
  final int id;
  final String menuName;
  final Icon menuIcon;

  DrawerMenuItems({
    this.id,
    this.menuName,
    this.menuIcon,
  });
}

final DrawerMenuItems Home = DrawerMenuItems(
  id: 1,
  menuName: 'Home',
  menuIcon: Icon(Icons.home),
);

final DrawerMenuItems Profile = DrawerMenuItems(
  id: 2,
  menuName: 'Profile',
  menuIcon: Icon(Icons.person),
);

final DrawerMenuItems Order = DrawerMenuItems(
  id: 3,
  menuName: 'My Order',
  menuIcon: Icon(Icons.people),
);
final DrawerMenuItems Address = DrawerMenuItems(
  id: 4,
  menuName: 'My Address',
  menuIcon: Icon(Icons.markunread_mailbox),
);
final DrawerMenuItems Logout = DrawerMenuItems(
  id: 5,
  menuName: 'Logout',
  menuIcon: Icon(Icons.power_settings_new),
);

final DrawerMenuItems AddProduct = DrawerMenuItems(
  id: 6,
  menuName: 'My Product',
  menuIcon: Icon(Icons.markunread_mailbox),
);

final DrawerMenuItems AddCategory = DrawerMenuItems(
  id: 7,
  menuName: 'Category',
  menuIcon: Icon(Icons.markunread_mailbox),
);

List<DrawerMenuItems> drawerMenuItems = [Home, Profile, Order, Logout];
List<DrawerMenuItems> adminDrawerMenuItems = [Home, Order, AddProduct, AddCategory, Profile, Logout];
