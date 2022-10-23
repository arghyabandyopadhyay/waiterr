class QRJSONModel {
  String restaurantId;
  String table;
  String outletName;
  String outletSalespointType;
  QRJSONModel(this.restaurantId, this.table, this.outletName,
      this.outletSalespointType);

  factory QRJSONModel.fromJson(dynamic json) {
    return QRJSONModel(json['RestaurantId'] as String, json['Table'] as String,
        json['Outlet'] as String, json['SalespointType'] as String);
  }
}
