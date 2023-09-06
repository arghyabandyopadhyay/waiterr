import 'package:waiterr/global_class.dart';
import 'package:waiterr/Model/kot_model.dart';
import 'package:waiterr/Model/running_order_model.dart';
import 'package:waiterr/Modules/api_fetch_module.dart';
import 'package:waiterr/Modules/universal_module.dart';
import 'package:waiterr/Pages/CautionPages/error_page.dart';
import 'package:waiterr/Pages/Restaurant/menu_page_all.dart';
import 'package:waiterr/widgets/kot_details_widget.dart';
import 'package:waiterr/widgets/kot_progress_status_indicator.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../../widgets/expandable_group_widget.dart';
import 'package:shimmer/shimmer.dart';
import '../../theme.dart';
import '../../widgets/approval_control_kot.dart';
import '../../widgets/confirmation_dialog.dart';
import '../../widgets/loading_indicator.dart';

class ApproveOrdersPage extends StatefulWidget {
  final String approvalType;
  const ApproveOrdersPage({Key? key, required this.approvalType})
      : super(key: key);
  @override
  State<ApproveOrdersPage> createState() => _ApproveOrdersPageState();
}

class _ApproveOrdersPageState extends State<ApproveOrdersPage> {
  List<List<KOTModel>>? kotList;
  Future<List<List<KOTModel>>>? _futureKot;
  bool? _dataIsLoaded;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  late bool _isLoading;
  bool isLoading = false;
  Future<List<List<KOTModel>>> fetchList() async {
    List<List<KOTModel>> results = [];
    List<String?> distinctKotNumbers;
    await postForSalesPointHistory(null, null, null, widget.approvalType)
        .then((value) => {
              distinctKotNumbers = getDistinctKotNumber(value),
              for (String? kotNumber in distinctKotNumbers)
                {
                  results.add(value
                      .where((element) =>
                          ((element.runningOrderId ?? "") +
                              element.kotNumber.toString()) ==
                          kotNumber)
                      .toList())
                }
            });
    setState(() {
      _isLoading = false;
      isLoading = false;
      _dataIsLoaded = true;
    });
    return results;
  }

  List<String?> getDistinctKotNumber(List<KOTModel> othersList) {
    List<String?> dist = [];
    for (var model in othersList) {
      if (dist.isEmpty) {
        dist.add((model.runningOrderId ?? "") + model.kotNumber.toString());
      }
      if (!dist.contains(
          (model.runningOrderId ?? "") + model.kotNumber.toString())) {
        dist.add((model.runningOrderId ?? "") + model.kotNumber.toString());
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
    return LoadingIndicator(
        inAsyncCall: isLoading,
        child: ScaffoldMessenger(
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
                          await connectivity
                              .checkConnectivity()
                              .then((value) => {
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
                  backgroundColor: GlobalTheme.tint,
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          "Approvals",
                          textAlign: TextAlign.left,
                          style: TextStyle(
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
                              decoration:
                                  GlobalTheme.waiterrAppBarBoxDecoration,
                              child: FutureBuilder<List<List<KOTModel>>>(
                                  future: _futureKot,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      kotList = snapshot.data;
                                      if (kotList != null &&
                                          kotList!.isNotEmpty) {
                                        return ListView(
                                          shrinkWrap: true,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0),
                                          children: [
                                            Center(
                                              child: Container(
                                                height: _isLoading ? 40 : 0,
                                                width: _isLoading ? 40 : 0,
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: _isLoading
                                                    ? const CircularProgressIndicator(
                                                        strokeWidth: 3,
                                                      )
                                                    : null,
                                              ),
                                            ),
                                            Column(
                                              children: kotList!.map((group) {
                                                int index =
                                                    kotList!.indexOf(group);
                                                return ExpandableGroup(
                                                  isExpanded: index == 0,
                                                  header: _header(
                                                      'KOT ${kotList![index][0].kotNumber!}@${kotList![index][0].outletName}_${kotList![index][0].salePointName}'),
                                                  items: _buildItems(
                                                      context, group),
                                                  headerEdgeInsets:
                                                      const EdgeInsets.only(
                                                          left: 16.0,
                                                          right: 16.0),
                                                );
                                              }).toList(),
                                            )
                                          ],
                                        );
                                      } else {
                                        return const NoDataError();
                                      }
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
                                        height:
                                            MediaQuery.of(context).size.height,
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
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  width: double
                                                                      .infinity,
                                                                  height: 8.0,
                                                                  color: Colors
                                                                      .white,
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
                                                                  color: Colors
                                                                      .white,
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
                                                                  color: Colors
                                                                      .white,
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
                      Icons.checklist,
                    ),
                    label: const Text(
                      "Approve All",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    onPressed: () {
                      List<KOTModel> aggregrated = [];
                      for (List<KOTModel> kot in kotList!) {
                        aggregrated.addAll(kot);
                      }
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ConfirmationDialog(
                              headerText: "Approve Order",
                              question: "Are you sure, to approve the order?",
                              onTap_Yes: () {
                                {
                                  Navigator.pop(context);
                                  setState(() {
                                    isLoading = true;
                                  });
                                  _approveOrder(aggregrated, true, true, true)
                                      .then((value) => {
                                            if (value == 200)
                                              {
                                                setState(() {
                                                  _isLoading = true;
                                                }),
                                                setState(() {
                                                  _futureKot = fetchList();
                                                })
                                              }
                                            else if (value == 201)
                                              {
                                                setState(() {
                                                  isLoading = false;
                                                }),
                                                globalShowInSnackBar(
                                                    "The Bill has already been printed!! Add new order",
                                                    SnackBarAction(
                                                      label: "Undo",
                                                      onPressed: () {
                                                        Navigator.of(_scaffoldKey
                                                                .currentState!
                                                                .context)
                                                            .popUntil((route) =>
                                                                route.isFirst);
                                                      },
                                                    ),
                                                    scaffoldMessengerKey,
                                                    null,
                                                    null)
                                              }
                                            else if (value == 404)
                                              {
                                                setState(() {
                                                  isLoading = false;
                                                }),
                                                globalShowInSnackBar(
                                                    "No Internet Connection!!",
                                                    SnackBarAction(
                                                      label: "Undo",
                                                      onPressed: () {
                                                        Navigator.of(_scaffoldKey
                                                                .currentState!
                                                                .context)
                                                            .popUntil((route) =>
                                                                route.isFirst);
                                                      },
                                                    ),
                                                    scaffoldMessengerKey,
                                                    null,
                                                    null)
                                              }
                                            else
                                              {
                                                setState(() {
                                                  isLoading = false;
                                                }),
                                                globalShowInSnackBar(
                                                    "Something went wrong, please retry!!",
                                                    SnackBarAction(
                                                      label: "Undo",
                                                      onPressed: () {
                                                        Navigator.of(_scaffoldKey
                                                                .currentState!
                                                                .context)
                                                            .popUntil((route) =>
                                                                route.isFirst);
                                                      },
                                                    ),
                                                    scaffoldMessengerKey,
                                                    null,
                                                    null)
                                              }
                                          });
                                }
                              },
                              onTap_No: () {
                                Navigator.pop(context);
                              },
                            );
                          });
                    },
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.endFloat,
                )
              ],
            ),
          ),
        ));
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
                color: GlobalTheme.borderColor,
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
              KOTProgressStatusIndicator(items.first),
              const SizedBox(height: 10),
              ApprovalControlKOT(items.first, () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ConfirmationDialog(
                        headerText: "Approve Order",
                        question: "Are you sure, to approve the order?",
                        onTap_Yes: () {
                          {
                            Navigator.pop(context);
                            setState(() {
                              isLoading = true;
                            });
                            bool allProcessed = kotList!
                                    .where((element) =>
                                        element.first.runningOrderId ==
                                        items.first.runningOrderId)
                                    .length ==
                                1;
                            _approveOrder(items, false, true, allProcessed)
                                .then((value) => {
                                      if (value == 200)
                                        {
                                          setState(() {
                                            _isLoading = true;
                                          }),
                                          setState(() {
                                            _futureKot = fetchList();
                                          })
                                        }
                                      else if (value == 201)
                                        {
                                          setState(() {
                                            isLoading = false;
                                          }),
                                          globalShowInSnackBar(
                                              "The Bill has already been printed!! Add new order",
                                              SnackBarAction(
                                                label: "Undo",
                                                onPressed: () {
                                                  Navigator.of(_scaffoldKey
                                                          .currentState!
                                                          .context)
                                                      .popUntil((route) =>
                                                          route.isFirst);
                                                },
                                              ),
                                              scaffoldMessengerKey,
                                              null,
                                              null)
                                        }
                                      else if (value == 404)
                                        {
                                          setState(() {
                                            isLoading = false;
                                          }),
                                          globalShowInSnackBar(
                                              "No Internet Connection!!",
                                              SnackBarAction(
                                                label: "Undo",
                                                onPressed: () {
                                                  Navigator.of(_scaffoldKey
                                                          .currentState!
                                                          .context)
                                                      .popUntil((route) =>
                                                          route.isFirst);
                                                },
                                              ),
                                              scaffoldMessengerKey,
                                              null,
                                              null)
                                        }
                                      else
                                        {
                                          setState(() {
                                            isLoading = false;
                                          }),
                                          globalShowInSnackBar(
                                              "Something went wrong, please retry!!",
                                              SnackBarAction(
                                                label: "Undo",
                                                onPressed: () {
                                                  Navigator.of(_scaffoldKey
                                                          .currentState!
                                                          .context)
                                                      .popUntil((route) =>
                                                          route.isFirst);
                                                },
                                              ),
                                              scaffoldMessengerKey,
                                              null,
                                              null)
                                        }
                                    });
                          }
                        },
                        onTap_No: () {
                          Navigator.pop(context);
                        },
                      );
                    });
              }, () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ConfirmationDialog(
                        headerText: "Disapprove Order",
                        question: "Are you sure, to disapprove the order?",
                        onTap_Yes: () {
                          {
                            Navigator.pop(context);
                            setState(() {
                              isLoading = true;
                            });
                            _approveOrder(items, false, false, false)
                                .then((value) => {
                                      if (value == 200)
                                        {
                                          setState(() {
                                            isLoading = false;
                                          }),
                                          Navigator.of(_scaffoldKey
                                                  .currentState!.context)
                                              .popUntil(
                                                  (route) => route.isFirst),
                                        }
                                      else if (value == 201)
                                        {
                                          setState(() {
                                            isLoading = false;
                                          }),
                                          globalShowInSnackBar(
                                              "The Bill has already been printed!! Add new order",
                                              SnackBarAction(
                                                label: "Undo",
                                                onPressed: () {
                                                  Navigator.of(_scaffoldKey
                                                          .currentState!
                                                          .context)
                                                      .popUntil((route) =>
                                                          route.isFirst);
                                                },
                                              ),
                                              scaffoldMessengerKey,
                                              null,
                                              null)
                                        }
                                      else if (value == 404)
                                        {
                                          setState(() {
                                            isLoading = false;
                                          }),
                                          globalShowInSnackBar(
                                              "No Internet Connection!!",
                                              SnackBarAction(
                                                label: "Undo",
                                                onPressed: () {
                                                  Navigator.of(_scaffoldKey
                                                          .currentState!
                                                          .context)
                                                      .popUntil((route) =>
                                                          route.isFirst);
                                                },
                                              ),
                                              scaffoldMessengerKey,
                                              null,
                                              null)
                                        }
                                      else
                                        {
                                          setState(() {
                                            isLoading = false;
                                          }),
                                          globalShowInSnackBar(
                                              "Something went wrong, please retry!!",
                                              SnackBarAction(
                                                label: "Undo",
                                                onPressed: () {
                                                  Navigator.of(_scaffoldKey
                                                          .currentState!
                                                          .context)
                                                      .popUntil((route) =>
                                                          route.isFirst);
                                                },
                                              ),
                                              scaffoldMessengerKey,
                                              null,
                                              null)
                                        }
                                    });
                          }
                        },
                        onTap_No: () {
                          Navigator.pop(context);
                        },
                      );
                    });
              })
            ],
          )),
    ));
    return a;
  }

  Future<int?> _approveOrder(List<KOTModel> kotList, bool forAggregate,
      bool forApproval, bool allProcessed) async {
    int? status;
    try {
      await postForOrderApproval(
              kotList.first.runningOrderId ?? "",
              kotList.first.kotNumber ?? "",
              forAggregate,
              forApproval,
              widget.approvalType,
              allProcessed)
          .then((value) => {status = value});

      return status;
    } catch (E) {
      return 404;
    }
  }
}
