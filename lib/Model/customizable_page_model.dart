class CustomizablePageModel {
  String name;
  double qty;
  double price;
  CustomizablePageModel(
      {required this.name, required this.qty, required this.price});

  factory CustomizablePageModel.fromJson(dynamic json) {
    return CustomizablePageModel(
        name: json['Name'] ?? "",
        qty: json['Qty'] ?? 0,
        price: json['Price'] ?? 0);
  }
}
