import 'package:intl/intl.dart';

class RunningOrderModel {
  final String id;
  final String? name;
  final String? mobileNo;
  final String? salePointType;
  final String? salePointName;
  final String? waiterName;
  final String? waiterMobileNumber;
  final double amount;
  final int? pax;
  final String? activeSince;
  final bool billPrinted;
  final String? outletName;
  String? outletId;
  final String? masterFilter;
  RunningOrderModel(
      {required this.id,
      this.name,
      this.mobileNo,
      this.salePointType,
      this.salePointName,
      this.waiterName,
      this.waiterMobileNumber,
      required this.amount,
      this.pax,
      this.activeSince,
      required this.billPrinted,
      this.outletName,
      this.outletId,
      this.masterFilter});

  factory RunningOrderModel.fromJson(Map<String, dynamic> json) {
    var format = DateFormat('d/M/y, hh:mm');
    return RunningOrderModel(
      id: json['id'],
      name: json['Name'],
      mobileNo: json['MobileNo'],
      salePointType: json['SalePointType'],
      salePointName: json['SalePointName'],
      waiterName: json['WaiterName'],
      waiterMobileNumber: json['WaiterMobileNo'],
      amount: double.parse('${json['Amount']}'),
      pax: json['PAX'],
      activeSince: format.format(DateTime.parse(json['ActiveSince'])),
      billPrinted: json['BillPrinted'] == 1,
      outletName: json['OutletName'],
      outletId: json['OutletId'],
      masterFilter: json['Name'] +
          json['MobileNo'] +
          json['WaiterName'] +
          json['OutletName'],
    );
  }
}
