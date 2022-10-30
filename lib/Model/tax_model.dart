class TaxModel {
  String id;
  String taxClass;
  double taxRate;
  String masterFilter;
  TaxModel(
      {required this.id,
      required this.taxClass,
      required this.taxRate,
      required this.masterFilter});
  factory TaxModel.fromJson(Map<String, dynamic> json) {
    return TaxModel(
        id: json['id'],
        taxClass: json['TaxClass'],
        taxRate: double.parse(json['TaxRate'].toString()),
        masterFilter: json['MasterFilter']);
  }
}
