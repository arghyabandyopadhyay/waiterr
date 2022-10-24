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
  final bool orderPlaced;
  final bool orderApproved;
  final bool orderPrepared;
  final bool orderProcessed;
  final String? runningOrderId;
  final String? outletName;
  final String? orderId;

  KOTModel(
      {this.salePointType,
      this.salePointName,
      this.kotNumber,
      this.item,
      this.quantity,
      this.rate,
      this.discountable,
      this.discountPercent,
      this.taxRate,
      this.runningOrderId,
      this.outletName,
      this.orderId,
      required this.orderPlaced,
      required this.orderApproved,
      required this.orderPrepared,
      required this.orderProcessed});

  factory KOTModel.fromJson(Map<String, dynamic> json) {
    return KOTModel(
      salePointType: json['SalePointType'],
      salePointName: json['SalePointName'],
      kotNumber: json['KotNumber'],
      runningOrderId: json['RunningOrderId'],
      outletName: json['OutletName'],
      orderId: json['OrderId'],
      item: json['Item'],
      quantity: double.parse(json['Quantity'].toString()),
      rate: double.parse(json['Rate'].toString()),
      discountable: json['Discountable'] == 1,
      discountPercent: double.parse(json['DiscountPercent'].toString()),
      taxRate: double.parse(json['TaxRate'].toString()),
      orderPlaced: json['OrderPlaced'] == 1,
      orderApproved: json['OrderApproved'] == 1,
      orderPrepared: json['OrderPrepared'] == 1,
      orderProcessed: json['OrderProcessed'] == 1,
    );
  }
}
