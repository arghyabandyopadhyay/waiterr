import 'package:waiterr/Model/customizable_page_model.dart';

class MenuItemModel {
  String? itemImage;
  String item;
  String? itemDescription;
  String? commentForKOT;
  String? commentForKOTId;
  String stockGroup;
  String stockGroupId;
  double quantity;
  double rateBeforeDiscount;
  double discount;
  double rate;
  String taxClassID;
  double taxRate;
  bool isDiscountable;
  String masterFilter;
  List<CustomizablePageModel> customizable;
  bool isVeg;
  String itemID;
  String? tags;
  String? outletId;
  String? outletName;
  bool favourite;
  bool isEdited;

  MenuItemModel(
      {this.itemImage,
      required this.item,
      this.itemDescription,
      this.commentForKOT,
      this.commentForKOTId,
      required this.stockGroup,
      required this.stockGroupId,
      required this.quantity,
      required this.rateBeforeDiscount,
      required this.discount,
      required this.rate,
      required this.taxClassID,
      required this.taxRate,
      required this.isDiscountable,
      required this.masterFilter,
      required this.customizable,
      required this.itemID,
      required this.isVeg,
      this.tags,
      required this.favourite,
      required this.isEdited,
      this.outletId,
      this.outletName});

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
        itemImage: json['ItemImage'],
        item: json['Item'],
        itemDescription: json['ItemDescription'],
        commentForKOT: json['CommentForKOT'],
        stockGroup: json['StockGroup'],
        stockGroupId: json['StockGroupId'],
        quantity: json['Quantity'] ?? 0,
        rateBeforeDiscount: double.parse(json['RateBeforeDiscount'].toString()),
        discount: double.parse(json['Discount'].toString()),
        rate: double.parse(json['Rate'].toString()),
        taxClassID: json['TaxClassId'],
        taxRate: double.parse(json['TaxRate'].toString()),
        isDiscountable: json['IsDiscountable'] == 1,
        masterFilter: json['MasterFilter'] ??
            (json['Item'] +
                (json['ItemDescription'] ?? "") +
                json['StockGroup'] +
                (json['IsVeg'] == 1 ? "veg" : "nonveg") +
                json['OutletName']),
        customizable:
            (json['Customizable'] == "" || json['Customizable'] == null)
                ? []
                : (json['Customizable'] as List)
                    .map((data) => CustomizablePageModel.fromJson(data))
                    .toList(),
        isVeg: json['IsVeg'] == 1,
        itemID: json['id'],
        tags: json['Tags'],
        outletId: json['OutletId'],
        outletName: json['OutletName'],
        favourite: json['Favourite'] == 1,
        isEdited: false);
  }

  Map<String, dynamic> toMap(bool forManagement) {
    var map = <String, dynamic>{
      'ItemImage': itemImage,
      'Item': item,
      'ItemDescription': itemDescription,
      'CommentForKOT': commentForKOT,
      'CommentForKOTId': commentForKOTId,
      'StockGroup': stockGroup,
      'StockGroupId': stockGroupId,
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
      'OutletId': outletId,
      'ItemID': itemID,
      'Tags': tags,
      'Favourite': favourite,
      if (forManagement) 'IsEdited': isEdited
    };
    return map;
  }
}
