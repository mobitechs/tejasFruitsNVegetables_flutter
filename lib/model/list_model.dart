
class UserDetails {
  final String userId;
  final String userType;
  final String userName;
  final String mobileNo;
  final String emailId;

  UserDetails(this.userId, this.userType, this.userName, this.mobileNo, this.emailId);
}
class CategoryListItems {
  final String categoryId;
  final String categoryName;

  CategoryListItems(this.categoryId, this.categoryName);
}

// class AddressListItems {
//   final String addressId;
//   final String userId;
//   final String address;
//   final String landMark;
//   final String area;
//   final String city;
//   final String pincode;
//
//   AddressListItems(this.addressId, this.userId, this.address, this.landMark,this.area,this.city,this.pincode);
// }

class AddressListItems {
  final String id;
  final String name;
  final String shopName;
  final String mobile;
  final String email;
  final String address;
  final String pincode;
  // final String shopImage;
  // final String latitude;
  // final String longitude;

  AddressListItems(this.id, this.shopName, this.name, this.mobile, this.email,this.address,this.pincode);
}

class Product {
  final String productId;
  final String categoryId;
  final String categoryName;
  final String productName;
  final String description;
  String amount;
  String finalPrice;
  String uniteType;
  String weight;
  String imgUrl;
  int qty;


  Product(this.productId,this.categoryId, this.categoryName,this.productName, this.description, this.amount,this.finalPrice, this.uniteType,this.weight, this.imgUrl,this.qty);
}

class OrderListItems {
  final String orderId;
  final String orderDetails;
  final String Amount;
  final String status;
  final String paymentDetails;
  final String createdDate;
  final String address;
  final String landMark;
  final String area;
  final String city;
  final String pincode;
  final String userName;
  final String mobileNo;
  final String emailId;

  OrderListItems(
      this.orderId, this.orderDetails, this.Amount, this.status,this.paymentDetails,this.createdDate,this.address,
      this.landMark, this.area, this.city, this.pincode,this.userName ,this.mobileNo,this.emailId
      );
}


