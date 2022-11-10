class OutletConfigurationModel {
  String id;
  String outletName;
  String? outletSalePoint;
  OutletConfigurationModel(this.id, this.outletName, this.outletSalePoint);
  factory OutletConfigurationModel.fromJson(Map<String, dynamic> json) {
    return OutletConfigurationModel(json['id'] as String,
        json['OutletName'] as String, json['OutletSalePoint'] as String?);
  }
  Map toJson() => {
        "id": id,
        "OutletName": outletName,
        "OutletSalePoint": outletSalePoint,
      };
}
