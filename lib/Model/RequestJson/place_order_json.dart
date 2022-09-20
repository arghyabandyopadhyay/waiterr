import '../place_order_menu_list.dart';

class PlaceOrderJson {
  String? salePointType;
  String? salePointName;
  String? waiterName;
  String? customerName;
  String? mobileNumber;
  int? pAX;
  String? outletName;
  String? narration;
  String? createdBy;
  String? createdOn;
  List<PlaceOrderMenuList>? menuList;
  String? userRole;

  PlaceOrderJson(
      {this.salePointType,
      this.salePointName,
      this.waiterName,
      this.customerName,
      this.mobileNumber,
      this.pAX,
      this.outletName,
      this.narration,
      this.createdBy,
      this.createdOn,
      this.menuList,
      this.userRole});

  Map toJson() {
    List<Map>? menuList = this.menuList != null
        ? this.menuList!.map((i) => i.toJson()).toList()
        : null;
    return {
      'SalePointType': salePointType,
      'SalePointName': salePointName,
      'WaiterName': waiterName,
      'CustomerName': customerName,
      'MobileNumber': mobileNumber,
      'PAX': pAX,
      'OutletName': outletName,
      'Narration': narration,
      'CreatedBy': createdBy,
      'CreatedOn': createdOn,
      'menuList': menuList,
      'AYSUserRole': userRole,
    };
  }
}
