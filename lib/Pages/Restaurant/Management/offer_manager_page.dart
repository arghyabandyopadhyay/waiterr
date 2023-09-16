import 'package:waiterr/Modules/api_fetch_module.dart';
import 'package:waiterr/Pages/CautionPages/error_page.dart';
import 'package:waiterr/Pages/CautionPages/no_internet_page.dart';
import 'package:waiterr/Pages/Restaurant/Management/add_outlet_page.dart';
import 'package:waiterr/stores/login_store.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../Model/outlet_configuration_model.dart';
import '../../../theme.dart';

class OfferManagerPage extends StatefulWidget {
  const OfferManagerPage({Key? key}) : super(key: key);
  @override
  State<OfferManagerPage> createState() => _OfferManagerPageState();
}

class _OfferManagerPageState extends State<OfferManagerPage> {
  //Variables
  List<OutletConfigurationModel>? outlets;
  Future<List<OutletConfigurationModel>>? _futureoutlets;
  bool? _isSearching, _isLoading;
  // final String _searchText = "";
  List<OutletConfigurationModel> searchResult = [];
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
  _addOutlet() async {
    setState(() {
      _isLoading = true;
    });
    await Navigator.of(context)
        .push(CupertinoPageRoute<void>(
          title: "Add Outlet",
          builder: (context) => const AddOutletPage(
            isEdit: false,
          ),
        ))
        .then((value) => setState(() {
              _futureoutlets = fetchList();
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
      searchResult = outlets!
          .where((OutletConfigurationModel element) =>
              (element.outletName.toLowerCase()).contains(
                  searchText.toLowerCase().replaceAll(RegExp(r"\s+"), "")))
          .toList();
      setState(() {});
    }
  }

  Future<List<OutletConfigurationModel>> fetchList() async {
    List<OutletConfigurationModel> outlets = [];
    await postForOutlets().then(
        (List<OutletConfigurationModel> rList) => {outlets.addAll(rList)});
    setState(() {
      _isLoading = false;
    });
    return outlets;
  }

  //Overrides
  @override
  void initState() {
    super.initState();
    _isSearching = false;
    _futureoutlets = fetchList();
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStore>(builder: (_, loginStore, __) {
      return Scaffold(
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
                  IconButton(
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.black,
                    ),
                    onPressed: () async {
                      Connectivity connectivity = Connectivity();
                      await connectivity.checkConnectivity().then((value) => {
                            if (value != ConnectivityResult.none)
                              {
                                setState(() {
                                  _isLoading = true;
                                }),
                                _futureoutlets = fetchList()
                              }
                            else
                              {
                                Navigator.of(context).pushAndRemoveUntil(
                                    PageRouteBuilder(
                                        pageBuilder:
                                            (context, animation1, animation2) =>
                                                const NoInternetPage()),
                                    (route) => false)
                              }
                          });
                    },
                  )
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
                        "Outlets",
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
                            decoration: GlobalTheme.waiterrAppBarBoxDecoration,
                            child: FutureBuilder<
                                    List<OutletConfigurationModel>>(
                                future: _futureoutlets,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    outlets = snapshot.data;
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
                                                  )
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
                                                      return ListTile(
                                                        title: Text(
                                                            searchResult[index]
                                                                .outletName),
                                                        trailing:
                                                            ElevatedButton(
                                                          child: const Icon(Icons
                                                              .delete_outline),
                                                          onPressed: () async {
                                                            Connectivity
                                                                connectivity =
                                                                Connectivity();
                                                            await connectivity
                                                                .checkConnectivity()
                                                                .then(
                                                                    (value) => {
                                                                          if (value !=
                                                                              ConnectivityResult.none)
                                                                            {
                                                                              postForOutletModification("", "", searchResult[index].id, "Delete").then((value) => {
                                                                                    if (value == 200)
                                                                                      {
                                                                                        Navigator.pop(context)
                                                                                      }
                                                                                  })
                                                                            }
                                                                        });
                                                          },
                                                        ),
                                                        subtitle: Text(
                                                            searchResult[index]
                                                                    .outletSalePoint ??
                                                                ""),
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              CupertinoPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          AddOutletPage(
                                                                            outletDetail:
                                                                                searchResult[index],
                                                                            isEdit:
                                                                                true,
                                                                          )));
                                                        },
                                                      );
                                                    },
                                                  )
                                                : const NoDataError())
                                            : ListView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: outlets!.length,
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    title: Text(outlets![index]
                                                        .outletName),
                                                    trailing: ElevatedButton(
                                                      child: const Icon(
                                                          Icons.delete_outline),
                                                      onPressed: () async {
                                                        Connectivity
                                                            connectivity =
                                                            Connectivity();
                                                        await connectivity
                                                            .checkConnectivity()
                                                            .then((value) => {
                                                                  if (value !=
                                                                      ConnectivityResult
                                                                          .none)
                                                                    {
                                                                      postForOutletModification(
                                                                              "",
                                                                              "",
                                                                              outlets![index].id,
                                                                              "Delete")
                                                                          .then((value) => {
                                                                                if (value == 200)
                                                                                  {
                                                                                    Navigator.pop(context)
                                                                                  }
                                                                              })
                                                                    }
                                                                });
                                                      },
                                                    ),
                                                    subtitle: Text(outlets![
                                                                index]
                                                            .outletSalePoint ??
                                                        ""),
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          CupertinoPageRoute(
                                                              builder: (context) =>
                                                                  AddOutletPage(
                                                                    outletDetail:
                                                                        outlets![
                                                                            index],
                                                                    isEdit:
                                                                        true,
                                                                  )));
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
                                      return const NoDataError();
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
                                                                    children: <Widget>[
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
                onPressed: _addOutlet,
                child: const Icon(
                  Icons.add,
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
            )
          ],
        ),
      );
    });
  }
}
