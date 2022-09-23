class RunningOrderModel {
  final String? name;
  final String? mobileNo;
  final String? salePointType;
  final String? salePointName;
  final String? waiterName;
  final String? waiterMobileNumber;
  final double? amount;
  final int? pax;
  final String? activeSince;
  final bool? billPrinted;
  final String? outletName;
  final String? masterFilter;

  RunningOrderModel(
      {this.name,
      this.mobileNo,
      this.salePointType,
      this.salePointName,
      this.waiterName,
      this.waiterMobileNumber,
      this.amount,
      this.pax,
      this.activeSince,
      this.billPrinted,
      this.outletName,
      this.masterFilter});

  factory RunningOrderModel.fromJson(Map<String, dynamic> json) {
    return RunningOrderModel(
      name: json['Name'],
      mobileNo: json['MobileNo'],
      salePointType: json['SalePointType'],
      salePointName: json['SalePointName'],
      waiterName: json['WaiterName'],
      waiterMobileNumber: json['WaiterMobileNo'],
      amount: double.parse('${json['Amount']}'),
      pax: json['PAX'],
      activeSince: json['ActiveSince'],
      billPrinted: json['BillPrinted'] == 1,
      outletName: json['OutletName'],
      masterFilter: json['Name'] +
          json['MobileNo'] +
          json['WaiterName'] +
          json['OutletName'],
    );
  }
}
