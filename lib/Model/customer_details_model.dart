//CustomerDetailsModel
class CustomerDetailsModel {
  final String? customerID;
  final String? name;
  final String? mobileNumber;

  CustomerDetailsModel({this.customerID, this.name, this.mobileNumber});

  factory CustomerDetailsModel.fromJson(Map<String, dynamic> json) {
    return CustomerDetailsModel(
      customerID: json['customerID'],
      name: json['name'],
      mobileNumber: json['mobileNumber'],
    );
  }
}