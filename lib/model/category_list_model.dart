class CategoryListModel {
  String _categoryId;
  String _categoryName;
  String _clientBusinessId;

  CategoryListModel(
      {String categoryId, String categoryName, String clientBusinessId}) {
    this._categoryId = categoryId;
    this._categoryName = categoryName;
    this._clientBusinessId = clientBusinessId;
  }

  String get categoryId => _categoryId;
  set categoryId(String categoryId) => _categoryId = categoryId;
  String get categoryName => _categoryName;
  set categoryName(String categoryName) => _categoryName = categoryName;
  String get clientBusinessId => _clientBusinessId;
  set clientBusinessId(String clientBusinessId) =>
      _clientBusinessId = clientBusinessId;

  CategoryListModel.fromJson(Map<String, dynamic> json) {
    _categoryId = json['categoryId'];
    _categoryName = json['categoryName'];
    _clientBusinessId = json['clientBusinessId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this._categoryId;
    data['categoryName'] = this._categoryName;
    data['clientBusinessId'] = this._clientBusinessId;
    return data;
  }
}
