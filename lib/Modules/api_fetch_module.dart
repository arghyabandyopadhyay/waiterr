import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:waiterr/Model/comment_for_kot_suggestion_model.dart';
import 'package:waiterr/Model/customer_details_model.dart';
import 'package:waiterr/Model/favourites_json_model.dart';
import 'package:waiterr/Model/filter_item_model.dart';
import 'package:waiterr/Model/kot_model.dart';
import 'package:waiterr/Model/menu_item_model.dart';
import 'package:waiterr/Model/outlet_configuration_model.dart';
import 'package:waiterr/Model/product_detail_model.dart';
import 'package:waiterr/Model/RequestJson/place_order_json.dart';
import 'package:waiterr/Model/RequestJson/parameter.dart';
import 'package:waiterr/Model/RequestJson/universal_json.dart';
import 'package:waiterr/Model/running_order_model.dart';
import 'package:waiterr/Model/user_restraunt_allocation_model.dart';
import 'package:waiterr/Model/user_details_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart';
import 'package:waiterr/Model/user_login_model.dart';
import '../Model/tax_model.dart';
import '../Model/waiter_details_model.dart';
import '../global_class.dart';

//ready
Future<UserLoginModel> loginAppUserDetail(UserLoginModel loginDetails) async {
  late Response response;
  try {
    loginDetails.password = Config.password;
    response = await post(Uri.parse('${UserDetail.currentUrl}app/login'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(loginDetails.toJsonForLogin()));
  } catch (E) {
    Connectivity connectivity = Connectivity();
    await connectivity.checkConnectivity().then((value) => {
          if (value.isEmpty)
            {
              throw "NoInternet",
            }
          else
            throw "ErrorHasOccurred"
        });
  }
  if (response.statusCode == 201 || response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the json.
    if (response.body.isNotEmpty) {
      return UserLoginModel.fromJson(json.decode(response.body));
    } else {
      throw "NoData";
    }
  } else if (response.statusCode == 401) {
    throw 401;
  } else if (response.statusCode == 500) {
    throw 500;
  } else {
    throw "ErrorHasOccurred";
  }
}

//ready
Future<String> registerAppUserDetail(UserLoginModel userLoginModel) async {
  late Response response;
  try {
    response = await post(Uri.parse('${UserDetail.currentUrl}app/register'),
        body: json.encode(userLoginModel.toJson()));
  } catch (E) {
    Connectivity connectivity = Connectivity();
    await connectivity.checkConnectivity().then((value) => {
          if (value.isEmpty)
            {
              throw "NoInternet",
            }
          else
            throw "ErrorHasOccurred"
        });
  }
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the json.
    if (response.body == "Unable to Connect to remote Server") {
      throw 500;
    } else {
      if (response.body.isNotEmpty) {
        return response.body;
      } else {
        throw "NoData";
      }
    }
  } else if (response.statusCode == 500) {
    throw 500;
  } else {
    throw "ErrorHasOccurred";
  }
}

//ready
Future<UserDetailsModel> userRegistration(String? id) async {
  late Response response;
  try {
    response = await get(
            Uri.parse('${UserDetail.currentUrl}userdetails?id=$id'),
            headers: UserDetail.getHeader())
        .timeout(const Duration(seconds: 2));
  } catch (E) {
    Connectivity connectivity = Connectivity();
    await connectivity.checkConnectivity().then((value) => {
          if (value.isEmpty)
            {
              throw "NoInternet",
            }
          else
            throw "ErrorHasOccurred"
        });
  }
  if (response.statusCode == 201 || response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the json.
    if (response.body.isNotEmpty) {
      return UserDetailsModel.fromJson(json.decode(response.body)[0]);
    } else {
      throw "NoData";
    }
  } else if (response.statusCode == 500) {
    // If the server didnt return a 200 OK response,
    // then parse the json.
    return UserDetailsModel(
        id: "", name: "New", mobileNumber: "", roleID: 1, isActive: true);
  } else {
    // If the server didnt return a 200 OK response,
    // then parse the json.
    throw "ErrorHasOccurred";
  }
}

//ready
Future<UserDetailsModel> getRegistrationDetails(String? id) async {
  late Response response;
  try {
    response = await get(
            Uri.parse('${UserDetail.currentUrl}userdetails?id=$id'),
            headers: UserDetail.getHeader())
        .timeout(const Duration(seconds: 2));
  } catch (E) {
    Connectivity connectivity = Connectivity();
    await connectivity.checkConnectivity().then((value) => {
          if (value.isEmpty)
            {
              throw "NoInternet",
            }
          else
            throw "ErrorHasOccurred"
        });
  }
  if (response.statusCode == 201 || response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the json.
    if (response.body.isNotEmpty) {
      UserDetailsModel detail =
          UserDetailsModel.fromJson(json.decode(response.body));
      return detail;
    } else {
      throw "NoData";
    }
  } else if (response.statusCode == 500) {
    throw 500;
  } else {
    throw "ErrorHasOccurred";
  }
}

Future<void> putRegistrationDetails(UserDetailsModel userDetailsModel) async {
  String body = json.encode(userDetailsModel.toJson());
  late Response response;
  try {
    response = await put(
      Uri.parse(
          '${UserDetail.currentUrl}userdetails?id=${userDetailsModel.id}'),
      headers: UserDetail.getHeader(),
      body: body,
    ).timeout(const Duration(seconds: 4));
  } catch (E) {
    Connectivity connectivity = Connectivity();
    await connectivity.checkConnectivity().then((value) => {
          if (value.isEmpty)
            {
              throw "NoInternet",
            }
          else
            throw "ErrorHasOccurred"
        });
  }
  if (response.statusCode == 201 ||
      response.statusCode == 200 ||
      response.statusCode == 204) {
  } else {
    // If the server didnt return a 200 OK response,
    // then parse the json.
    throw "ErrorHasOccurred";
  }
}

//ready
Future<UserDetailsModel> postRegistrationDetails(
    int? id, String? name, String? mobileNumber, String? deviceToken) async {
  Map data = {
    "id": id,
    "Name": name,
    "MobileNumber": mobileNumber,
    "RoleId": 1,
    "IsActive": true,
    "DeviceToken": deviceToken
  };
  String body = json.encode(data);
  late Response response;
  try {
    response = await post(
      Uri.parse('${UserDetail.currentUrl}userdetails'),
      headers: UserDetail.getHeader(),
      body: body,
    ).timeout(const Duration(seconds: 2));
  } catch (E) {
    Connectivity connectivity = Connectivity();
    await connectivity.checkConnectivity().then((value) => {
          if (value.isEmpty)
            {
              throw "NoInternet",
            }
          else
            throw "ErrorHasOccurred"
        });
  }
  if (response.statusCode == 201 || response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the json.
    if (response.body.isNotEmpty) {
      UserDetailsModel finalResponse =
          UserDetailsModel.fromJson(json.decode(response.body));
      UserDetail.loginDetail.uid = finalResponse.id;
      return finalResponse;
    } else {
      throw "NoData";
    }
  } else if (response.statusCode == 500 ||
      response.statusCode == 403 ||
      response.statusCode == 401) {
    throw response.statusCode;
  } else {
    throw "ErrorHasOccurred";
  }
}

//Ready
Future<CustomerDetailsModel> getCustomerDetails(String mobile) async {
  late Response response;
  try {
    response = await get(
            Uri.parse('${UserDetail.currentUrl}customerBank?mobile=$mobile'),
            headers: UserDetail.getHeader())
        .timeout(const Duration(seconds: 2));
  } catch (E) {
    Connectivity connectivity = Connectivity();
    await connectivity.checkConnectivity().then((value) => {
          if (value.isEmpty)
            {
              throw "NoInternet",
            }
          else
            throw "ErrorHasOccurred"
        });
  }
  if (response.statusCode == 201 || response.statusCode == 200) {
    if (response.body.isNotEmpty) {
      return CustomerDetailsModel.fromJson(json.decode(response.body));
    } else {
      return CustomerDetailsModel(
          name: "New", mobileNumber: "", customerId: "", dataSource: "");
    }
  } else {
    throw "ErrorHasOccurred";
  }
}

//Ready
Future<UserDetailsModel> getUserDetail(String mobile) async {
  RequestJson requestJson = RequestJson(
      requestType: "Waiters",
      parameterList: ([Parameter(pKey: "MobileNo", pValue: mobile)]));
  UniversalJson universalJson = UniversalJson(
      gUID: UserClientAllocationData.guid,
      companyGUID: UserClientAllocationData.companyGUID,
      requestJSON: requestJson);
  String responseBody = await responseGeneratorPost(json.encode(universalJson));
  return UserDetailsModel.fromJson(jsonDecode(responseBody));
}

//ready
Future<List<UserRestrauntAllocationModel>> getUserClientAllocation(
    String? uid) async {
  late Response response;
  try {
    response = await get(
            Uri.parse('${UserDetail.currentUrl}UserClientAllocation?id=$uid'),
            headers: UserDetail.getHeader())
        .timeout(const Duration(seconds: 2));
  } catch (E) {
    Connectivity connectivity = Connectivity();
    await connectivity.checkConnectivity().then((value) => {
          if (value.isEmpty)
            {
              throw "NoInternet",
            }
          else
            throw "ErrorHasOccurred"
        });
  }
  if (response.statusCode == 201 || response.statusCode == 200) {
    if (response.body.isNotEmpty) {
      return (jsonDecode(response.body) as List)
          .map((data) => UserRestrauntAllocationModel.fromJson(data))
          .toList();
    } else {
      throw "NoData";
    }
  } else if (response.statusCode == 204) {
    throw "NoData";
  } else if (response.statusCode == 500) {
    throw 500;
  } else {
    throw "WaiterNotAllocated";
  }
}

//ready
Future<CustomerDetailsModel> postCustomerDetails(
    String name, String mobileNumber) async {
  Map data = {
    "name": name,
    "mobileNumber": mobileNumber,
  };
  String body = json.encode(data);
  late Response response;
  try {
    response = await post(
      Uri.parse("${UserDetail.currentUrl}customerBank"),
      headers: UserDetail.getHeader(),
      body: body,
    ).timeout(const Duration(seconds: 2));
  } catch (E) {
    Connectivity connectivity = Connectivity();
    await connectivity.checkConnectivity().then((value) => {
          if (value.isEmpty)
            {
              throw "NoInternet",
            }
          else
            throw "ErrorHasOccurred"
        });
  }
  if (response.statusCode == 201 || response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the json.
    if (response.body == "Unable to Connect to remote Server") {
      throw 500;
    } else {
      if (response.body.isNotEmpty) {
        return CustomerDetailsModel.fromJson(json.decode(response.body));
      } else {
        throw "NoData";
      }
    }
  } else if (response.statusCode == 500) {
    throw 500;
  } else {
    // If the server did return a 200 OK response,
    // then parse the json.
    //return new UserRestrauntAllocationModel(clientName:"",guid:"",companyGUID: "",dataExchangeVia: "");
    throw "ErrorHasOccurred";
  }
}

//ready
Future<int> putCustomerDetails(
    CustomerDetailsModel customerDetailsModel) async {
  Map data = customerDetailsModel.toJson();
  String body = json.encode(data);
  late Response response;
  try {
    response = await put(
      Uri.parse(
          '${UserDetail.currentUrl}customerBank?id=${customerDetailsModel.customerId}'),
      headers: UserDetail.getHeader(),
      body: body,
    ).timeout(const Duration(seconds: 2));
  } catch (E) {
    Connectivity connectivity = Connectivity();
    await connectivity.checkConnectivity().then((value) => {
          if (value.isEmpty)
            {
              throw "NoInternet",
            }
          else
            throw "ErrorHasOccurred"
        });
  }
  if (response.statusCode == 201 ||
      response.statusCode == 200 ||
      response.statusCode == 204) {
    // If the server did return a 200 OK response,
    // then parse the json.
    return 200;
  } else if (response.statusCode == 500) {
    throw 500;
  } else {
    // If the server did return a 200 OK response,
    // then parse the json.
    //return new UserRestrauntAllocationModel(clientName:"",guid:"",companyGUID: "",dataExchangeVia: "");
    throw "ErrorHasOccurred";
  }
}

//ready
Future<List<RunningOrderModel>> postForRunningOrders(
    bool forAddOrder,
    bool isWaiter,
    String? salepointType,
    String salePointName,
    String? outlet,
    bool? includePastOrder) async {
  RequestJson requestJson = RequestJson(
      requestType: forAddOrder ? "Active Sale Point" : "Running Orders",
      parameterList: (forAddOrder
          ? [
              Parameter(pKey: "Outlet", pValue: outlet),
              Parameter(pKey: "SalePointType", pValue: salepointType),
              Parameter(pKey: "SalePointName", pValue: salePointName)
            ]
          : (isWaiter
              ? null
              : [
                  Parameter(pKey: "IncludePastOrder", pValue: includePastOrder),
                  Parameter(pKey: "WaiterId", pValue: UserDetail.userDetails.id)
                ])));
  UniversalJson universalJson = UniversalJson(
      gUID: isWaiter ? UserClientAllocationData.guid : null,
      companyGUID: isWaiter ? UserClientAllocationData.companyGUID : null,
      requestJSON: requestJson);
  String body = json.encode(universalJson);
  late Response response;
  try {
    response = await post(
      Uri.parse(isWaiter
          ? UserClientAllocationData.dataExchangeURL!
          : "${UserDetail.currentUrl}master/"),
      headers: UserDetail.getHeader(),
      body: body,
    );
  } catch (E) {
    if (kDebugMode) print(E);
    Connectivity connectivity = Connectivity();
    await connectivity.checkConnectivity().then((value) => {
          if (value.isEmpty)
            {
              throw "NoInternet",
            }
          else
            throw "ErrorHasOccurred"
        });
  }
  if (kDebugMode) print(response.body);
  if (response.statusCode == 201 || response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the json.
    if (response.body == "Unable to Connect to remote Server") {
      throw 500;
    } else {
      //for(var value in json.decode(response.body))rList.add(RunningOrderModel.fromJson(value));
      if (response.body.isNotEmpty) {
        if (kDebugMode) print(response.body);
        return ((json.decode(response.body)) as List)
            .map((data) => RunningOrderModel.fromJson(data))
            .toList();
      } else if (forAddOrder) {
        return [];
      } else {
        throw "NoData";
      }
    }
  } else if (response.statusCode == 500) {
    throw 500;
  } else {
    throw "ErrorHasOccurred";
  }
}

//Ready
Future<int> postForUserClientAllocation(
    String userId, String outletId, int ucaRoleId, bool isEdit) async {
  RequestJson requestJson = RequestJson(
      requestType: "Waiters",
      parameterList: ([
        Parameter(pKey: "id", pValue: userId),
        Parameter(pKey: "OutletId", pValue: outletId),
        Parameter(pKey: "UCARoleId", pValue: ucaRoleId),
        Parameter(pKey: "ModificationType", pValue: isEdit ? "Edit" : "Create")
      ]));
  UniversalJson universalJson = UniversalJson(
      gUID: UserClientAllocationData.guid,
      companyGUID: UserClientAllocationData.companyGUID,
      requestJSON: requestJson);
  String responseBody = await responseGeneratorPost(json.encode(universalJson));
  responseBody = jsonDecode(responseBody);
  if ((!isEdit && responseBody == "user client allocation data inserted") ||
      (isEdit && responseBody == "user client allocation data updated")) {
    return 200;
  } else {
    return 500;
  }
}

//Ready
Future<int> terminateRunningOrders(String? runningOrderId) async {
  RequestJson requestJson = RequestJson(
      requestType: "Running Orders",
      parameterList: ([
        Parameter(pKey: "RunningOrderId", pValue: runningOrderId),
      ]));
  UniversalJson universalJson = UniversalJson(
      gUID: UserClientAllocationData.guid,
      companyGUID: UserClientAllocationData.companyGUID,
      requestJSON: requestJson);
  String responseBody = await responseGeneratorPost(json.encode(universalJson));
  responseBody = jsonDecode(responseBody);
  if (responseBody == "Running order terminated successfully") {
    return 200;
  } else {
    return 500;
  }
}

//Ready
Future<int> deleteUserClientAllocation(String? userClientAllocationId) async {
  RequestJson requestJson = RequestJson(
      requestType: "Waiters",
      parameterList: ([
        Parameter(pKey: "id", pValue: userClientAllocationId),
        Parameter(pKey: "OutletId", pValue: null),
        Parameter(pKey: "UCARoleId", pValue: null),
        Parameter(pKey: "ModificationType", pValue: "Delete")
      ]));
  UniversalJson universalJson = UniversalJson(
      gUID: UserClientAllocationData.guid,
      companyGUID: UserClientAllocationData.companyGUID,
      requestJSON: requestJson);
  String responseBody = await responseGeneratorPost(json.encode(universalJson));
  responseBody = jsonDecode(responseBody);
  if (responseBody == "User client allocation data deleted successfully") {
    return 200;
  } else {
    return 500;
  }
}

//Ready
Future<List<CommentForKotSuggestionsModel>> postForCommentOnKot(
    String? itemId) async {
  UniversalJson universalJson = UniversalJson(
      gUID: UserClientAllocationData.guid,
      companyGUID: UserClientAllocationData.companyGUID,
      requestJSON: RequestJson(
          requestType: "Comment For KOT",
          parameterList: [Parameter(pKey: "menuItemId", pValue: itemId)]));
  String responseBody = await responseGeneratorPost(json.encode(universalJson));
  return ((json.decode(responseBody)) as List)
      .map((data) => CommentForKotSuggestionsModel.fromJson(data))
      .toList();
}

Future<String> postForTakeAway(String? outletId) async {
  final now = DateTime.now();
  UniversalJson universalJson = UniversalJson(
      gUID: UserClientAllocationData.guid,
      companyGUID: UserClientAllocationData.companyGUID,
      requestJSON: RequestJson(requestType: "Max TakeAway", parameterList: [
        Parameter(pKey: "outletId", pValue: outletId),
        Parameter(
            pKey: "currentDate",
            pValue: DateTime(now.year, now.month, now.day).toString())
      ]));
  String responseBody = await responseGeneratorPost(json.encode(universalJson));
  return responseBody;
}

//ready
Future<List<KOTModel>> postForSalesPointHistory(
    String? outletId,
    String? salePointType,
    String? salePointName,
    String? approvalType,
    bool? isTerminated) async {
  RequestJson requestJson = RequestJson(
      requestType: "Sale Point History",
      parameterList: (salePointName != null && salePointType != null)
          ? [
              Parameter(pKey: "SalePointType", pValue: salePointType),
              Parameter(pKey: "SalePointName", pValue: salePointName),
              Parameter(pKey: "OutletId", pValue: outletId),
              Parameter(
                  pKey: 'IsTerminated', pValue: (isTerminated ?? false) ? 1 : 0)
            ]
          : [Parameter(pKey: "ApprovalType", pValue: approvalType)]);
  UniversalJson universalJson = UniversalJson(
      gUID: UserClientAllocationData.guid,
      companyGUID: UserClientAllocationData.companyGUID,
      requestJSON: requestJson);
  String responseBody = await responseGeneratorPost(json.encode(universalJson));
  return (jsonDecode(responseBody) as List)
      .map((data) => KOTModel.fromJson(data))
      .toList();
}

//ready
Future<int> postForOrderApproval(
    String runningOrderId,
    String kotNumber,
    bool forAggregate,
    bool forApproval,
    String approvalType,
    bool allProcessed) async {
  RequestJson requestJson =
      RequestJson(requestType: "Order Approval", parameterList: [
    Parameter(pKey: "ForApproval", pValue: forApproval),
    Parameter(pKey: "ForAggregate", pValue: forAggregate),
    Parameter(pKey: "ApprovalType", pValue: approvalType),
    Parameter(
        pKey: "RunningOrderId", pValue: (!forAggregate) ? runningOrderId : ""),
    Parameter(pKey: "KotNumber", pValue: kotNumber),
    Parameter(pKey: "AllProcessed", pValue: allProcessed)
  ]);
  UniversalJson universalJson = UniversalJson(
      gUID: UserClientAllocationData.guid,
      companyGUID: UserClientAllocationData.companyGUID,
      requestJSON: requestJson);
  String responseBody = await responseGeneratorPost(json.encode(universalJson));
  responseBody = jsonDecode(responseBody);
  if (responseBody == "Success") {
    return 200;
  } else {
    return 500;
  }
}

//ready
Future<ProductDetailModel> postForMenuItemDetails(String menuItemId) async {
  RequestJson requestJson =
      RequestJson(requestType: "waiterr Menu Item Detail", parameterList: [
    Parameter(pKey: "menuItemId", pValue: menuItemId),
  ]);
  UniversalJson universalJson = UniversalJson(
      gUID: UserClientAllocationData.guid,
      companyGUID: UserClientAllocationData.companyGUID,
      requestJSON: requestJson);
  String responseBody = await responseGeneratorPost(json.encode(universalJson));
  return ProductDetailModel.fromJson(jsonDecode(responseBody));
}

//ready
Future<List<WaiterDetailsModel>> postForEmployeeDetails(
    bool isForAdminManagement) async {
  RequestJson requestJson =
      RequestJson(requestType: "Waiters", parameterList: null);
  UniversalJson universalJson = UniversalJson(
      gUID: UserClientAllocationData.guid,
      companyGUID: UserClientAllocationData.companyGUID,
      requestJSON: requestJson);
  String responseBody = await responseGeneratorPost(json.encode(universalJson));
  return (jsonDecode(responseBody) as List)
      .map((data) => WaiterDetailsModel.fromJson(data))
      .where((element) => isForAdminManagement
          ? element.ucaRoleId == 4
          : element.ucaRoleId != 4)
      .toList();
}

//ready
Future<List<MenuItemModel>> postForMenuItem(
    String userId, String? outletId) async {
  RequestJson requestJson = RequestJson(
      requestType: "Waiterr Menu",
      parameterList: (userId != "" || outletId != null)
          ? [
              if (userId != "") Parameter(pKey: "userId", pValue: userId),
              if (outletId != null)
                Parameter(pKey: "restaurantId", pValue: outletId)
            ]
          : null);
  UniversalJson universalJson = UniversalJson(
      gUID: UserClientAllocationData.guid,
      companyGUID: UserClientAllocationData.companyGUID,
      requestJSON: requestJson);
  String responseBody = await responseGeneratorPost(json.encode(universalJson));
  return (jsonDecode(responseBody) as List)
      .map((data) => MenuItemModel.fromJson(data))
      .toList();
}

Future<int> postForMenuItemModification(
    MenuItemModel menuItemModel, bool isForEdit) async {
  RequestJson requestJson =
      RequestJson(requestType: "Waiterr Menu Edit", parameterList: [
    if (isForEdit) Parameter(pKey: "id", pValue: menuItemModel.itemID),
    Parameter(
        pKey: "menuItem", pValue: jsonEncode(menuItemModel.toMap(isForEdit)))
  ]);
  UniversalJson universalJson = UniversalJson(
      gUID: UserClientAllocationData.guid,
      companyGUID: UserClientAllocationData.companyGUID,
      requestJSON: requestJson);
  String responseBody = await responseGeneratorPost(json.encode(universalJson));
  responseBody = jsonDecode(responseBody);
  if (responseBody == "Success") {
    return 200;
  } else {
    return 500;
  }
}

//ready
Future<List<FilterItemModel>> postForMenuGroupItem(String? outletId) async {
  RequestJson requestJson = RequestJson(
      requestType: "Waiterr Menu Group",
      parameterList: (outletId == null)
          ? null
          : [Parameter(pKey: "OutletId", pValue: outletId)]);
  UniversalJson universalJson = UniversalJson(
      gUID: UserClientAllocationData.guid,
      companyGUID: UserClientAllocationData.companyGUID,
      requestJSON: requestJson);
  String responseBody = await responseGeneratorPost(json.encode(universalJson));
  return (jsonDecode(responseBody) as List)
      .map((data) => FilterItemModel.fromJson(data))
      .toList();
}

//ready
Future<int> postForMenuGroupItemModification(String stockGroup, String outletID,
    String? id, String imageUrl, String modificationType) async {
  RequestJson requestJson =
      RequestJson(requestType: "Waiterr Menu Group", parameterList: [
    Parameter(pKey: "StockGroup", pValue: stockGroup),
    Parameter(pKey: "OutletId", pValue: outletID),
    Parameter(pKey: "id", pValue: id),
    Parameter(pKey: "ImageUrl", pValue: imageUrl),
    Parameter(pKey: "ModificationType", pValue: modificationType)
  ]);
  UniversalJson universalJson = UniversalJson(
      gUID: UserClientAllocationData.guid,
      companyGUID: UserClientAllocationData.companyGUID,
      requestJSON: requestJson);
  String responseBody = await responseGeneratorPost(json.encode(universalJson));
  responseBody = jsonDecode(responseBody);
  if (responseBody == "Success") {
    return 200;
  } else {
    return 500;
  }
}

Future<List<TaxModel>> postForTaxClass() async {
  RequestJson requestJson =
      RequestJson(requestType: "Tax Class", parameterList: null);
  UniversalJson universalJson = UniversalJson(
      gUID: UserClientAllocationData.guid,
      companyGUID: UserClientAllocationData.companyGUID,
      requestJSON: requestJson);
  String responseBody = await responseGeneratorPost(json.encode(universalJson));
  List<TaxModel> result = (jsonDecode(responseBody) as List)
      .map((data) => TaxModel.fromJson(data))
      .toList();
  return result;
}

Future<int> postForTaxClassAddition(String taxClass, double taxRate) async {
  RequestJson requestJson =
      RequestJson(requestType: "Tax Class", parameterList: [
    Parameter(pKey: "TaxClass", pValue: taxClass),
    Parameter(pKey: "TaxRate", pValue: taxRate)
  ]);
  UniversalJson universalJson = UniversalJson(
      gUID: UserClientAllocationData.guid,
      companyGUID: UserClientAllocationData.companyGUID,
      requestJSON: requestJson);
  String responseBody = await responseGeneratorPost(json.encode(universalJson));
  responseBody = jsonDecode(responseBody);
  if (responseBody == "Success") {
    return 200;
  } else {
    return 500;
  }
}

Future<List<OutletConfigurationModel>> postForOutlets() async {
  RequestJson requestJson =
      RequestJson(requestType: "Outlet Configurations", parameterList: null);
  UniversalJson universalJson = UniversalJson(
      gUID: UserClientAllocationData.guid,
      companyGUID: UserClientAllocationData.companyGUID,
      requestJSON: requestJson);
  String responseBody = await responseGeneratorPost(json.encode(universalJson));
  List<OutletConfigurationModel> result = (jsonDecode(responseBody) as List)
      .map((data) => OutletConfigurationModel.fromJson(data))
      .toList();
  return result;
}

Future<int> postForOutletModification(String outletName, String outletSalePoint,
    String id, String modificationType) async {
  RequestJson requestJson =
      RequestJson(requestType: "Outlet Configurations", parameterList: [
    Parameter(pKey: "OutletName", pValue: outletName),
    Parameter(pKey: "OutletSalePoint", pValue: outletSalePoint),
    Parameter(pKey: "id", pValue: id),
    Parameter(pKey: "ModificationType", pValue: modificationType)
  ]);
  UniversalJson universalJson = UniversalJson(
      gUID: UserClientAllocationData.guid,
      companyGUID: UserClientAllocationData.companyGUID,
      requestJSON: requestJson);
  String responseBody = await responseGeneratorPost(json.encode(universalJson));
  responseBody = jsonDecode(responseBody);
  if (responseBody == "Success") {
    return 200;
  } else {
    return 500;
  }
}

Future<List<FavouritesJsonModel>> postForFavouritesItem(
    String? userMobile) async {
  RequestJson requestJson =
      RequestJson(requestType: "Favourite Items", parameterList: [
    Parameter(pKey: "UserMobile", pValue: userMobile),
  ]);
  UniversalJson universalJson = UniversalJson(
      gUID: UserClientAllocationData.guid,
      companyGUID: UserClientAllocationData.companyGUID,
      requestJSON: requestJson);
  String responseBody = await responseGeneratorPost(json.encode(universalJson));
  return (jsonDecode(responseBody) as List)
      .map((data) => FavouritesJsonModel.fromJson(data))
      .toList();
}

//ready
Future<int> postForPlaceOrder(PlaceOrderJson placeOrderJson) async {
  String parameterList = jsonEncode(placeOrderJson.toJson());
  Map requestJson = {
    "RequestType": "Place Order",
    "ParameterList": null,
    "RequestBody": parameterList
  };
  Map jsonData = {
    "GUID": UserClientAllocationData.guid,
    "CompanyGUID": UserClientAllocationData.companyGUID,
    "RequestDateTime": DateTime.now().toIso8601String(),
    "RequestJSON": json.encode(requestJson)
  };
  String responseBody = await responseGeneratorPost(json.encode(jsonData));
  responseBody = jsonDecode(responseBody);
  if (responseBody == "success") {
    return 200;
  } else if (responseBody == "bill printed") {
    return 201;
  } else {
    return 500;
  }
}

Future<String> responseGeneratorPost(String body) async {
  if (kDebugMode) {
    print(body);
    print(Uri.parse(UserClientAllocationData.dataExchangeURL!));
  }
  late Response response;
  try {
    response = await post(
      Uri.parse(UserClientAllocationData.dataExchangeURL!),
      headers: UserDetail.getHeader(),
      body: body,
    );
  } catch (E) {
    Connectivity connectivity = Connectivity();
    await connectivity.checkConnectivity().then((value) => {
          if (value.isEmpty)
            {
              throw "NoInternet",
            }
          else
            throw "ErrorHasOccurred"
        });
  }
  if (response.statusCode == 201 || response.statusCode == 200) {
    if (response.body == "Unable to Connect to remote Server") {
      throw 500;
    } else {
      if (response.body.isNotEmpty) {
        return response.body;
      } else {
        throw "NoData";
      }
    }
  } else if (response.statusCode == 500) {
    throw 500;
  } else if (response.statusCode == 204) {
    throw "NoData";
  } else {
    // If the server did return a 200 OK response,
    // then parse the json.
    throw "ErrorHasOccurred";
  }
}
