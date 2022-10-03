import 'package:waiterr/global_class.dart';
import 'package:waiterr/Model/kot_model.dart';
import 'package:waiterr/Model/running_order_model.dart';
import 'package:waiterr/Modules/api_fetch_module.dart';
import 'package:waiterr/Modules/universal_module.dart';
import 'package:waiterr/Pages/CautionPages/error_page.dart';
import 'package:waiterr/Pages/Restaurant/menu_page_all.dart';
import 'package:waiterr/widgets/kot_details_widget.dart';
import 'package:waiterr/widgets/progress_status_indicator.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expandable_group/expandable_group_widget.dart';
import 'package:shimmer/shimmer.dart';
import '../../theme.dart';

class KOTPage extends StatefulWidget {
  const KOTPage({Key? key, this.item}) : super(key: key);
  final RunningOrderModel? item;

  @override
  State<KOTPage> createState() => _KOTPageState();
}

class _KOTPageState extends State<KOTPage> {
  List<List<KOTModel>>? kotList;
  Future<List<List<KOTModel>>>? _futureKot;
  bool? _dataIsLoaded;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  late bool _isLoading;
  Future<List<List<KOTModel>>> fetchList() async {
    List<List<KOTModel>> results = [];
    List<String?> distinctKotNumbers;
    await postForSalesPointHistory(widget.item!.outletName,
            widget.item!.salePointType, widget.item!.salePointName)
        .then((value) => {
              distinctKotNumbers = getDistinctKotNumber(value),
              for (String? kotNumber in distinctKotNumbers)
                {
                  results.add(value
                      .where((element) => element.kotNumber == kotNumber)
                      .toList())
                }
            });
    setState(() {
      _isLoading = false;
      _dataIsLoaded = true;
    });
    return results;
  }

  List<String?> getDistinctKotNumber(List<KOTModel> othersList) {
    List<String?> dist = [];
    for (var model in othersList) {
      if (dist == null) {
        dist.add(model.kotNumber);
      }
      if (!dist.contains(model.kotNumber)) {
        dist.add(model.kotNumber);
      }
    }
    return dist;
  }

  @override
  void initState() {
    super.initState();
    _futureKot = fetchList();
    _isLoading = false;
    _dataIsLoaded = false;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
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
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 20,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: <Widget>[
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
                                setState(() {
                                  _futureKot = fetchList();
                                })
                              }
                          });
                    },
                  )
                ],
              ),
              backgroundColor: GlobalTheme.backgroundColor.withOpacity(0.7),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      UserDetail.userDetails.roleID == 1
                          ? "Running Orders"
                          : "Table-${widget.item!.salePointName!}",
                      textScaleFactor: 1,
                      textAlign: TextAlign.left,
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
                          padding: const EdgeInsets.only(top: 5),
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
                          child: FutureBuilder<List<List<KOTModel>>>(
                              future: _futureKot,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  kotList = snapshot.data;
                                  return ListView(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0),
                                    children: [
                                      Center(
                                        child: Container(
                                          height: _isLoading ? 40 : 0,
                                          width: _isLoading ? 40 : 0,
                                          padding: const EdgeInsets.all(10),
                                          child: _isLoading
                                              ? const CircularProgressIndicator(
                                                  strokeWidth: 3,
                                                  backgroundColor: GlobalTheme
                                                      .progressBarBackground,
                                                )
                                              : null,
                                        ),
                                      ),
                                      Column(
                                        children: kotList!.map((group) {
                                          int index = kotList!.indexOf(group);
                                          return ExpandableGroup(
                                            isExpanded: index == 0,
                                            header: _header(
                                                'KOT ${kotList![index][0].kotNumber!}'),
                                            items: _buildItems(context, group),
                                            headerEdgeInsets:
                                                const EdgeInsets.only(
                                                    left: 16.0, right: 16.0),
                                          );
                                        }).toList(),
                                      )
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
                                return Container(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height,
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        width: 48.0,
                                                        height: 48.0,
                                                        color: Colors.white,
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
                                                              width: double
                                                                  .infinity,
                                                              height: 8.0,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            const Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          2.0),
                                                            ),
                                                            Container(
                                                              width: double
                                                                  .infinity,
                                                              height: 8.0,
                                                              color:
                                                                  Colors.white,
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
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                itemCount: 10,
                                              )),
                                        ),
                                      ],
                                    ));
                              }))),
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                backgroundColor: Colors.black,
                icon: const Icon(
                  Icons.restaurant_menu,
                  color: GlobalTheme.floatingButtonText,
                ),
                label: const Text(
                  "Menu",
                  style: TextStyle(
                    fontSize: 17,
                    color: GlobalTheme.floatingButtonText,
                  ),
                ),
                onPressed: () {
                  widget.item!.billPrinted!
                      ? globalShowInSnackBar("The Bill Has Been Printed!!",
                          null, scaffoldMessengerKey, null, null)
                      : Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => MenuPageAll(
                                    addOrderData: widget.item,
                                  )));
                },
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
            )
          ],
        ),
      ),
    );
  }

  Widget _header(String name) => Text(name,
      style: const TextStyle(
        fontSize: 15,
      ));

  List<ListTile> _buildItems(BuildContext context, List<KOTModel> items) {
    List<ListTile> a = [];
    a.add(ListTile(
      title: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(
                color: GlobalTheme.primaryText,
                width: 1,
                style: BorderStyle.solid),
            color: Colors.white,
          ),
          child: Column(
            children: <Widget>[
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, id) {
                  return Card(
                    elevation: 0,
                    child: KOTDetailsWidget(list: items[id]),
                  );
                },
              ),
              ProgressStatusIndicator(items.first)
            ],
          )),
    ));
    return a;
  }
}
