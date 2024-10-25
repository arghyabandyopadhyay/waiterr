import 'dart:async';

// import 'package:waiterr/Model/bottom_sheet_communication_template.dart';
// import 'package:waiterr/Model/customizable_page_model.dart';
import 'package:waiterr/Model/menu_item_model.dart';
import 'package:waiterr/Model/outlet_configuration_model.dart';
import 'package:waiterr/Modules/api_fetch_module.dart';
import 'package:waiterr/Pages/CautionPages/error_page.dart';
import 'package:waiterr/theme.dart';
// import 'package:waiterr/widgets/bottom_costumization_sheet.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../../../Modules/universal_module.dart';
import '../../../global_class.dart';
import '../../../widgets/menu_details_card.dart';
import '../../../widgets/menu_manager_list.dart';
import '../../../widgets/search_text_field.dart';
import 'add_menu_page.dart';

class MenuManagerPage extends StatefulWidget {
  // This widget is the root of your application.
  const MenuManagerPage({super.key});
  @override
  State<MenuManagerPage> createState() => _MenuManagerPageState();
}

class _MenuManagerPageState extends State<MenuManagerPage> {
  //Variables
  List<List<MenuItemModel>>? productList;
  Future<List<List<MenuItemModel>>?>? _futureproductList;
  List<MenuItemModel>? productListSearch;
  String dropdownValue = '0';
  double totalItems = 0;
  double totalCartAmount = 0;
  bool? _isSearching, _isLoading;
  List<MenuItemModel> searchResult = [];
  Icon icon = const Icon(
    Icons.search,
    color: Colors.black,
  );
  String menuText = "Menu";
  double globalBillingRate = 0;
  Icon appbarIcon = const Icon(
    Icons.arrow_back_ios,
    color: Colors.black,
  );
  //Key
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  //Controller
  final TextEditingController _searchController = TextEditingController();
  final _controller = ScrollController();
  final Widget menuTextWidget = Text(
    "Menu",
    textAlign: TextAlign.left,
    style: GlobalTextStyles.waiterrTextStyleAppBar,
  );

  late Widget appBarTitle;

  //Methods
  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  _addMenu() async {
    setState(() {
      _isLoading = true;
    });
    await Navigator.of(context)
        .push(CupertinoPageRoute<void>(
          title: "Add Menu",
          builder: (context) => const AddMenuPage(
            isEdit: false,
          ),
        ))
        .then((value) => setState(() {
              _futureproductList = fetchList();
            }));
  }

  // void _showModalBottomSheet(BuildContext context, MenuItemModel element) {
  //   int i = 0;
  //   List<CustomizablePageModel> custList = element.customizable;
  //   for (CustomizablePageModel custModel in custList) {
  //     if (custModel.qty != 0) {
  //       totalItems = totalItems - custModel.qty;
  //       totalCartAmount = totalCartAmount - custModel.price * custModel.qty;
  //     }
  //   }
  //   showModalBottomSheet<CustValTemp>(
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(20), topRight: Radius.circular(20)),
  //     ),
  //     context: context,
  //     builder: (context) {
  //       return BottomSheetContent(
  //         jsonData: custList,
  //         title: element.item,
  //         description: element.itemDescription ?? "",
  //       );
  //     },
  //   ).then((value) => {
  //         if (value != null)
  //           {
  //             setState(() {
  //               for (CustomizablePageModel a in element.customizable) {
  //                 a.qty = value.orderList[i++].qty;
  //               }
  //               i = 0;
  //               totalCartAmount = totalCartAmount + value.totalCartAmount!;
  //               totalItems = totalItems + value.totalItem;
  //               element.quantity = value.totalItem;
  //             })
  //           }
  //         else
  //           {
  //             setState(() {
  //               List<CustomizablePageModel> custList1 = element.customizable;
  //               for (CustomizablePageModel custModel in custList1) {
  //                 if (custModel.qty != 0) {
  //                   totalItems = totalItems + custModel.qty;
  //                   totalCartAmount =
  //                       totalCartAmount + custModel.price * custModel.qty;
  //                 }
  //               }
  //             }),
  //           },
  //       });
  // }

  void _handleSearchEnd() {
    setState(() {
      icon = const Icon(
        Icons.search,
        color: Colors.black,
      );
      appbarIcon = const Icon(
        Icons.arrow_back_ios,
        color: Colors.black,
      );
      appBarTitle = menuTextWidget;
      _isSearching = false;
      _searchController.clear();
    });
  }

  void searchOperation(String searchText) {
    searchResult.clear();
    if (_isSearching != null) {
      searchResult = productListSearch!
          .where((element) => (element.masterFilter.toLowerCase()).contains(
              searchText.toLowerCase().replaceAll(RegExp(r"\s+"), "")))
          .toList();
      setState(() {});
    }
  }

  Future<List<List<MenuItemModel>>?> fetchList() async {
    List<List<MenuItemModel>>? results = [];
    List<MenuItemModel> temp;
    // MenuItemModel temp2;
    await postForMenuItem("", null).then((value) async => {
          productListSearch = value,
          for (OutletConfigurationModel outlet
              in UserClientAllocationData.outletConfiguration ?? [])
            {
              temp = value
                  .where((element) => element.outletId == outlet.id)
                  .toList(),
              if (temp.isNotEmpty) results.add(temp)
            },
          setState(() {
            _isLoading = false;
          })
        });

    return results;
  }

  Widget _header(String? name) => Text(
        "  $name",
        style: GoogleFonts.openSans(
            color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600),
      );

  List<ListTile> _buildItems(BuildContext context, List<MenuItemModel> items) {
    List<ListTile> a = [];
    a.add(ListTile(
      title: Container(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: <Widget>[
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return MenuDetailsCard(
                      key: ObjectKey(items[index].itemID),
                      item: items[index],
                      onMiddleTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => AddMenuPage(
                                      menuItemModel: items[index],
                                      isEdit: true,
                                    )));
                      });
                },
              ),
            ],
          )),
    ));
    return a;
  }

  //Overrides
  @override
  void initState() {
    super.initState();
    _isSearching = false;
    _isLoading = true;
    appBarTitle = menuTextWidget;
    _futureproductList = fetchList();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            child: Image.asset(
              "assets/img/background.jpg",
            ),
          ),
          ScaffoldMessenger(
              key: scaffoldMessengerKey,
              child: Scaffold(
                  resizeToAvoidBottomInset:
                      GlobalTheme.internalScaffoldResizeToAvoidBottomInset,
                  key: _scaffoldKey,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    centerTitle: true,
                    title: appBarTitle,
                    leading: IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    actions: <Widget>[
                      IconButton(
                          icon: icon,
                          onPressed: () {
                            setState(() {
                              if (icon.icon == Icons.search) {
                                icon = const Icon(
                                  Icons.close,
                                  color: Colors.black,
                                );
                                appBarTitle = SearchTextField(
                                    searchController: _searchController,
                                    searchOperation: searchOperation);
                                appbarIcon = const Icon(
                                  Icons.search,
                                  color: Colors.black,
                                );
                                _handleSearchStart();
                              } else {
                                _handleSearchEnd();
                              }
                            });
                          }),
                      // IconButton(
                      //   icon: const Icon(
                      //     Icons.refresh,
                      //     color: Colors.black,
                      //   ),
                      //   onPressed: () async {
                      //     Connectivity connectivity = Connectivity();
                      //     await connectivity
                      //         .checkConnectivity()
                      //         .then((value) => {
                      //               if (value.isNotEmpty)
                      //                 {_futureproductList = fetchList()}
                      //             });
                      //   },
                      // )
                    ],
                    elevation: 0,
                  ),
                  backgroundColor: GlobalTheme.tint,
                  floatingActionButton: FloatingActionButton(
                    onPressed: _addMenu,
                    child: const Icon(
                      Icons.add,
                    ),
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.endFloat,
                  body: WillPopScope(
                      onWillPop: () {
                        Navigator.pop(context);
                        return Future(() => false);
                      },
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const SizedBox(
                              height: 10,
                            ),
                            Flexible(
                              child: Container(
                                  height: screenSize.height,
                                  padding: const EdgeInsets.only(top: 1.75),
                                  decoration:
                                      GlobalTheme.waiterrAppBarBoxDecoration,
                                  child: FutureBuilder<
                                          List<List<MenuItemModel>>?>(
                                      future: _futureproductList,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          productList = snapshot.data;
                                          return _searchController
                                                  .text.isNotEmpty
                                              ? (searchResult.isNotEmpty
                                                  ? RefreshIndicator(
                                                      backgroundColor:
                                                          Colors.black,
                                                      onRefresh: () async {
                                                        Connectivity
                                                            connectivity =
                                                            Connectivity();
                                                        await connectivity
                                                            .checkConnectivity()
                                                            .then((value) => {
                                                                  if (value.isNotEmpty)
                                                                    {
                                                                      setState(
                                                                          () {
                                                                        _isLoading =
                                                                            true;
                                                                      }),
                                                                      _futureproductList =
                                                                          fetchList()
                                                                    }
                                                                  else
                                                                    {
                                                                      globalShowInSnackBar(
                                                                          "No internet connection!!",
                                                                          null,
                                                                          scaffoldMessengerKey,
                                                                          null,
                                                                          null)
                                                                    }
                                                                });
                                                      },
                                                      child: ListView(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const AlwaysScrollableScrollPhysics(),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 15),
                                                        children: <Widget>[
                                                          Center(
                                                            child: Container(
                                                              height:
                                                                  _isLoading!
                                                                      ? 40
                                                                      : 0,
                                                              width: _isLoading!
                                                                  ? 40
                                                                  : 0,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              child: _isLoading!
                                                                  ? const CircularProgressIndicator(
                                                                      strokeWidth:
                                                                          3,
                                                                    )
                                                                  : null,
                                                            ),
                                                          ),
                                                          ListView.builder(
                                                            shrinkWrap: true,
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            itemCount:
                                                                searchResult
                                                                    .length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              return MenuDetailsCard(
                                                                  key: ObjectKey(
                                                                      searchResult[
                                                                              index]
                                                                          .itemID),
                                                                  item:
                                                                      searchResult[
                                                                          index],
                                                                  onMiddleTap:
                                                                      () {
                                                                    Navigator.push(
                                                                        context,
                                                                        CupertinoPageRoute(
                                                                            builder: (context) => AddMenuPage(
                                                                                  menuItemModel: searchResult[index],
                                                                                  isEdit: true,
                                                                                )));
                                                                  });
                                                            },
                                                          )
                                                        ],
                                                      ))
                                                  : const NoDataError())
                                              : RefreshIndicator(
                                                  backgroundColor: Colors.black,
                                                  onRefresh: () async {
                                                    Connectivity connectivity =
                                                        Connectivity();
                                                    await connectivity
                                                        .checkConnectivity()
                                                        .then((value) => {
                                                              if (value.isNotEmpty)
                                                                {
                                                                  setState(() {
                                                                    _isLoading =
                                                                        true;
                                                                  }),
                                                                  _futureproductList =
                                                                      fetchList()
                                                                }
                                                              else
                                                                {
                                                                  globalShowInSnackBar(
                                                                      "No internet connection!!",
                                                                      null,
                                                                      scaffoldMessengerKey,
                                                                      null,
                                                                      null)
                                                                }
                                                            });
                                                  },
                                                  child: ListView(
                                                      physics:
                                                          const AlwaysScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      controller: _controller,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      children: <Widget>[
                                                        Center(
                                                          child: Container(
                                                            height: _isLoading!
                                                                ? 40
                                                                : 0,
                                                            width: _isLoading!
                                                                ? 40
                                                                : 0,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: _isLoading!
                                                                ? const CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        3,
                                                                  )
                                                                : null,
                                                          ),
                                                        ),
                                                        MenuManagerList(
                                                            productList:
                                                                productList,
                                                            header: (value) {
                                                              return _header(
                                                                  value);
                                                            },
                                                            buildItems:
                                                                (context1,
                                                                    items) {
                                                              return _buildItems(
                                                                  context1,
                                                                  items);
                                                            }),
                                                      ]));
                                        } else if (snapshot.hasError) {
                                          if (snapshot.error.toString() ==
                                              "NoInternet") {
                                            return const ErrorPageNoInternet();
                                          } else if (snapshot.error
                                                  .toString() ==
                                              "500") {
                                            return const ErrorPageFiveHundred();
                                          } else if (snapshot.error
                                                  .toString() ==
                                              "NoData") {
                                            return const NoDataError();
                                          } else if (snapshot.error
                                                  .toString() ==
                                              "401") {
                                            return const ErrorPageFourHundredOne();
                                          } else {
                                            return const ErrorHasOccurred();
                                          }
                                        }
                                        return Container(
                                            width: double.infinity,
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
                                                                      const EdgeInsets.all(
                                                                          10),
                                                                  color: Colors
                                                                      .white,
                                                                  height: 20,
                                                                  width: 70),
                                                              Container(
                                                                  padding:
                                                                      const EdgeInsets.all(
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
                                                                    children: <Widget>[
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
                                                                        children: <Widget>[
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
                                                                      const EdgeInsets.all(
                                                                          10),
                                                                  color: Colors
                                                                      .white,
                                                                  height: 20,
                                                                  width: 70),
                                                              Container(
                                                                  padding:
                                                                      const EdgeInsets.all(
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
                                                                      children: <Widget>[
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
                                                                          children: <Widget>[
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
                                      })),
                            )
                          ]))))
        ],
      ),
    );
  }
}
