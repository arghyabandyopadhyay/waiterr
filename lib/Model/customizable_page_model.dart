class CustomizablePageModel {
  String? name;
  String? qty;
  String? price;
  CustomizablePageModel(this.name,this.qty, this.price);

  factory CustomizablePageModel.fromJson(dynamic json) {
    return CustomizablePageModel(json['Name'] as String?,json['Qty'] as String?, json['Price'] as String?);
  }

  // CustomizablePageModel.fromMap(Map<String, dynamic> map) {
  //   name: map['Name'];
  //   qty: map['Qty'];
  //   price:map['Price'];
  // }

}