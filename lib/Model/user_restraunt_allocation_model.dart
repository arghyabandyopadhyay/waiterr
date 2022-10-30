import 'dart:convert';

class UserRestrauntAllocationModel {
  final String? clientName;
  final String? logoURL;
  final String? dataExchangeVia;
  final String? dataExchangeURL;
  final String? clientType;
  final String? guid;
  final String? companyGUID;
  final int ucaRoleId;
  final List<OutletConfigurationModel>? outletConfiguration;

  UserRestrauntAllocationModel(
      {this.clientName,
      this.logoURL,
      this.dataExchangeVia,
      this.dataExchangeURL,
      this.clientType,
      this.guid,
      this.companyGUID,
      required this.ucaRoleId,
      this.outletConfiguration});
  factory UserRestrauntAllocationModel.fromJson(Map<String, dynamic> json) {
    return UserRestrauntAllocationModel(
      clientName: json['ClientName'],
      logoURL: json['LogoUrl'],
      dataExchangeVia: json['DataExchangeVia'],
      dataExchangeURL: json['DataExchangeUrl'],
      clientType: json['ClientType'],
      guid: json['GUID'],
      ucaRoleId: json['UCARoleId'],
      companyGUID: json['CompanyGUID'],
      outletConfiguration: (json['outletConfiguration'] as List)
          .map((data) => OutletConfigurationModel.fromJson(data))
          .toList(),
    );
  }

  Map toJson() {
    List<Map>? outletConfiguration = this.outletConfiguration != null
        ? this.outletConfiguration!.map((i) => i.toJson()).toList()
        : null;
    return {
      'clientName': clientName,
      'logoURL': logoURL,
      'dataExchangeVia': dataExchangeVia,
      'dataExchangeURL': dataExchangeURL,
      'clientType': clientType,
      'guid': guid,
      'UCARoleId': ucaRoleId,
      'companyGUID': companyGUID,
      'outletConfiguration': outletConfiguration,
    };
  }
}

class OutletConfigurationModel {
  String id;
  String outletName;
  String? outletSalePoint;
  OutletConfigurationModel(this.id, this.outletName, this.outletSalePoint);
  factory OutletConfigurationModel.fromJson(Map<String, dynamic> json) {
    return OutletConfigurationModel(json['id'] as String,
        json['OutletName'] as String, json['OutletSalePoint'] as String?);
  }
  Map toJson() => {
        "id": id,
        "OutletName": outletName,
        "OutletSalePoint": outletSalePoint,
      };
}
