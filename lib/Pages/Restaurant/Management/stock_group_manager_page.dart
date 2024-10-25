import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waiterr/Modules/api_fetch_module.dart';
import 'package:waiterr/Pages/CautionPages/error_page.dart';
// import 'package:waiterr/Pages/CautionPages/no_internet_page.dart';
import 'package:waiterr/Pages/Restaurant/Management/add_stock_group_page.dart';
import 'package:waiterr/stores/login_store.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:waiterr/widgets/search_text_field.dart';
import '../../../Model/filter_item_model.dart';
import '../../../Model/outlet_configuration_model.dart';
import '../../../Modules/universal_module.dart';
import '../../../global_class.dart';
import '../../../theme.dart';
import '../../../widgets/confirmation_dialog.dart';
import '../../../widgets/expandable_group_list.dart';

class StockGroupManagerPage extends StatefulWidget {
  const StockGroupManagerPage({super.key});
  @override
  State<StockGroupManagerPage> createState() => _StockGroupManagerPageState();
}

class _StockGroupManagerPageState extends State<StockGroupManagerPage> {
  //Variables
  List<List<FilterItemModel>>? stockGroups;
  Future<List<List<FilterItemModel>>?>? _futurestockGroups;
  List<FilterItemModel>? stockGroupsSearch;
  bool? _isSearching, _isLoading;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  // final String _searchText = "";
  List<FilterItemModel> searchResult = [];
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
  _addWaiter() async {
    setState(() {
      _isLoading = true;
    });
    await Navigator.of(context)
        .push(CupertinoPageRoute<void>(
          title: "Add Stocks",
          builder: (context) => const AddStockGroupPage(
            isEdit: false,
          ),
        ))
        .then((value) => setState(() {
              _futurestockGroups = fetchList();
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
      searchResult = stockGroupsSearch!
          .where((FilterItemModel element) =>
              (element.masterFilter.toLowerCase()).contains(
                  searchText.toLowerCase().replaceAll(RegExp(r"\s+"), "")))
          .toList();
      setState(() {});
    }
  }

  Widget _header(String? name) => Text(
        "  $name",
        style: GoogleFonts.openSans(
            color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600),
      );
  List<ListTile> _buildItems(
      BuildContext context, List<FilterItemModel> items) {
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
                  return ListTile(
                    leading: (items[index].image != null &&
                            items[index].image != "")
                        ? Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(top: 5),
                            width: MediaQuery.of(context).size.width / 7,
                            child: CachedNetworkImage(
                              width: 40,
                              height: 40,
                              imageUrl: items[index].image!,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                    //colorFilter:ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => SizedBox(
                                  width: double.infinity,
                                  child: Center(
                                    child: Shimmer.fromColors(
                                      baseColor:
                                          Colors.grey[300]!.withOpacity(0.3),
                                      highlightColor: Colors.white,
                                      enabled: true,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                7,
                                        height: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ))
                        : const SizedBox(
                            height: 0,
                            width: 0,
                          ),
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => AddStockGroupPage(
                                    filterItem: items[index],
                                    isEdit: true,
                                  )));
                    },
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        Connectivity connectivity = Connectivity();
                        await connectivity.checkConnectivity().then((value) => {
                              if (value.isNotEmpty && context.mounted)
                                {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ConfirmationDialog(
                                          headerText: "Delete permanently?",
                                          question:
                                              "Are you sure, to delete ${items[index].stockGroup}?",
                                          onTapYes: () {
                                            postForMenuGroupItemModification(
                                                    "",
                                                    "",
                                                    items[index].id,
                                                    "",
                                                    "Delete")
                                                .then((value) => {
                                                      items.remove(items[index])
                                                    });
                                          },
                                          onTapNo: () {
                                            Navigator.pop(context);
                                          },
                                        );
                                      })
                                },
                            });
                      },
                    ),
                    title: Text(items[index].stockGroup ?? ""),
                  );
                },
              ),
            ],
          )),
    ));
    return a;
  }

  Future<List<List<FilterItemModel>>?> fetchList() async {
    List<List<FilterItemModel>>? results = [];
    List<FilterItemModel> temp;
    // FilterItemModel temp2;
    await postForMenuGroupItem(null).then((value) async => {
          stockGroupsSearch = value,
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

  //Overrides
  @override
  void initState() {
    super.initState();
    _isSearching = false;
    _futurestockGroups = fetchList();
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStore>(builder: (_, loginStore, __) {
      return ScaffoldMessenger(
          key: scaffoldMessengerKey,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Positioned(
                  child: Image.asset(
                    "assets/img/background.jpg",
                  ),
                ),
                Scaffold(
                  resizeToAvoidBottomInset:
                      GlobalTheme.internalScaffoldResizeToAvoidBottomInset,
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
                                appBarTitle = SearchTextField(
                                    searchController: _searchController,
                                    searchOperation: searchOperation);
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
                      //     await connectivity.checkConnectivity().then((value) => {
                      //           if (value.isNotEmpty)
                      //             {
                      //               setState(() {
                      //                 _isLoading = true;
                      //               }),
                      //               _futurestockGroups = fetchList()
                      //             }
                      //           else
                      //             {
                      //               Navigator.of(context).pushAndRemoveUntil(
                      //                   PageRouteBuilder(
                      //                       pageBuilder:
                      //                           (context, animation1, animation2) =>
                      //                               const NoInternetPage()),
                      //                   (route) => false)
                      //             }
                      //         });
                      //   },
                      // )
                    ],
                  ),
                  backgroundColor: GlobalTheme.tint,
                  body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            "Stock Groups",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GlobalTextStyles.waiterrTextStyleAppBar,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Flexible(
                            child: Container(
                                height: MediaQuery.of(context).size.height,
                                padding: const EdgeInsets.only(top: 10),
                                decoration:
                                    GlobalTheme.waiterrAppBarBoxDecoration,
                                child:
                                    FutureBuilder<List<List<FilterItemModel>>?>(
                                        future: _futurestockGroups,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            stockGroups = snapshot.data;
                                            return RefreshIndicator(
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
                                                                _futurestockGroups =
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
                                                  children: [
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
                                                                strokeWidth: 3,
                                                              )
                                                            : null,
                                                      ),
                                                    ),
                                                    _searchController
                                                            .text.isNotEmpty
                                                        ? (searchResult
                                                                .isNotEmpty
                                                            ? ListView.builder(
                                                                shrinkWrap:
                                                                    true,
                                                                physics:
                                                                    const NeverScrollableScrollPhysics(),
                                                                itemCount:
                                                                    searchResult
                                                                        .length,
                                                                itemBuilder:
                                                                    (BuildContext
                                                                            context,
                                                                        int index) {
                                                                  return ListTile(
                                                                    leading: (searchResult[index].image !=
                                                                                null &&
                                                                            searchResult[index].image !=
                                                                                "")
                                                                        ? Container(
                                                                            alignment:
                                                                                Alignment.centerLeft,
                                                                            margin: const EdgeInsets.only(top: 5),
                                                                            width: MediaQuery.of(context).size.width / 7,
                                                                            child: CachedNetworkImage(
                                                                              width: 40,
                                                                              height: 40,
                                                                              imageUrl: searchResult[index].image!,
                                                                              imageBuilder: (context, imageProvider) => Container(
                                                                                decoration: BoxDecoration(
                                                                                  image: DecorationImage(
                                                                                    image: imageProvider,
                                                                                    fit: BoxFit.cover,
                                                                                    //colorFilter:ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              placeholder: (context, url) => SizedBox(
                                                                                  width: double.infinity,
                                                                                  child: Center(
                                                                                    child: Shimmer.fromColors(
                                                                                      baseColor: Colors.grey[300]!.withOpacity(0.3),
                                                                                      highlightColor: Colors.white,
                                                                                      enabled: true,
                                                                                      child: Container(
                                                                                        width: MediaQuery.of(context).size.width / 7,
                                                                                        height: 40,
                                                                                        color: Colors.white,
                                                                                      ),
                                                                                    ),
                                                                                  )),
                                                                              errorWidget: (context, url, error) => const Icon(Icons.error),
                                                                            ))
                                                                        : const SizedBox(
                                                                            height:
                                                                                0,
                                                                            width:
                                                                                0,
                                                                          ),
                                                                    title: Text(
                                                                        searchResult[index].stockGroup ??
                                                                            ""),
                                                                    onTap: () {
                                                                      Navigator.push(
                                                                          context,
                                                                          CupertinoPageRoute(
                                                                              builder: (context) => AddStockGroupPage(
                                                                                    filterItem: searchResult[index],
                                                                                    isEdit: true,
                                                                                  )));
                                                                    },
                                                                    trailing:
                                                                        IconButton(
                                                                      icon:
                                                                          const Icon(
                                                                        Icons
                                                                            .delete,
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        Connectivity
                                                                            connectivity =
                                                                            Connectivity();
                                                                        await connectivity
                                                                            .checkConnectivity()
                                                                            .then((value) =>
                                                                                {
                                                                                  if (value.isNotEmpty && context.mounted)
                                                                                    {
                                                                                      showDialog(
                                                                                          context: context,
                                                                                          builder: (BuildContext context) {
                                                                                            return ConfirmationDialog(
                                                                                              headerText: "Delete permanently?",
                                                                                              question: "Are you sure, to delete ${searchResult[index].stockGroup}?",
                                                                                              onTapYes: () {
                                                                                                postForMenuGroupItemModification("", "", searchResult[index].id, "", "Delete").then((value) => {
                                                                                                      searchResult.remove(searchResult[index])
                                                                                                    });
                                                                                              },
                                                                                              onTapNo: () {
                                                                                                Navigator.pop(context);
                                                                                              },
                                                                                            );
                                                                                          })
                                                                                    }
                                                                                });
                                                                      },
                                                                    ),
                                                                  );
                                                                },
                                                              )
                                                            : const NoDataError())
                                                        : ListView(
                                                            physics:
                                                                const BouncingScrollPhysics(),
                                                            shrinkWrap: true,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0),
                                                            children: <Widget>[
                                                                ExpandableGroupList<
                                                                        FilterItemModel>(
                                                                    list:
                                                                        stockGroups,
                                                                    header:
                                                                        (value) {
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
                                                              ])
                                                  ],
                                                ));
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
                                          // By default, show a loading spinner.
                                          return Container(
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                                        child: ListView.builder(
                                                          itemBuilder: (_,
                                                                  __) =>
                                                              Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              8.0),
                                                                  child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              MediaQuery.of(context).size.width / 7,
                                                                          height:
                                                                              110.0,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        const Padding(
                                                                          padding:
                                                                              EdgeInsets.symmetric(horizontal: 8.0),
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: <Widget>[
                                                                              Container(
                                                                                width: MediaQuery.of(context).size.width / 1.5,
                                                                                height: 10.0,
                                                                                color: Colors.white,
                                                                              ),
                                                                              const Padding(
                                                                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                                                              ),
                                                                              Container(
                                                                                width: MediaQuery.of(context).size.width / 1.5,
                                                                                height: 10.0,
                                                                                color: Colors.white,
                                                                              ),
                                                                              const Padding(
                                                                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                                                              ),
                                                                              Container(
                                                                                width: MediaQuery.of(context).size.width / 1.5,
                                                                                height: 10.0,
                                                                                color: Colors.white,
                                                                              ),
                                                                              const Padding(
                                                                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                                                              ),
                                                                              Container(
                                                                                width: MediaQuery.of(context).size.width / 1.5,
                                                                                height: 10.0,
                                                                                color: Colors.white,
                                                                              ),
                                                                              const Padding(
                                                                                padding: EdgeInsets.symmetric(vertical: 2.0),
                                                                              ),
                                                                              Container(
                                                                                width: 40.0,
                                                                                height: 10.0,
                                                                                color: Colors.white,
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
                    onPressed: _addWaiter,
                    child: const Icon(
                      Icons.add,
                    ),
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.endFloat,
                )
              ],
            ),
          ));
    });
  }
}
