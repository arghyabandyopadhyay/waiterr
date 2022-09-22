class UserLoginModel {
  final int? id;
  String? name;
  String? mobileNumber;
  String? password;
  String? uid;
  String? lastLogin;
  String tokenType;
  String token;

  UserLoginModel(
      {this.id,
      this.name,
      this.mobileNumber,
      this.password,
      this.uid,
      required this.tokenType,
      required this.token,
      this.lastLogin});

  factory UserLoginModel.fromJson(Map<String, dynamic> json) {
    return UserLoginModel(
        id: json['id'],
        name: json['Name'],
        mobileNumber: json['MobileNumber'],
        password: json['Password'],
        lastLogin: json['last_login'],
        tokenType: json['tokenType'],
        token: json['token'],
        uid: json['UID']);
  }

  Map toJson() => {
        "id": id,
        "Name": name,
        "MobileNumber": mobileNumber,
        "Password": password,
        "UID": uid,
        "last_login": lastLogin,
        "tokenType": tokenType,
        "token": token
      };

  Map toJsonForLogin() =>
      {"Name": name, "MobileNumber": mobileNumber, "Password": password};
  Map toJsonForRegistration() => {"Name": name, "MobileNumber": mobileNumber};
}
