import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:waiterr/Model/user_details_model.dart';
import 'Model/outlet_configuration_model.dart';
import 'Model/user_restraunt_allocation_model.dart';
import 'Model/filter_item_model.dart';
import 'Model/menu_item_model.dart';
import 'Model/api_header_model.dart';
import 'Model/user_login_model.dart';

class UserDetail {
  static UserLoginModel loginDetail = UserLoginModel(token: '', tokenType: '');
  static UserDetailsModel userDetails =
      UserDetailsModel(id: '', isActive: false, mobileNumber: '', roleID: 1);
  static String? theme;
  static MenuItemModel? item;
  static String? currentUrl;
  //static RegExp commaRegex = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  static RegExp commaRegex = RegExp(r'(\d{1,2})(?=((\d{2})+\d{1})(?!\d))');
  static Function matchFunc = (Match match) => '${match[1]},';

  static Map<String, String> getHeader() {
    ApiHeaderModel headerModel = ApiHeaderModel(
        authorization:
            "${UserDetail.loginDetail.tokenType} ${UserDetail.loginDetail.token}",
        contentType: 'application/json; charset=UTF-8');
    return headerModel.toJson();
  }
}

class UserClientAllocationData {
  static String? clientName;
  static String? logoURL;
  static String? dataExchangeVia;
  static String? dataExchangeURL;
  static String? clientType;
  static String? guid;
  static int ucaRoleId = 1;
  static String? companyGUID;
  static List<OutletConfigurationModel>? outletConfiguration;
  static List<MenuItemModel>? productList;
  static List<FilterItemModel>? distinctStockGroup;
  static List<List<MenuItemModel>>? productListStockDiff;
  static String? lastOutletId;
  static void setValues(
      UserRestrauntAllocationModel userClientAllocationModel) {
    if (userClientAllocationModel.guid != guid) {
      clearMenuData();
    }
    ucaRoleId = userClientAllocationModel.ucaRoleId;
    clientName = userClientAllocationModel.clientName;
    logoURL = userClientAllocationModel.logoURL;
    dataExchangeVia = userClientAllocationModel.dataExchangeVia;
    dataExchangeURL = userClientAllocationModel.dataExchangeURL;
    clientType = userClientAllocationModel.clientType;
    guid = userClientAllocationModel.guid;
    companyGUID = userClientAllocationModel.companyGUID;
    outletConfiguration = userClientAllocationModel.outletConfiguration;
  }

  static void clearMenuData() {
    productList = null;
    distinctStockGroup = null;
    productListStockDiff = null;
  }
}

class PreviousCartManager {
  static String? previousSalePointType;
  static String? previousSalePointName;
  static String? previousOutletName;
  static String? billingName;
  static String? shippingName;
  static String? billingGSTIN;
  static String? shippingGSTIN;
  static late List<MenuItemModel> runningCart;
}

class Config {
  static String password = "helloWorldIsTheCurrentPassword";
}

class AppBarVariables {
  static final List<Widget> aboutBoxChildren = <Widget>[
    const SizedBox(height: 24),
    const Text('Waiterr is an easy to go restaurant management application.'
        ' It is capable of placing orders and know offers by different restaurants'
        ' and also maintaing kitchens. '),
  ];

  static Widget appBarLeading(appBarLeading) => Row(
        children: [
          GestureDetector(
              onTap: () {
                showAboutDialog(
                  context: appBarLeading,
                  applicationIcon: Image.asset(
                    "assets/img/waiter_icon.png",
                    width: 40,
                    height: 40,
                  ),
                  applicationName: 'Waiterr',
                  applicationVersion: 'Version 2022.1',
                  applicationLegalese: '\u{a9} 2022 Business Genie.',
                  children: AppBarVariables.aboutBoxChildren,
                );
              },
              child: Image.asset(
                "assets/img/waiter_icon.png",
                height: 25,
                width: 25,
              )),
          const Text(
            "Waiterr",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          ),
        ],
      );
}
