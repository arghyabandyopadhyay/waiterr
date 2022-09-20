class RunningOrderModel {
  final String? Name;
  final String? MobileNo;
  final String? SalePointType;
  final String? SalePointName;
  final String? WaiterName;
  final String? WaiterMobileNumber;
  final double? Amount;
  final int? PAX;
  final String? ActiveSince;
  final bool? BillPrinted;
  final String? OutletName;
  final String? MasterFilter;

  RunningOrderModel(
      {this.Name,
      this.MobileNo,
      this.SalePointType,
      this.SalePointName,
      this.WaiterName,
      this.WaiterMobileNumber,
      this.Amount,
      this.PAX,
      this.ActiveSince,
      this.BillPrinted,
      this.OutletName,
      this.MasterFilter});

  factory RunningOrderModel.fromJson(Map<String, dynamic> json) {
    return RunningOrderModel(
      Name: json['Name'],
      MobileNo: json['MobileNo'],
      SalePointType: json['SalePointType'],
      SalePointName: json['SalePointName'],
      WaiterName: json['WaiterName'],
      WaiterMobileNumber: json['WaiterMobileNo'],
      Amount: double.parse('${json['Amount']}'),
      PAX: json['PAX'],
      ActiveSince: json['ActiveSince'],
      BillPrinted: json['BillPrinted'] == 1,
      OutletName: json['OutletName'],
      MasterFilter: json['Name'] +
          json['MobileNo'] +
          json['WaiterName'] +
          json['OutletName'],
    );
  }
}
