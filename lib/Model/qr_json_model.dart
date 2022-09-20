class QRJSONModel {
  String loginId;
  String userPassword;
  String restaurantId;
  String table;
  String outlet;
  String salespointType;
  QRJSONModel(this.loginId, this.userPassword, this.restaurantId, this.table,
      this.outlet, this.salespointType);

  factory QRJSONModel.fromJson(dynamic json) {
    return QRJSONModel(
        json['LoginId'] as String,
        json['UserPassword'] as String,
        json['RestaurantId'] as String,
        json['Table'] as String,
        json['Outlet'] as String,
        json['SalespointType'] as String);
  }
}
