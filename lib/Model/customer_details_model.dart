//CustomerDetailsModel
class CustomerDetailsModel {
  final String? customerId;
  final String? name;
  final String? mobileNumber;

  CustomerDetailsModel({this.customerId, this.name, this.mobileNumber});

  factory CustomerDetailsModel.fromJson(Map<String, dynamic> json) {
    return CustomerDetailsModel(
      customerId: json['id'],
      name: json['Name'],
      mobileNumber: json['MobileNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Name": name,
      "MobileNumber": mobileNumber,
    };
  }
}
