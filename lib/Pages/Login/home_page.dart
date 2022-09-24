import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waiterr/global_class.dart';
import 'package:waiterr/Model/drawer_action_model.dart';
import 'package:waiterr/Model/qr_json_model.dart';
import 'package:waiterr/Model/user_restraunt_allocation_model.dart';
import 'package:waiterr/Modules/api_fetch_module.dart';
import 'package:waiterr/Pages/CautionPages/error_page.dart';
import 'package:waiterr/Pages/CautionPages/no_internet_page.dart';
import 'package:waiterr/Pages/TableManagement/table_management_page.dart';
import 'package:waiterr/Pages/User/about_page.dart';
import 'package:waiterr/Pages/User/profile_page.dart';
import 'package:waiterr/widgets/drawer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';
import 'package:waiterr/stores/login_store.dart';
import 'package:waiterr/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../../Model/vendor_card.dart';
import '../TableManagement/add_order_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = "homePage";
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String result = "";
  Future<List<UserRestrauntAllocationModel>>? _futureVendorList;
  List<UserRestrauntAllocationModel>? vendorList;
  bool? _isLoading, _isDataLoaded;

  Future _scanQR() async {
    String qrResult;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      qrResult = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      if (!mounted) return;

      setState(() {
        //decoding of the encrypted qrcode to be done
        result = qrResult;
        QRJSONModel qrval = getJson(qrResult);
        if (qrval.loginId.isNotEmpty &&
            qrval.userPassword.isNotEmpty &&
            qrval.restaurantId.isNotEmpty &&
            qrval.table.isNotEmpty &&
            qrval.outlet.isNotEmpty &&
            qrval.salespointType.isNotEmpty) {
          Navigator.of(context).push(
              CupertinoPageRoute<void>(builder: (context) => const AddOrder()));
        }
        //_save(false,"");
      });
    } on PlatformException {
      result = 'Failed to get platform version.';
    } on FormatException {
      setState(() {
        result = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
      });
    }
  }

  Future<List<UserRestrauntAllocationModel>> fetchVendorList() async {
    List<UserRestrauntAllocationModel> vendorList = [];
    await getUserClientAllocation(UserDetail.userDetails.id)
        .then((List<UserRestrauntAllocationModel> vendors) => {
              vendorList.addAll(vendors),
            });
    setState(() {
      _isLoading = false;
      _isDataLoaded = true;
    });
    return vendorList;
  }

  QRJSONModel getJson(String json) {
    var qrList = jsonDecode(json);
    QRJSONModel qrOb = QRJSONModel.fromJson(qrList);
    return qrOb;
  }

  _deleteUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'userData';
    prefs.remove(key);
  }

  //Overrides
  @override
  void initState() {
    super.initState();
    _futureVendorList = fetchVendorList();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    return Consumer<LoginStore>(
      builder: (_, loginStore, __) {
        return Scaffold(
          backgroundColor: GlobalTheme.backgroundColor,
          resizeToAvoidBottomInset: false,
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
                  actions: <Widget>[
                    IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () async {
                          Connectivity connectivity = Connectivity();
                          await connectivity
                              .checkConnectivity()
                              .then((value) => {
                                    if (value != ConnectivityResult.none)
                                      {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                PageRouteBuilder(
                                                    pageBuilder: (context,
                                                            animation1,
                                                            animation2) =>
                                                        const HomePage()),
                                                (route) => false)
                                      }
                                    else
                                      {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                PageRouteBuilder(
                                                    pageBuilder: (context,
                                                            animation1,
                                                            animation2) =>
                                                        const NoInternetPage()),
                                                (route) => false)
                                      }
                                  });
                        })
                  ],
                ),
                drawer: Drawer(
                    child: DrawerContent(
                  alternativeMno: "Something Went Wrong!!",
                  alternativeName: "waiterr",
                  drawerItems: [
                    DrawerActionModel(
                      title: "Profile",
                      iconData: Icons.account_circle,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(CupertinoPageRoute<void>(
                          title: "Profile Page",
                          builder: (context) => const ProfilePage(),
                        ));
                      },
                    ),
                    // DrawerActionModel(
                    //   title: "Running Orders",iconData:Icons.fastfood,
                    //   onTap:(){
                    //     Navigator.pop(context);
                    //     Navigator.of(context).push(CupertinoPageRoute<void>(
                    //       title: "Table Page",
                    //       builder:(context)=> KOTPage(item: new RunningOrderModel(Name:UserDetail.name)),
                    //     )
                    //     );
                    //   },
                    // ),
                    // DrawerActionModel(title: "Previous Orders",iconData:Icons.schedule,onTap:(){
                    //     Navigator.pop(context);
                    //   },
                    // ),
                    DrawerActionModel(
                      title: "About us",
                      iconData: Icons.info,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(CupertinoPageRoute<void>(
                          title: "About Page",
                          builder: (context) => const AboutPage(),
                        ));
                      },
                    ),
                    DrawerActionModel(
                      title: "Log out",
                      iconData: Icons.exit_to_app,
                      onTap: () {
                        Navigator.pop(context);
                        _deleteUserDetails();
                        loginStore.signOut(context);
                      },
                    ),
                  ],
                )),
                body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: AppBarVariables.appBarLeading(context),
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
                              child: ListView(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                children: [
                                  FutureBuilder<
                                          List<UserRestrauntAllocationModel>>(
                                      future: _futureVendorList,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          vendorList = snapshot.data;
                                          // return  Container(
                                          //   margin: EdgeInsets.only(left: 10),
                                          //     height: 132,
                                          //     child:ListView.builder(
                                          //       itemCount: vendorList.length,
                                          //       shrinkWrap: true,
                                          //       itemBuilder: (context, index) {
                                          //         return VendorCard(
                                          //             item: vendorList[index],
                                          //             onTap: () {
                                          //               UserClientAllocationData.setValues(vendorList[index]);
                                          //               Navigator.of(context).push(CupertinoPageRoute<void>(
                                          //                 title: "Running Orders",
                                          //                 builder:(context)=> UserClientAllocationData.clientType=="Steel Industry"?VendorOrderManagementPage():TableManagementPage(),
                                          //               ));
                                          //             }
                                          //         );
                                          //       },
                                          //     ),
                                          //   );
                                          return ListView.builder(
                                            itemCount: vendorList!.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return VendorCard(
                                                  item: vendorList![index],
                                                  onTap: () {
                                                    UserClientAllocationData
                                                        .setValues(
                                                            vendorList![index]);
                                                    Navigator.of(context).push(
                                                        CupertinoPageRoute<
                                                            void>(
                                                      title: "Running Orders",
                                                      builder: (context) =>
                                                          const TableManagementPage(),
                                                    ));
                                                  });
                                            },
                                          );
                                        } else if (snapshot.hasError) {
                                          return Container();
                                        }
                                        return Container(
                                            width: double.infinity,
                                            height: 500,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 16.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Shimmer.fromColors(
                                                      baseColor:
                                                          Colors.grey[300]!,
                                                      highlightColor:
                                                          Colors.grey[100]!,
                                                      enabled: true,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: <Widget>[
                                                              Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          10),
                                                                  color: Colors
                                                                      .white,
                                                                  height: 20,
                                                                  width: 70),
                                                              Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          10),
                                                                  color: Colors
                                                                      .white,
                                                                  height: 20,
                                                                  width: 20)
                                                            ],
                                                          ),
                                                          const Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        20.0),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom:
                                                                        10.0),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                const Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              8.0),
                                                                ),
                                                                Container(
                                                                  width: 15.0,
                                                                  height: 15.0,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                const Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              8.0),
                                                                ),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      Container(
                                                                        width:
                                                                            screenWidth /
                                                                                2,
                                                                        height:
                                                                            10.0,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      const Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(vertical: 2.0),
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: <
                                                                            Widget>[
                                                                          Container(
                                                                            width:
                                                                                100,
                                                                            height:
                                                                                10.0,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          Container(
                                                                            width:
                                                                                70,
                                                                            height:
                                                                                35,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          const Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        20.0),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: <Widget>[
                                                              Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          10),
                                                                  color: Colors
                                                                      .white,
                                                                  height: 20,
                                                                  width: 70),
                                                              Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          10),
                                                                  color: Colors
                                                                      .white,
                                                                  height: 20,
                                                                  width: 20)
                                                            ],
                                                          ),
                                                          const Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        20.0),
                                                          ),
                                                          ListView.builder(
                                                            shrinkWrap: true,
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            itemBuilder:
                                                                (_, __) =>
                                                                    Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          10.0),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  const Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            8.0),
                                                                  ),
                                                                  Container(
                                                                    width: 15.0,
                                                                    height:
                                                                        15.0,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  const Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            8.0),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                          width:
                                                                              screenWidth / 2,
                                                                          height:
                                                                              10.0,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        const Padding(
                                                                          padding:
                                                                              EdgeInsets.symmetric(vertical: 2.0),
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: <
                                                                              Widget>[
                                                                            Container(
                                                                              width: 100,
                                                                              height: 10.0,
                                                                              color: Colors.white,
                                                                            ),
                                                                            Container(
                                                                              width: 70,
                                                                              height: 35,
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.white,
                                                                                borderRadius: BorderRadius.circular(10.0),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            itemCount: 2,
                                                          )
                                                        ],
                                                      )),
                                                ),
                                              ],
                                            ));
                                      })
                                ],
                              ))),
                    ]),
                backgroundColor: GlobalTheme.backgroundColor.withOpacity(0.7),
                floatingActionButton: FloatingActionButton.extended(
                  icon: const Icon(Icons.center_focus_strong,
                      color: GlobalTheme.floatingButtonText),
                  label: const Text(
                    "Scan Qr",
                    textScaleFactor: 1,
                    style: TextStyle(
                        fontSize: 17, color: GlobalTheme.floatingButtonText),
                  ),
                  onPressed: _scanQR,
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
              )
            ],
          ),
        );
      },
    );
  }
}

// class VendorCard  extends StatelessWidget{
//   VendorCard({Key key, this.item, this.onTap}) : super(key: key);
//   final UserRestrauntAllocationModel item;
//   final onTap;
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       child: Container(
//           width: 70,
//           margin: EdgeInsets.only(top: 2,right: 2),
//           alignment: Alignment.center,
//           child:Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               CircleAvatar(
//                 radius: 35,
//                 //child: Image(height:50,filterQuality:FilterQuality.high,fit: BoxFit.fitHeight,image: item.image.image,),
//                 child: item.logoURL!=null&&item.logoURL!=""?CachedNetworkImage(
//                   imageUrl: item.logoURL,
//                   imageBuilder: (context, imageProvider) => Container(
//                     height: 50,
//                     width: 50,
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: imageProvider,
//                         fit: BoxFit.contain,
//                         //colorFilter:ColorFilter.mode(Colors.red, BlendMode.colorBurn)
//                       ),
//                     ),
//                   ),
//                   placeholder: (context, url) => Container(
//                       width: double.infinity,
//                       child: Center(
//                         child: Shimmer.fromColors(
//                           baseColor: Colors.grey[300].withOpacity(0.3),
//                           highlightColor: Colors.white,
//                           enabled: true,
//                           child: Container(
//                             width:50,
//                             height: 50,
//                             color: Colors.white,
//                           ),
//                         ),
//                       )
//                   ),
//                   errorWidget: (context, url, error) => Icon(Icons.error),
//                 ):Image(height:50,fit: BoxFit.fitHeight,image: Image.asset('assets/img/waiter_icon.png').image,),
//                 //Image(height:50,fit: BoxFit.fitHeight,image: Image.asset('assets/img/all_filter_icon.png').image,),
//                 backgroundColor: Colors.transparent,
//               ),
//               Text(item.clientName,textScaleFactor: 1,textAlign:TextAlign.center,maxLines: 4, overflow:TextOverflow.ellipsis,style: GoogleFonts.openSans(fontSize:11),),
//             ],
//           )
//       ),
//       onTap: onTap,
//     );
//   }
// }