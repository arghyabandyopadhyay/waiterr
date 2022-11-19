class WaiterDetailsModel {
  final String id;
  final String name;
  final String mobileNumber;
  final int roleId;
  final bool isActive;
  final String outletId;
  final String lastLogin;
  final String outletName;
  final String userClientAllocationId;
  final int ucaRoleId;
  final String masterFilter;

  WaiterDetailsModel(
      {required this.id,
      required this.name,
      required this.mobileNumber,
      required this.roleId,
      required this.isActive,
      required this.outletId,
      required this.lastLogin,
      required this.outletName,
      required this.ucaRoleId,
      required this.userClientAllocationId,
      required this.masterFilter});
  factory WaiterDetailsModel.fromJson(Map<String, dynamic> json) {
    return WaiterDetailsModel(
        id: json['id'],
        name: json['Name'],
        mobileNumber: json['MobileNumber'],
        roleId: json['RoleId'],
        isActive: json['IsActive'] == 1,
        lastLogin: json['last_login'],
        outletId: json['OutletId'],
        outletName: json['OutletName'],
        userClientAllocationId: json['UserClientAllocationId'],
        ucaRoleId: json['UCARoleId'],
        masterFilter: json['MasterFilter']);
  }

  Map toJson() {
    return {
      "id": id,
      "Name": name,
      "MobileNumber": mobileNumber,
      "RoleId": roleId,
      "IsActive": isActive ? 1 : 0,
      "last_login": lastLogin,
      "OutletId": outletId,
      "UserClientAllocationId": userClientAllocationId,
      "UCARoleId": ucaRoleId,
      "OutletName": outletName
    };
  }
}
