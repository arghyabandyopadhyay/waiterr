import 'package:waiterr/Model/drawer_action_model.dart';
import 'package:waiterr/Model/running_order_model.dart';
import 'package:waiterr/Modules/api_fetch_module.dart';
import 'package:waiterr/Pages/CautionPages/error_page.dart';
import 'package:waiterr/Pages/CautionPages/no_internet_page.dart';
import 'package:waiterr/Pages/Restaurant/waiter_manager_page.dart';
import 'package:waiterr/Pages/TableManagement/approve_order_page.dart';
import 'package:waiterr/Pages/User/about_page.dart';
import 'package:waiterr/Pages/User/profile_page.dart';
import 'package:waiterr/stores/login_store.dart';
import 'package:waiterr/widgets/drawer.dart';
import 'package:waiterr/widgets/running_order_card.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../Model/model_option_model.dart';
import '../../Modules/universal_module.dart';
import '../../global_class.dart';
import '../../theme.dart';
import '../../widgets/option_modal_bottom_sheet.dart';
import 'kot_page.dart';
import 'add_order_page.dart';

class TableManagementPage extends StatefulWidget {
  const TableManagementPage({Key? key}) : super(key: key);
  @override
  State<TableManagementPage> createState() => _MyTableHomePage();
}

class _MyTableHomePage extends State<TableManagementPage> {
  //Variables
  List<RunningOrderModel>? items;
  Future<List<RunningOrderModel>>? _futureitems;
  bool? _isSearching, _isLoading, _isDataLoaded;
  String _searchText = "";
  double total = 0.0;
  int totalOrders = 0;
  List searchResult = [];
  Icon icon = const Icon(
    Icons.search,
  );
  //Controller
  final TextEditingController _searchController = TextEditingController();
  //Widgets
  Widget appBarTitle = const Text(
    "",
    style: TextStyle(fontSize: 24.0, height: 2.5),
  );

  //Member Functions
  _addTable() async {
    setState(() {
      _isLoading = true;
    });
    await Navigator.of(context)
        .push(CupertinoPageRoute<void>(
          title: "Add Order",
          builder: (context) => const AddOrder(
            isThroughQr: false,
          ),
        ))
        .then((value) => setState(() {
              _futureitems = fetchList();
            }));
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      icon = const Icon(
        Icons.search,
      );
      appBarTitle = const Text(
        "",
      );
      _isSearching = false;
      _searchController.clear();
    });
  }

  void searchOperation(String searchText) {
    searchResult.clear();
    if (_isSearching!) {
      searchResult = items!
          .where((RunningOrderModel element) =>
              (element.masterFilter!.toLowerCase()).contains(
                  searchText.toLowerCase().replaceAll(RegExp(r"\s+"), "")))
          .toList();
      setState(() {});
    }
  }

  _deleteUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'userData';
    prefs.remove(key);
    const key1 = 'userClientAllocationData';
    prefs.remove(key1);
  }

  Future<List<RunningOrderModel>> fetchList() async {
    List<RunningOrderModel> runningOrderList = [];
    await postForRunningOrders(false, true, "", "", "")
        .then((List<RunningOrderModel> rList) => {
              runningOrderList.addAll(rList.where(
                  (element) => element.name == UserDetail.userDetails.name)),
              runningOrderList.addAll(rList.where(
                  (element) => element.name != UserDetail.userDetails.name)),
              totalOrders = runningOrderList.length,
              total = 0,
              for (var element in rList) total = total + element.amount
            });
    setState(() {
      _isLoading = false;
      _isDataLoaded = true;
    });
    return runningOrderList;
  }

  //Overrides
  @override
  void initState() {
    super.initState();
    _isSearching = false;
    _isDataLoaded = false;
    _futureitems = fetchList();
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStore>(builder: (_, loginStore, __) {
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
                backgroundColor: Colors.transparent,
                centerTitle: true,
                title: appBarTitle,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                actions: <Widget>[
                  IconButton(
                      icon: icon,
                      onPressed: () {
                        setState(() {
                          if (icon.icon == Icons.search) {
                            icon = const Icon(Icons.close);
                            appBarTitle = TextFormField(
                              autofocus: true,
                              controller: _searchController,
                              style: const TextStyle(fontSize: 15),
                              decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: GlobalTheme.primaryText,
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  hintText: "Search...",
                                  hintStyle: TextStyle(fontSize: 15)),
                              onChanged: searchOperation,
                            );
                            _handleSearchStart();
                          } else {
                            _handleSearchEnd();
                          }
                        });
                      }),
                  PopupMenuButton<ModalOptionModel>(
                    itemBuilder: (BuildContext popupContext) {
                      return [
                        ModalOptionModel(
                            particulars: "Approvals",
                            icon: Icons.sort,
                            onTap: () {
                              Navigator.pop(popupContext);
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext alertDialogContext) {
                                    return OptionModalBottomSheet(
                                        appBarText: "Approvals",
                                        appBarIcon: Icons.sort,
                                        list: [
                                          ModalOptionModel(
                                            icon: Icons.approval,
                                            particulars: "Approve orders",
                                            onTap: () async {
                                              Navigator.pop(alertDialogContext);
                                              Connectivity connectivity =
                                                  Connectivity();
                                              await connectivity
                                                  .checkConnectivity()
                                                  .then((value) => {
                                                        if (value !=
                                                            ConnectivityResult
                                                                .none)
                                                          {
                                                            Navigator.of(context).push(PageRouteBuilder(
                                                                pageBuilder: (context,
                                                                        animation1,
                                                                        animation2) =>
                                                                    const ApproveOrdersPage(
                                                                        approvalType:
                                                                            "OrderApproved")))
                                                          }
                                                        else
                                                          {
                                                            Navigator.of(context).pushAndRemoveUntil(
                                                                PageRouteBuilder(
                                                                    pageBuilder: (context,
                                                                            animation1,
                                                                            animation2) =>
                                                                        const NoInternetPage()),
                                                                (route) =>
                                                                    false)
                                                          }
                                                      });
                                            },
                                          ),
                                          if (UserDetail.userDetails.roleID == 2 ||
                                              UserDetail.userDetails.roleID ==
                                                  3 ||
                                              UserDetail.userDetails.roleID ==
                                                  4)
                                            ModalOptionModel(
                                              icon: Icons.fastfood,
                                              particulars:
                                                  "Complete Order Preparation",
                                              onTap: () async {
                                                Navigator.pop(
                                                    alertDialogContext);
                                                Connectivity connectivity =
                                                    Connectivity();
                                                await connectivity
                                                    .checkConnectivity()
                                                    .then((value) => {
                                                          if (value !=
                                                              ConnectivityResult
                                                                  .none)
                                                            {
                                                              Navigator.of(context).push(PageRouteBuilder(
                                                                  pageBuilder: (context,
                                                                          animation1,
                                                                          animation2) =>
                                                                      const ApproveOrdersPage(
                                                                          approvalType:
                                                                              "OrderPrepared")))
                                                            }
                                                          else
                                                            {
                                                              Navigator.of(context).pushAndRemoveUntil(
                                                                  PageRouteBuilder(
                                                                      pageBuilder: (context,
                                                                              animation1,
                                                                              animation2) =>
                                                                          const NoInternetPage()),
                                                                  (route) =>
                                                                      false)
                                                            }
                                                        });
                                              },
                                            ),
                                          if (UserDetail.userDetails.roleID ==
                                                  3 ||
                                              UserDetail.userDetails.roleID ==
                                                  4)
                                            ModalOptionModel(
                                              icon: Icons.done_all,
                                              particulars: "Order delivered",
                                              onTap: () async {
                                                Navigator.pop(
                                                    alertDialogContext);
                                                Connectivity connectivity =
                                                    Connectivity();
                                                await connectivity
                                                    .checkConnectivity()
                                                    .then((value) => {
                                                          if (value !=
                                                              ConnectivityResult
                                                                  .none)
                                                            {
                                                              Navigator.of(context).push(
                                                                  PageRouteBuilder(
                                                                      pageBuilder: (context,
                                                                              animation1,
                                                                              animation2) =>
                                                                          const ApproveOrdersPage(
                                                                            approvalType:
                                                                                "OrderProcessed",
                                                                          )))
                                                            }
                                                          else
                                                            {
                                                              Navigator.of(context).pushAndRemoveUntil(
                                                                  PageRouteBuilder(
                                                                      pageBuilder: (context,
                                                                              animation1,
                                                                              animation2) =>
                                                                          const NoInternetPage()),
                                                                  (route) =>
                                                                      false)
                                                            }
                                                        });
                                              },
                                            ),
                                          if (UserDetail.userDetails.roleID ==
                                                  3 ||
                                              UserDetail.userDetails.roleID ==
                                                  4)
                                            ModalOptionModel(
                                              icon: Icons.done_all,
                                              particulars: "Order delivered",
                                              onTap: () async {
                                                Navigator.pop(
                                                    alertDialogContext);
                                                Connectivity connectivity =
                                                    Connectivity();
                                                await connectivity
                                                    .checkConnectivity()
                                                    .then((value) => {
                                                          if (value !=
                                                              ConnectivityResult
                                                                  .none)
                                                            {
                                                              Navigator.of(context).push(
                                                                  PageRouteBuilder(
                                                                      pageBuilder: (context,
                                                                              animation1,
                                                                              animation2) =>
                                                                          const ApproveOrdersPage(
                                                                            approvalType:
                                                                                "OrderProcessed",
                                                                          )))
                                                            }
                                                          else
                                                            {
                                                              Navigator.of(context).pushAndRemoveUntil(
                                                                  PageRouteBuilder(
                                                                      pageBuilder: (context,
                                                                              animation1,
                                                                              animation2) =>
                                                                          const NoInternetPage()),
                                                                  (route) =>
                                                                      false)
                                                            }
                                                        });
                                              },
                                            ),
                                          //TODO: to be implemented after wards
                                          // if (UserDetail.userDetails.roleID ==
                                          //     3||UserDetail.userDetails.roleID == 4)
                                          //   ModalOptionModel(
                                          //     icon: Icons.stop,
                                          //     particulars: "Terminate Order",
                                          //     onTap: () async {
                                          //       Navigator.pop(
                                          //           alertDialogContext);
                                          //       Connectivity connectivity =
                                          //           Connectivity();
                                          //       await connectivity
                                          //           .checkConnectivity()
                                          //           .then((value) => {
                                          //                 if (value !=
                                          //                     ConnectivityResult
                                          //                         .none)
                                          //                   {
                                          //                     Navigator.of(context).push(
                                          //                         PageRouteBuilder(
                                          //                             pageBuilder: (context,
                                          //                                     animation1,
                                          //                                     animation2) =>
                                          //                                 const ApproveOrdersPage(
                                          //                                   approvalType:
                                          //                                       "OrderTerminate",
                                          //                                 )))
                                          //                   }
                                          //                 else
                                          //                   {
                                          //                     Navigator.of(context).pushAndRemoveUntil(
                                          //                         PageRouteBuilder(
                                          //                             pageBuilder: (context,
                                          //                                     animation1,
                                          //                                     animation2) =>
                                          //                                 const NoInternetPage()),
                                          //                         (route) =>
                                          //                             false)
                                          //                   }
                                          //               });
                                          //     },
                                          //   ),
                                        ]);
                                  });
                            }),
                        if (UserDetail.userDetails.roleID == 3 ||
                            UserDetail.userDetails.roleID == 4)
                          ModalOptionModel(
                              particulars: "Waiter manager",
                              onTap: () async {
                                Navigator.pop(context);
                                Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                            const WaiterManagerPage()));
                              },
                              icon: Icons.person_outline),
                        if (UserDetail.userDetails.roleID == 3 ||
                            UserDetail.userDetails.roleID == 4)
                          ModalOptionModel(
                              particulars: "Menu manager",
                              onTap: () async {
                                Navigator.pop(context);
                                //Todo: navigate to waiter manager
                              },
                              icon: Icons.menu_book_outlined),
                        //role id 4 is for owner
                        if (UserDetail.userDetails.roleID == 4)
                          ModalOptionModel(
                              particulars: "Admin manager",
                              onTap: () async {
                                Navigator.pop(context);
                                //Todo: navigate to waiter manager
                              },
                              icon: Icons.admin_panel_settings_outlined),
                        ModalOptionModel(
                            particulars: "Refresh",
                            onTap: () async {
                              Navigator.pop(context);
                              Connectivity connectivity = Connectivity();
                              await connectivity
                                  .checkConnectivity()
                                  .then((value) => {
                                        if (value != ConnectivityResult.none)
                                          {
                                            setState(() {
                                              _isLoading = true;
                                              _isDataLoaded = false;
                                            }),
                                            _futureitems = fetchList()
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
                            },
                            icon: Icons.refresh)
                      ].map((ModalOptionModel choice) {
                        return PopupMenuItem<ModalOptionModel>(
                          value: choice,
                          child: ListTile(
                            title: Text(choice.particulars),
                            leading: Icon(choice.icon, color: choice.iconColor),
                            onTap: choice.onTap,
                          ),
                        );
                      }).toList();
                    },
                  ),
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
              backgroundColor: GlobalTheme.backgroundColor.withOpacity(0.7),
              body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        UserClientAllocationData.clientName!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.bold),
                      ),
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
                            child: FutureBuilder<List<RunningOrderModel>>(
                                future: _futureitems,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    items = snapshot.data;
                                    return ListView(
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      children: [
                                        Center(
                                          child: Container(
                                            height: _isLoading! ? 40 : 0,
                                            width: _isLoading! ? 40 : 0,
                                            padding: const EdgeInsets.all(10),
                                            child: _isLoading!
                                                ? const CircularProgressIndicator(
                                                    strokeWidth: 3,
                                                    backgroundColor: GlobalTheme
                                                        .progressBarBackground)
                                                : null,
                                          ),
                                        ),
                                        _searchController.text.isNotEmpty
                                            ? (searchResult.isNotEmpty
                                                ? ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount:
                                                        searchResult.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return GestureDetector(
                                                        child: RunningOrderCard(
                                                            item: searchResult[
                                                                index]),
                                                        onTap: () async {
                                                          setState(() {
                                                            _isLoading = true;
                                                          });
                                                          await Navigator.of(
                                                                  context)
                                                              .push(
                                                                  CupertinoPageRoute<
                                                                      void>(
                                                                title:
                                                                    "Kot Page",
                                                                builder: (context) => KOTPage(
                                                                    isWaiter:
                                                                        true,
                                                                    item: searchResult[
                                                                        index]),
                                                              ))
                                                              .then((value) =>
                                                                  setState(() {
                                                                    _futureitems =
                                                                        fetchList();
                                                                  }));
                                                        },
                                                      );
                                                    },
                                                  )
                                                : const NoDataError())
                                            : ListView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: items!.length,
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    child: RunningOrderCard(
                                                        item: items![index]),
                                                    onTap: () async {
                                                      setState(() {
                                                        _isLoading = true;
                                                      });
                                                      await Navigator.of(
                                                              context)
                                                          .push(
                                                              CupertinoPageRoute<
                                                                  void>(
                                                            title: "Kot Page",
                                                            builder: (context) =>
                                                                KOTPage(
                                                                    isWaiter:
                                                                        true,
                                                                    item: items![
                                                                        index]),
                                                          ))
                                                          .then((value) =>
                                                              setState(() {
                                                                _futureitems =
                                                                    fetchList();
                                                              }));
                                                    },
                                                  );
                                                },
                                              ),
                                      ],
                                    );
                                  } else if (snapshot.hasError) {
                                    if (snapshot.error.toString() ==
                                        "NoInternet") {
                                      return const ErrorPageNoInternet();
                                    } else if (snapshot.error.toString() ==
                                        "500") {
                                      return const ErrorPageFiveHundred();
                                    } else if (snapshot.error.toString() ==
                                        "NoData") {
                                      return const NoRunningOrders();
                                    } else if (snapshot.error.toString() ==
                                        "401") {
                                      return const ErrorPageFourHundredOne();
                                    } else {
                                      return const ErrorHasOccurred();
                                    }
                                  }
                                  // By default, show a loading spinner.
                                  return Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Expanded(
                                            child: Shimmer.fromColors(
                                                baseColor: Colors.grey[300]!,
                                                highlightColor:
                                                    Colors.grey[100]!,
                                                enabled: true,
                                                child: ListView.builder(
                                                  itemBuilder: (_, __) =>
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 8.0),
                                                          child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      7,
                                                                  height: 110.0,
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
                                                                        width: MediaQuery.of(context).size.width /
                                                                            1.5,
                                                                        height:
                                                                            10.0,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      const Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(vertical: 5.0),
                                                                      ),
                                                                      Container(
                                                                        width: MediaQuery.of(context).size.width /
                                                                            1.5,
                                                                        height:
                                                                            10.0,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      const Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(vertical: 5.0),
                                                                      ),
                                                                      Container(
                                                                        width: MediaQuery.of(context).size.width /
                                                                            1.5,
                                                                        height:
                                                                            10.0,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      const Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(vertical: 5.0),
                                                                      ),
                                                                      Container(
                                                                        width: MediaQuery.of(context).size.width /
                                                                            1.5,
                                                                        height:
                                                                            10.0,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      const Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(vertical: 2.0),
                                                                      ),
                                                                      Container(
                                                                        width:
                                                                            40.0,
                                                                        height:
                                                                            10.0,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              ])),
                                                  itemCount: 2,
                                                )),
                                          ),
                                        ],
                                      ));
                                }))),
                  ]),
              floatingActionButton: FloatingActionButton(
                onPressed: _addTable,
                child: const Icon(
                  Icons.add,
                  color: GlobalTheme.floatingButtonText,
                ),
              ),
              bottomNavigationBar: _isDataLoaded!
                  ? BottomAppBar(
                      color: Colors.black,
                      elevation: 0.5,
                      notchMargin: 5.0,
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ("Running Orders: ${totalOrders.toString().replaceAllMapped(UserDetail.commaRegex, UserDetail.matchFunc as String Function(Match))}"),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              ("₹ ${total.toStringAsFixed(2).replaceAllMapped(UserDetail.commaRegex, UserDetail.matchFunc as String Function(Match))}"),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    )
                  : null,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
            )
          ],
        ),
      );
    });
  }
}

// class RunningOrderCard extends StatelessWidget {
//   RunningOrderCard({Key key, this.item}) : super(key: key);
//   final RunningOrderModel item;
//   Widget build(BuildContext context) {
//     return Container(
//         padding: EdgeInsets.all(5),
//         child: Card(
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(5.0),
//           ),
//           child: Container(
//               width: MediaQuery.of(context).size.width/6.04,
//               decoration: BoxDecoration(
//                 borderRadius:
//                 const BorderRadius.all(
//                     Radius.circular(5)),
//                 gradient: LinearGradient(colors: GlobalTheme.primaryGradient,
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//               padding: EdgeInsets.only(left: 5),
//               child:Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     Container(
//                       alignment: Alignment.center,
//                       width:MediaQuery.of(context).size.width/7,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Text(this.item.SalePointType,textAlign:TextAlign.center, style: TextStyle(color: GlobalTheme.secondaryText,fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis,),
//                           Text(this.item.SalePointName,textAlign:TextAlign.center, style: TextStyle(color: GlobalTheme.secondaryText,fontSize: this.item.SalePointName.length>2?(this.item.SalePointName.length>3?(this.item.SalePointName.length>4?12:20):28):36),maxLines: 1,overflow: TextOverflow.ellipsis,),
//                           Text(this.item.OutletName,textAlign:TextAlign.center, style: TextStyle(color: GlobalTheme.secondaryText,fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis,)
//                         ],
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
//                       color: Colors.white,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment:MainAxisAlignment.start,
//                         children: <Widget>[
//                           SizedBox(height: 5),
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment:MainAxisAlignment.spaceBetween,
//                             mainAxisSize: MainAxisSize.max,
//                             children: <Widget>[
//                               Container(width:MediaQuery.of(context).size.width/1.5,child: Text((this.item.Name!=null)?this.item.Name:"",maxLines: 2,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 22,height:1),),),
//                               Container(width:MediaQuery.of(context).size.width/15,alignment:Alignment.topRight, child:this.item.BillPrinted?Icon(Icons.print,color: GlobalTheme.primaryColor):null),
//                             ],
//                           ),
//                           Container(width:MediaQuery.of(context).size.width/1.75, child: Text((this.item.MobileNo!=null)?this.item.MobileNo:"",maxLines: 2,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13,color: GlobalTheme.primaryText),),),
//                           Container(width:MediaQuery.of(context).size.width/1.75, child: Text("Waiter: "+this.item.WaiterName,maxLines: 2,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13,color: GlobalTheme.primaryText),),),
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: <Widget>[
//                               Column(
//                                 children: <Widget>[
//                                   Container(width:MediaQuery.of(context).size.width/2, child: Text("PAX: "+this.item.PAX.toString(),maxLines: 2,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13,color: GlobalTheme.primaryText),),),
//                                   Container(width:MediaQuery.of(context).size.width/2, child: Text("Active Since: "+this.item.ActiveSince,maxLines: 2,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13,color: GlobalTheme.primaryText),),)
//                                 ],
//                               ),
//                               Container(width:MediaQuery.of(context).size.width/4,alignment:Alignment.bottomRight,child:Text("₹"+this.item.Amount.toString(),maxLines: 2,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 20,height:1)),)
//                             ],
//                           ),
//                         ],
//                       ),
//                     )
//                   ]
//               ),
//           ),
//         )
//     );
//   }
// }