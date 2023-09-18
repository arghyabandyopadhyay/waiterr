class UserDetailsModel {
  final String id;
  final String? name;
  final String mobileNumber;
  final int roleID;
  final bool isActive;
  String? profileUrl;
  String? deviceToken;
  String? lastLogin;

  UserDetailsModel(
      {required this.id,
      this.name,
      required this.mobileNumber,
      required this.roleID,
      required this.isActive,
      this.profileUrl,
      this.deviceToken,
      this.lastLogin});

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) {
    return UserDetailsModel(
        id: json['id'],
        name: json['Name'],
        mobileNumber: json['MobileNumber'],
        roleID: json['RoleId'],
        isActive: json['IsActive'] == 1,
        profileUrl: json['ProfileUrl'],
        deviceToken: json['DeviceToken'],
        lastLogin: json['last_login']);
  }

  Map toJson() => {
        "id": id,
        "Name": name,
        "MobileNumber": mobileNumber,
        "RoleId": roleID,
        "IsActive": (isActive) ? 1 : 0,
        "ProfileUrl": profileUrl,
        "DeviceToken": deviceToken,
        "last_login": lastLogin
      };
}
