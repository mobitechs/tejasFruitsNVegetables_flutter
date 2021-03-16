class ProductListModel {
  String _categoryId;
  String _categoryName;
  String _clientBusinessId;
  String _productId;
  String _productName;
  String _description;
  String _amount;
  String _finalPrice;
  String _uniteType;
  String _weight;
  String _img;
  String _isDeleted;
  String _createdBy;
  String _createdDate;
  String _editedBy;
  String _editedDate;
  int _qty=1;
  int _qtyPos=0;
  String _qtyWisePrice;

  ProductListModel(
      {String categoryId,
        String categoryName,
        String clientBusinessId,
        String productId,
        String productName,
        String description,
        String amount,
        String finalPrice,
        String uniteType,
        String weight,
        String img,
        String isDeleted,
        String createdBy,
        String createdDate,
        String editedBy,
        String editedDate,
        int qty,
        int qtyPos,
        String qtyWisePrice}) {
    this._categoryId = categoryId;
    this._categoryName = categoryName;
    this._clientBusinessId = clientBusinessId;
    this._productId = productId;
    this._productName = productName;
    this._description = description;
    this._amount = amount;
    this._finalPrice = finalPrice;
    this._uniteType = uniteType;
    this._weight = weight;
    this._img = img;
    this._isDeleted = isDeleted;
    this._createdBy = createdBy;
    this._createdDate = createdDate;
    this._editedBy = editedBy;
    this._editedDate = editedDate;
    this._qty = qty;
    this._qtyPos = qtyPos;
    this._qtyWisePrice = qtyWisePrice;
  }

  int get qty => _qty;
  set qty(int qty) => _qty = qty;

int get qtyPos => _qtyPos;
  set qtyPos(int qtyPos) => _qtyPos = qtyPos;

  String get categoryId => _categoryId;
  set categoryId(String categoryId) => _categoryId = categoryId;

  String get qtyWisePrice => _qtyWisePrice;
  set qtyWisePrice(String qtyWisePrice) => _qtyWisePrice = qtyWisePrice;

  String get categoryName => _categoryName;
  set categoryName(String categoryName) => _categoryName = categoryName;
  String get clientBusinessId => _clientBusinessId;
  set clientBusinessId(String clientBusinessId) =>
      _clientBusinessId = clientBusinessId;
  String get productId => _productId;
  set productId(String productId) => _productId = productId;
  String get productName => _productName;
  set productName(String productName) => _productName = productName;
  String get description => _description;
  set description(String description) => _description = description;
  String get amount => _amount;
  set amount(String amount) => _amount = amount;
  String get finalPrice => _finalPrice;
  set finalPrice(String finalPrice) => _finalPrice = finalPrice;
  String get uniteType => _uniteType;
  set uniteType(String uniteType) => _uniteType = uniteType;
  String get weight => _weight;
  set weight(String weight) => _weight = weight;
  String get img => _img;
  set img(String img) => _img = img;
  String get isDeleted => _isDeleted;
  set isDeleted(String isDeleted) => _isDeleted = isDeleted;
  String get createdBy => _createdBy;
  set createdBy(String createdBy) => _createdBy = createdBy;
  String get createdDate => _createdDate;
  set createdDate(String createdDate) => _createdDate = createdDate;
  String get editedBy => _editedBy;
  set editedBy(String editedBy) => _editedBy = editedBy;
  String get editedDate => _editedDate;
  set editedDate(String editedDate) => _editedDate = editedDate;

  ProductListModel.fromJson(Map<String, dynamic> json) {
    _categoryId = json['categoryId'];
    _categoryName = json['categoryName'];
    _clientBusinessId = json['clientBusinessId'];
    _productId = json['productId'];
    _productName = json['productName'];
    _description = json['description'];
    _amount = json['amount'];
    _finalPrice = json['finalPrice'];
    _uniteType = json['uniteType'];
    _weight = json['weight'];
    _img = json['img'];
    _isDeleted = json['isDeleted'];
    _createdBy = json['createdBy'];
    _createdDate = json['createdDate'];
    _editedBy = json['editedBy'];
    _editedDate = json['editedDate'];
    _qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this._categoryId;
    data['categoryName'] = this._categoryName;
    data['clientBusinessId'] = this._clientBusinessId;
    data['productId'] = this._productId;
    data['productName'] = this._productName;
    data['description'] = this._description;
    data['amount'] = this._amount;
    data['finalPrice'] = this._finalPrice;
    data['uniteType'] = this._uniteType;
    data['weight'] = this._weight;
    data['img'] = this._img;
    data['isDeleted'] = this._isDeleted;
    data['createdBy'] = this._createdBy;
    data['createdDate'] = this._createdDate;
    data['editedBy'] = this._editedBy;
    data['editedDate'] = this._editedDate;
    data['qty'] = this._qty;
    return data;
  }
}
