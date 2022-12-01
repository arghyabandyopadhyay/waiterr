//CustomerDetailsModel
class CustomerDetailsModel {
  final String customerId;
  final String name;
  final String mobileNumber;
  final String dataSource;

  CustomerDetailsModel(
      {required this.customerId,
      required this.name,
      required this.mobileNumber,
      required this.dataSource});

  factory CustomerDetailsModel.fromJson(Map<String, dynamic> json) {
    return CustomerDetailsModel(
        customerId: json['id'],
        name: json['Name'],
        mobileNumber: json['MobileNumber'],
        dataSource: json['DataSource']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": customerId,
      "Name": name,
      "MobileNumber": mobileNumber,
      "DataSource": dataSource
    };
  }
}
