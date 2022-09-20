import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:waiterr/global_class.dart';
import 'package:waiterr/Model/qr_json_model.dart';
import 'package:waiterr/Model/user_restraunt_allocation_model.dart';
import 'package:waiterr/Model/user_details_model.dart';
import 'package:waiterr/Model/user_login_model.dart';
import 'package:waiterr/Modules/api_fetch_module.dart';
import 'package:waiterr/Pages/CautionPages/error_has_occured_page.dart';
import 'package:waiterr/Pages/CautionPages/error_page_five_hundred_page.dart';
import 'package:waiterr/Pages/CautionPages/id_blocked_page.dart';
import 'package:waiterr/Pages/CautionPages/no_data_error_page.dart';
import 'package:waiterr/Pages/CautionPages/no_internet_page.dart';
import 'package:waiterr/Pages/CautionPages/waiter_not_allocated_page.dart';
import 'package:waiterr/Pages/TableManagement/table_management_page.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waiterr/Pages/Login/home_page.dart';
import 'package:waiterr/Pages/Login/sign_up_page.dart';
import 'package:waiterr/stores/login_store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'theme.dart';
import 'Pages/CautionPages/error_page.dart';

class RoutingPage extends StatefulWidget {
  final BuildContext context;
  const RoutingPage({Key? key, required this.context}) : super(key: key);
  @override
  State<RoutingPage> createState() => _RoutingPageState(context);
}

class _RoutingPageState extends State<RoutingPage> {
  final context1;
  UserRestrauntAllocationModel? ucam;
  Future<UserDetailsModel>? userDetails;
  _RoutingPageState(this.context1);
  Future<Widget?>? _widget;
  String? deviceToken;
  Future<Widget?> fetchPage() async {
    Widget? widget;
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceToken = androidInfo.androidId;
    } else if (Platform.isIOS) {
      // request permissions if we're on android
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceToken = iosInfo.identifierForVendor;
    }
    await Provider.of<LoginStore>(context1, listen: false)
        .isAlreadyAuthenticated()
        .then((result) async {
      if (result) {
        await _readUserDetails().then((UserLoginModel?
                offlineUserLoginDetail) async =>
            {
              if (offlineUserLoginDetail != null)
                {
                  UserDetail.loginDetail = offlineUserLoginDetail,
                }
              else
                {
                  UserDetail.loginDetail.mobileNumber =
                      Provider.of<LoginStore>(context1, listen: false)
                          .firebaseUser!
                          .phoneNumber!
                          .replaceAll("+91", ""),
                  UserDetail.loginDetail.password = "",
                  UserDetail.loginDetail.token = "",
                  UserDetail.loginDetail.tokenType = ""
                },
              await loginAppUserDetail(UserDetail.loginDetail)
                  .then((UserLoginModel resultLoginDetail) async => {
                        UserDetail.loginDetail = resultLoginDetail,
                        if (UserDetail.loginDetail.uid != null)
                          {
                            _saveUserDetails(UserDetail.loginDetail),
                            await getRegistrationDetails(resultLoginDetail.uid)
                                .then((UserDetailsModel
                                        resultUserDetail) async =>
                                    {
                                      UserDetail.userDetails = resultUserDetail,
                                      if (resultUserDetail.isActive)
                                        {
                                          if (resultUserDetail.roleID == 1)
                                            {
                                              _saveOfflineLogin(100),
                                              if (UserDetail.userDetails
                                                          .deviceToken ==
                                                      null ||
                                                  UserDetail.userDetails
                                                          .deviceToken !=
                                                      deviceToken)
                                                {
                                                  UserDetail.userDetails
                                                          .deviceToken =
                                                      resultUserDetail
                                                              .deviceToken =
                                                          deviceToken,
                                                  // _saveUserDetails(u),
                                                  await putRegistrationDetails(
                                                      resultUserDetail)
                                                },
                                              widget = const HomePage(),
                                            }
                                          else
                                            {
                                              if (UserDetail.userDetails
                                                      .deviceToken ==
                                                  null)
                                                {
                                                  UserDetail.userDetails
                                                          .deviceToken =
                                                      resultUserDetail
                                                              .deviceToken =
                                                          deviceToken,
                                                  // _saveUserDetails(u),
                                                  await putRegistrationDetails(
                                                      resultUserDetail),
                                                  await getUserClientAllocation(
                                                          resultUserDetail.id)
                                                      .then((List<UserRestrauntAllocationModel>
                                                              ucamList) async =>
                                                          {
                                                            _saveOfflineLogin(
                                                                100),
                                                            ucam = ucamList[0],
                                                            if (ucam!.guid!
                                                                .isNotEmpty)
                                                              {
                                                                UserClientAllocationData
                                                                    .setValues(
                                                                        ucam!),
                                                                _saveUserClientAllocationData(
                                                                    ucam!),
                                                                widget =
                                                                    const TableManagementPage()
                                                              }
                                                            else
                                                              {
                                                                widget =
                                                                    const WaiterNotAllocatedPage()
                                                              }
                                                          }),
                                                }
                                              else if (UserDetail.userDetails
                                                      .deviceToken !=
                                                  deviceToken)
                                                {
                                                  //Your Id Is Blocked.
                                                  _saveOfflineLogin(0),
                                                  widget = const IdBlockedPage()
                                                }
                                              else
                                                {
                                                  await getUserClientAllocation(
                                                          resultUserDetail.id)
                                                      .then((List<UserRestrauntAllocationModel>
                                                              ucamList) async =>
                                                          {
                                                            _saveOfflineLogin(
                                                                100),
                                                            ucam = ucamList[0],
                                                            if (ucam!.guid!
                                                                .isNotEmpty)
                                                              {
                                                                UserClientAllocationData
                                                                    .setValues(
                                                                        ucam!),
                                                                _saveUserClientAllocationData(
                                                                    ucam!),
                                                                widget =
                                                                    const TableManagementPage()
                                                              }
                                                            else
                                                              {
                                                                widget =
                                                                    const WaiterNotAllocatedPage()
                                                              }
                                                          }),
                                                }
                                            }
                                        }
                                      else
                                        {
                                          //Your Id Is Blocked.
                                          _saveOfflineLogin(0),
                                          widget = const IdBlockedPage()
                                        }
                                    })
                                .catchError((e) async {
                              ///original code is commented
                              // if(userDetails!=null)await _readOfflineLogin().then((int value) async => {
                              //   if(value>0)
                              //     {
                              //       print(value),
                              //       value--,
                              //       await _readUserDetails().then((UserDetailsModel u) async => {
                              //         UserDetail.isActive=u.isActive,
                              //         UserDetail.roleID=u.roleID,
                              //         UserDetail.uid=u.uid,
                              //         UserDetail.userID=u.userID,
                              //         UserDetail.name=u.name,
                              //         UserDetail.mobileNumber=u.mobileNumber,
                              //         if(u.isActive)
                              //           {
                              //             if(u.roleID==1)
                              //               {
                              //                 widget=ErrorPageFiveHundredPage(),
                              //               }
                              //             else
                              //               {
                              //                 await _readUserClientAllocationData().then((UserRestrauntAllocationModel ucamList) async => {
                              //                   ucam=ucamList,
                              //                   _saveOfflineLogin(value),
                              //                   if(ucam.guid.isNotEmpty)
                              //                     {
                              //                       UserClientAllocationData.setValues(ucam),
                              //                       widget=UserClientAllocationData.clientType=="Steel Industry"?VendorOrderManagementPage():TableManagementPage()
                              //                     }
                              //                   else{
                              //                     widget=WaiterNotAllocatedPage()
                              //                   }
                              //                 }
                              //                 ),
                              //               }
                              //           }
                              //         else
                              //           {
                              //             print(4),
                              //             //Your Id Is Blocked.
                              //             widget=IdBlockedPage()
                              //           }
                              //       })
                              //     }
                              //   else
                              //     {
                              //       widget = IdBlockedPage()
                              //     }
                              // });
                              // else throw e;

                              if (userDetails != null) {
                                // await _readUserDetails()
                                //     .then((UserLoginModel? u) async => {
                                //           UserDetail.loginDetail=u
                                //           if (u.isActive!)
                                //             {
                                //               if (u.roleID == 1)
                                //                 {
                                //                   widget =
                                //                       const ErrorPageFiveHundredPage(),
                                //                 }
                                //               else
                                //                 {
                                //                   await _readUserClientAllocationData().then(
                                //                       (UserRestrauntAllocationModel?
                                //                               ucamList) async =>
                                //                           {
                                //                             ucam = ucamList,
                                //                             if (ucam!.guid!
                                //                                 .isNotEmpty)
                                //                               {
                                //                                 UserClientAllocationData
                                //                                     .setValues(
                                //                                         ucam!),
                                //                                 widget =
                                //                                     const TableManagementPage()
                                //                               }
                                //                             else
                                //                               {
                                //                                 widget =
                                //                                     const WaiterNotAllocatedPage()
                                //                               }
                                //                           }),
                                //                 }
                                //             }
                                //           else
                                //             {
                                //               //Your Id Is Blocked.
                                //               widget = const IdBlockedPage()
                                //             }
                                //         });
                                widget = const NoDateErrorPage();
                              } else {
                                throw e;
                              }
                            })
                          }
                        else
                          {
                            await postRegistrationDetails(
                                    UserDetail.loginDetail.id,
                                    UserDetail.loginDetail.name,
                                    UserDetail.loginDetail.mobileNumber,
                                    deviceToken)
                                .then((UserDetailsModel u1) async => {
                                      UserDetail.userDetails = u1,
                                      //savedetail
                                      // _saveUserDetails(u1),
                                      if (u1.isActive)
                                        {
                                          if (u1.roleID == 1)
                                            {
                                              _saveOfflineLogin(100),
                                              widget = const HomePage(),
                                            }
                                          else
                                            {
                                              await getUserClientAllocation(
                                                      u1.id)
                                                  .then(
                                                      (List<UserRestrauntAllocationModel>
                                                              ucamList) async =>
                                                          {
                                                            ucam = ucamList[0],
                                                            _saveOfflineLogin(
                                                                100),
                                                            if (ucam!.guid!
                                                                .isNotEmpty)
                                                              {
                                                                UserClientAllocationData
                                                                    .setValues(
                                                                        ucam!),
                                                                _saveUserClientAllocationData(
                                                                    ucam!),
                                                                widget =
                                                                    const TableManagementPage()
                                                              }
                                                            else
                                                              {
                                                                widget =
                                                                    const WaiterNotAllocatedPage()
                                                              }
                                                          })
                                            }
                                        }
                                      else
                                        {
                                          //Your Id Is Blocked.
                                          _saveOfflineLogin(0),
                                          widget = const IdBlockedPage()
                                        }
                                    }),
                          }
                      })
            });
      } else {
        _saveOfflineLogin(100);
        widget = const SignUpPage();
      }
    });
    return widget;
  }

  _saveUserClientAllocationData(UserRestrauntAllocationModel u) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'userClientAllocationData';
    final value = jsonEncode(u.toJson());
    prefs.setString(key, value);
  }

  Future<UserRestrauntAllocationModel?> _readUserClientAllocationData() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'userClientAllocationData';
    final value = prefs.getString(key) ?? "";
    if (value != "") {
      return getJsonUserClientAllocationData(value);
    } else {
      return null;
    }
  }

  _saveOfflineLogin(int n) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'offlineLogin';
    final value = n;
    prefs.setInt(key, value);
  }

  Future<int> _readOfflineLogin() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'offlineLogin';
    final value = prefs.getInt(key) ?? 0;
    return value;
  }

  UserRestrauntAllocationModel getJsonUserClientAllocationData(String json) {
    var qrList = jsonDecode(json);
    UserRestrauntAllocationModel qrOb =
        UserRestrauntAllocationModel.fromJson(qrList);
    return qrOb;
  }

  _saveUserDetails(UserLoginModel u) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'userData';
    final value = jsonEncode(u.toJson());
    prefs.setString(key, value);
  }

  //Reads the user details from shared preferences.
  Future<UserLoginModel?> _readUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'userData';
    final value = prefs.getString(key) ?? "";
    if (value != "") {
      return UserLoginModel.fromJson(jsonDecode(value));
    } else {
      return null;
    }
  }

  QRJSONModel getJson(String json) {
    var qrList = jsonDecode(json);
    QRJSONModel qrOb = QRJSONModel.fromJson(qrList);
    return qrOb;
  }

  @override
  void initState() {
    super.initState();
    _widget = fetchPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder<Widget?>(
        future: _widget,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          } else if (snapshot.hasError) {
            if (kDebugMode) {
              print(snapshot.error);
            }
            if (snapshot.error.toString() == "NoInternet") {
              return const NoInternetPage();
            } else if (snapshot.error.toString() == "500") {
              return const ErrorPageFiveHundredPage();
            } else if (snapshot.error.toString() == "NoData") {
              return const NoDateErrorPage();
            } else if (snapshot.error.toString() == "401") {
              return const ErrorPageFourHundredOne();
            } else {
              return (UserDetail.userDetails.roleID == 2)
                  ? const WaiterNotAllocatedPage()
                  : const ErrorHasOccuredPage();
            }
            //else return Container(
            //padding:EdgeInsets.all(10),
            //child: Column(
            //children: [SizedBox(height: 100,),
            //Text(snapshot.error.toString())],),);
          }
          // By default, show a loading spinner.
          return Scaffold(
            backgroundColor: GlobalTheme.backgroundColor,
            body: Stack(
              children: [
                Positioned(
                  child: Image.asset(
                    "assets/img/background.jpg",
                  ),
                ),
                Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    leading: const Icon(Icons.dehaze),
                  ),
                  backgroundColor: GlobalTheme.backgroundColor.withOpacity(0.7),
                  body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: AppBarVariables.appBarLeading(context1),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Flexible(
                          child: Container(
                              height: MediaQuery.of(context).size.height,
                              padding: const EdgeInsets.only(top: 10),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: GlobalTheme.primaryText,
                                    blurRadius: 25.0, // soften the shadow
                                    spreadRadius: 5.0, //extend the shadow
                                    offset: Offset(
                                      15.0, // Move to right 10  horizontally
                                      15.0, // Move to bottom 10 Vertically
                                    ),
                                  )
                                ],
                              ),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Expanded(
                                      child: Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          enabled: true,
                                          child: ListView.builder(
                                            itemBuilder: (_, __) => Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 48.0,
                                                    height: 48.0,
                                                    color: Colors.white,
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8.0),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          height: 8.0,
                                                          color: Colors.white,
                                                        ),
                                                        const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      2.0),
                                                        ),
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          height: 8.0,
                                                          color: Colors.white,
                                                        ),
                                                        const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      2.0),
                                                        ),
                                                        Container(
                                                          width: 40.0,
                                                          height: 8.0,
                                                          color: Colors.white,
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            itemCount: 6,
                                          )),
                                    ),
                                  ],
                                ),
                              )),
                        )
                      ]),
                )
              ],
            ),
          );
        },
      ),
    );
  }
  // Replace these two methods in the examples that follow
}




// if(userDetails!=null)
//   {
//     await getRegistrationDetails(userDetails.mobileNumber).then((UserDetailsModel u) async => {
//       UserDetail.isActive=u.isActive,
//       UserDetail.roleID=u.roleID,
//       UserDetail.uid=u.uid,
//       UserDetail.userID=u.userID,
//       UserDetail.name=u.name,
//       UserDetail.mobileNumber=u.mobileNumber,
//       UserDetail.userProfileImageUrl=u.profileUrl,
//       UserDetail.deviceToken=u.deviceToken,
//       _saveUserDetails(u),
//       if(u.isActive)
//       {
//         if(u.roleID==1)
//         {
//           _saveOfflineLogin(100),
//           if(UserDetail.deviceToken==null||UserDetail.deviceToken!=firebaseToken){
//             UserDetail.deviceToken=u.deviceToken=firebaseToken,
//             _saveUserDetails(u),
//             await putRegistrationDetails(u)
//           },
//           widget=HomePage(),
//         }
//         else
//         {
//           if(UserDetail.deviceToken==null){
//             UserDetail.deviceToken=u.deviceToken=firebaseToken,
//             _saveUserDetails(u),
//             await putRegistrationDetails(u)
//           }
//           else if(UserDetail.deviceToken==firebaseToken)
//           {
//             await getUserClientAllocation(u.uid).then((List<UserRestrauntAllocationModel> ucamList) async => {
//               _saveOfflineLogin(100),
//               ucam=ucamList[0],
//               if(ucam.guid.isNotEmpty)
//                 {
//                   UserClientAllocationData.setValues(ucam),
//                   _saveUserClientAllocationData(ucam),
//                   widget=UserClientAllocationData.clientType=="Steel Industry"?VendorOrderManagementPage():TableManagementPage()
//                 }
//               else{
//                 widget=WaiterNotAllocatedPage()
//               }
//             }),
//           }
//           else{
//               //Your Id Is Blocked.
//               _saveOfflineLogin(0),
//               widget=IdBlockedPage()
//             }
//         }
//     }
//     else
//     {
//       //Your Id Is Blocked.
//       _saveOfflineLogin(0),
//       widget=IdBlockedPage()
//     }
//     }).catchError((e) async {
//       await _readOfflineLogin().then((int value) async => {
//         if(value>0)
//           {
//             value--,
//             await _readUserDetails().then((UserDetailsModel u) async => {
//             UserDetail.isActive=u.isActive,
//             UserDetail.roleID=u.roleID,
//             UserDetail.uid=u.uid,
//             UserDetail.userID=u.userID,
//             UserDetail.name=u.name,
//             UserDetail.mobileNumber=u.mobileNumber,
//             if(u.isActive)
//               {
//                 if(u.roleID==1)
//                   {
//                     widget=ErrorPageFiveHundredPage(),
//                   }
//                 else
//                   {
//                     await _readUserClientAllocationData().then((UserRestrauntAllocationModel ucamList) async => {
//                       ucam=ucamList,
//                       _saveOfflineLogin(value),
//                       if(ucam.guid.isNotEmpty)
//                         {
//                           UserClientAllocationData.setValues(ucam),
//                           widget=UserClientAllocationData.clientType=="Steel Industry"?VendorOrderManagementPage():TableManagementPage()
//                         }
//                       else{
//                         widget=WaiterNotAllocatedPage()
//                       }
//                     }
//                     ),
//                   }
//               }
//             else
//               {
//                 //Your Id Is Blocked.
//                 widget=IdBlockedPage()
//               }
//           })
//           }
//         else widget=IdBlockedPage()
//       });
//     }),
//   }
// else
//   {
//       UserDetail.mobileNumber=Provider.of<LoginStore>(context1, listen: false).firebaseUser.phoneNumber.replaceAll("+91", ""),
//       await getRegistrationDetails(UserDetail.mobileNumber).then((UserDetailsModel u) async => {
//         if(u.mobileNumber==UserDetail.mobileNumber)
//           {
//             UserDetail.isActive=u.isActive,
//             UserDetail.roleID=u.roleID,
//             UserDetail.uid=u.uid,
//             UserDetail.userID=u.userID,
//             UserDetail.name=u.name,
//             UserDetail.mobileNumber=u.mobileNumber,
//             UserDetail.userProfileImageUrl=u.profileUrl,
//             UserDetail.deviceToken=u.deviceToken,
//             if(u.isActive)
//               {
//                 if(u.roleID==1)
//                   {
//                     widget=HomePage(),
//                     _saveOfflineLogin(100),
//                     if(UserDetail.deviceToken==null||UserDetail.deviceToken!=firebaseToken){
//                       UserDetail.deviceToken=u.deviceToken=firebaseToken,
//                       await putRegistrationDetails(u)
//                     },
//                     _saveUserDetails(u),
//                   }
//                 else
//                   {
//                     //id blocked
//                     // _saveOfflineLogin(0),
//                     // widget=IdBlockedPage()
//
//                     if(UserDetail.deviceToken==null){
//                       UserDetail.deviceToken=u.deviceToken=firebaseToken,
//                       _saveUserDetails(u),
//                       await putRegistrationDetails(u)
//                     }
//                     else if(UserDetail.deviceToken==firebaseToken)
//                       {
//                         await getUserClientAllocation(u.uid).then((List<UserRestrauntAllocationModel> ucamList) async => {
//                           _saveOfflineLogin(100),
//                           ucam=ucamList[0],
//                           if(ucam.guid.isNotEmpty)
//                             {
//                               UserClientAllocationData.setValues(ucam),
//                               _saveUserClientAllocationData(ucam),
//                               widget=UserClientAllocationData.clientType=="Steel Industry"?VendorOrderManagementPage():TableManagementPage()
//                             }
//                           else{
//                             widget=WaiterNotAllocatedPage()
//                           }
//                         }
//                         ),
//                       }
//                     else{
//                         //Your Id Is Blocked.
//                         _saveOfflineLogin(0),
//                         widget=IdBlockedPage()
//                       }
//
//                   }
//               }
//             else
//               {
//                 //Your Id Is Blocked.
//                 _saveOfflineLogin(0),
//                 widget=IdBlockedPage()
//               }
//           }
//         else{
//           await postRegistrationDetails(UserDetail.name, UserDetail.mobileNumber,firebaseToken).then((UserDetailsModel u1) async => {
//             UserDetail.isActive=u1.isActive,
//             UserDetail.roleID=u1.roleID,
//             UserDetail.uid=u1.uid,
//             UserDetail.userID=u1.userID,
//             UserDetail.name=u1.name,
//             UserDetail.mobileNumber=u1.mobileNumber,
//             //savedetail
//             _saveUserDetails(u1),
//             if(u1.isActive)
//               {
//                 if(u1.roleID==1)
//                   {
//                     _saveOfflineLogin(100),
//                     widget=HomePage(),
//                   }
//                 else
//                   {
//                     await getUserClientAllocation(u.uid).then((List<UserRestrauntAllocationModel> ucamList)async => {
//                       ucam=ucamList[0],
//                       _saveOfflineLogin(100),
//                     if(ucam.guid.isNotEmpty)
//                       {
//                         UserClientAllocationData.setValues(ucam),
//                         _saveUserClientAllocationData(ucam),
//                         widget=UserClientAllocationData.clientType=="Steel Industry"?VendorOrderManagementPage():TableManagementPage()
//                       }
//                       else{
//                         widget=WaiterNotAllocatedPage()
//                       }
//                     })
//                   }
//               }
//             else
//               {
//                 //Your Id Is Blocked.
//                 _saveOfflineLogin(0),
//                 widget=IdBlockedPage()
//               }
//           }),
//         }
//       })
//   }