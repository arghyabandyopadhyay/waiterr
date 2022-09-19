import 'package:waiterr/Model/customizable_page_model.dart';

class MenuItemModel {
  String? itemImage;
  String item;
  String? itemDescription;
  String? commentForKOT;
  String? stockGroup;
  double? quantity;
  double? rateBeforeDiscount;
  double? discount;
  double? rate;
  double? saudaRate;
  String? taxClassID;
  double? taxRate;
  bool? isDiscountable;
  String? masterFilter;
  List<CustomizablePageModel>? customizable;
  bool? isVeg;
  String itemID;
  String? tags;
  bool? favourite;

  MenuItemModel(
      {this.itemImage,
      required this.item,
      this.itemDescription,
      this.commentForKOT,
      this.stockGroup,
      this.quantity,
      this.rateBeforeDiscount,
      this.discount,
      this.rate,
      this.saudaRate,
      this.taxClassID,
      this.taxRate,
      this.isDiscountable,
      this.masterFilter,
      this.customizable,
      required this.itemID,
      this.isVeg,
      this.tags,
      this.favourite});

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
        itemImage: json['ItemImage'],
        item: json['Item'],
        itemDescription: json['ItemDescription'],
        commentForKOT: json['CommentForKOT'],
        stockGroup: json['StockGroup'],
        quantity: json['Quantity'],
        rateBeforeDiscount: json['RateBeforeDiscount'],
        discount: json['Discount'],
        rate: json['Rate'],
        saudaRate: json['SaudaRate'],
        taxClassID: json['TaxClassID'],
        taxRate: json['TaxRate'],
        isDiscountable: json['IsDiscountable'],
        masterFilter: json['MasterFilter'],
        customizable: (json['Customizable'] == "")
            ? []
            : (json['Customizable'] as List)
                .map((data) => CustomizablePageModel.fromJson(data))
                .toList(),
        isVeg: json['IsVeg'],
        itemID: json['ItemID'],
        tags: json['Tags'],
        favourite: json['Favourite']);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'ItemImage': itemImage,
      'Item': item,
      'ItemDescription': itemDescription,
      'CommentForKOT': commentForKOT,
      'StockGroup': stockGroup,
      'Quantity': quantity,
      'RateBeforeDiscount': rateBeforeDiscount,
      'Discount': discount,
      'Rate': rate,
      'SaudaRate': saudaRate,
      'TaxClassID': taxClassID,
      'TaxRate': taxRate,
      'IsDiscountable': isDiscountable,
      'MasterFilter': masterFilter,
      'Customizable': (customizable == null)
          ? []
          : (customizable as List)
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
