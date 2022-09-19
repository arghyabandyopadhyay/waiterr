class KOTModel {
  final String? salePointType;
  final String? salePointName;
  final String? kotNumber;
  final String? item;
  final double? quantity;
  final double? rate;
  final bool? discountable;
  final double? discountPercent;
  final double? taxRate;
  final bool? orderPlaced;
  final bool? orderApproved;
  final bool? orderPrepared;
  final bool? orderProcessed;

  KOTModel({this.salePointType, this.salePointName, this.kotNumber, this.item,this.quantity, this.rate,this.discountable, this.discountPercent,this.taxRate, this.orderPlaced, this.orderApproved, this.orderPrepared, this.orderProcessed});

  factory KOTModel.fromJson(Map<String, dynamic> json) {
    return KOTModel(
        salePointType: json['SalePointType'],
        salePointName: json['SalePointName'],
        kotNumber:json['KotNumber'],
        item:json['Item'],
        quantity:json['Quantity'],
        rate:json['Rate'],
        discountable:json['Discountable'],
        discountPercent:json['DiscountPercent'],
        taxRate:json['TaxRate'],
        orderPlaced:json['OrderPlaced'],
        orderApproved:json['OrderApproved'],
        orderPrepared:json['OrderPrepared'],
        orderProcessed:json['OrderProcessed'],
    );
  }
}