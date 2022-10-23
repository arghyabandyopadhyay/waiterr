import 'package:waiterr/Model/customizable_page_model.dart';

class MenuItemModel {
  String? itemImage;
  String item;
  String? itemDescription;
  String? commentForKOT;
  String? commentForKOTId;
  String? stockGroup;
  double quantity;
  double? rateBeforeDiscount;
  double? discount;
  double rate;
  String? taxClassID;
  double? taxRate;
  bool? isDiscountable;
  String? masterFilter;
  List<CustomizablePageModel> customizable;
  bool? isVeg;
  String itemID;
  String? tags;
  bool favourite;

  MenuItemModel(
      {this.itemImage,
      required this.item,
      this.itemDescription,
      this.commentForKOT,
      this.commentForKOTId,
      this.stockGroup,
      required this.quantity,
      this.rateBeforeDiscount,
      this.discount,
      required this.rate,
      this.taxClassID,
      this.taxRate,
      this.isDiscountable,
      this.masterFilter,
      required this.customizable,
      required this.itemID,
      this.isVeg,
      this.tags,
      required this.favourite});

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
        itemImage: json['ItemImage'],
        item: json['Item'],
        itemDescription: json['ItemDescription'],
        commentForKOT: json['CommentForKOT'],
        stockGroup: json['StockGroup'],
        quantity: json['Quantity'] ?? 0,
        rateBeforeDiscount: double.parse(json['RateBeforeDiscount'].toString()),
        discount: double.parse(json['Discount'].toString()),
        rate: double.parse(json['Rate'].toString()),
        taxClassID: json['TaxClassId'],
        taxRate: double.parse(json['TaxRate'].toString()),
        isDiscountable: json['IsDiscountable'] == 1,
        masterFilter: json['MasterFilter'],
        customizable:
            (json['Customizable'] == "" || json['Customizable'] == null)
                ? []
                : (json['Customizable'] as List)
                    .map((data) => CustomizablePageModel.fromJson(data))
                    .toList(),
        isVeg: json['IsVeg'] == 1,
        itemID: json['id'],
        tags: json['Tags'],
        favourite: json['Favourite'] == 1);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'ItemImage': itemImage,
      'Item': item,
      'ItemDescription': itemDescription,
      'CommentForKOT': commentForKOT,
      'CommentForKOTId': commentForKOTId,
      'StockGroup': stockGroup,
      'Quantity': quantity,
      'RateBeforeDiscount': rateBeforeDiscount,
      'Discount': discount,
      'Rate': rate,
      'TaxClassId': taxClassID,
      'TaxRate': taxRate,
      'IsDiscountable': isDiscountable,
      'MasterFilter': masterFilter,
      'Customizable': (customizable == [])
          ? []
          : customizable
              .map((data) => CustomizablePageModel.fromJson(data))
              .toList(),
      'IsVeg': isVeg,
      'ItemID': itemID,
      'Tags': tags,
      'Favourite': favourite
    };
    return map;
  }
}
