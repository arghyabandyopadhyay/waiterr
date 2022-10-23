import '../place_order_menu_list.dart';

class PlaceOrderJson {
  String? salePointType;
  String? salePointName;
  String? waiterId;
  String? customerName;
  String? mobileNumber;
  int? pAX;
  String? outletId;
  String? outletName;
  String? narration;
  String? createdOn;
  List<PlaceOrderMenuList>? menuList;
  String? userRole;

  PlaceOrderJson(
      {this.salePointType,
      this.salePointName,
      this.waiterId,
      this.customerName,
      this.mobileNumber,
      this.pAX,
      this.outletId,
      this.outletName,
      this.narration,
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
      'WaiterId': waiterId,
      'CustomerName': customerName,
      'MobileNumber': mobileNumber,
      'PAX': pAX,
      'OutletId': outletId,
      'OutletName': outletName,
      'Narration': narration,
      'CreatedOn': createdOn,
      'menuList': menuList,
      'AYSUserRole': userRole,
    };
  }
}
