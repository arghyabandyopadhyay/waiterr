import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:waiterr/Model/bottom_sheet_communication_template.dart';
import 'package:waiterr/Model/comment_for_kot_suggestion_model.dart';
import 'package:waiterr/Model/customizable_page_model.dart';
import 'package:waiterr/Model/filter_item_model.dart';
import 'package:waiterr/Model/menu_item_model.dart';
import 'package:waiterr/Modules/api_fetch_module.dart';
import 'package:waiterr/Modules/universal_module.dart';
import 'package:waiterr/Pages/CautionPages/error_page.dart';
import 'package:waiterr/Pages/Restaurant/cart_page.dart';
import 'package:waiterr/Pages/Restaurant/product_page.dart';
import 'package:waiterr/theme.dart';
import 'package:waiterr/widgets/add_comment_for_kot_dialog.dart';
import 'package:waiterr/widgets/add_quantity_dialog.dart';
import 'package:waiterr/widgets/bottom_costumization_sheet.dart';
import 'package:waiterr/widgets/menu_all_list.dart';
import 'package:waiterr/widgets/non_favourite_card.dart';
import 'package:waiterr/widgets/selection_cart_responsive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../widgets/expandable_group_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:waiterr/Model/running_order_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../../global_class.dart';
import '../../widgets/search_text_field.dart';

class MenuPageAll extends StatefulWidget {
  final RunningOrderModel addOrderData;
  final bool isWaiter;
  // This widget is the root of your application.
  const MenuPageAll(
      {Key? key, required this.addOrderData, required this.isWaiter})
      : super(key: key);
  @override
  State<MenuPageAll> createState() => _MenuPageAllState();
}

class _MenuPageAllState extends State<MenuPageAll> {
  //Variables
  List<List<MenuItemModel>>? productList;
  int activeFilter = 0;
  Future<List<List<MenuItemModel>>?>? _futureproductList;
  List<FilterItemModel>? distinctStockGroup;
  List<MenuItemModel>? productListSearch;
  late List<MenuItemModel> filterList;
  List<MenuItemModel> favourites = [];
  String dropdownValue = '0';
  double totalItems = 0;
  double totalCartAmount = 0;
  bool? _isSearching, _dataIsLoaded, _isFilterOn;
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
  final GlobalKey<_ViewCartButtonState> _globalKey =
      GlobalKey<_ViewCartButtonState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  //Controller
  final TextEditingController _searchController = TextEditingController();
  final _controller = ScrollController();
  Widget appBarTitle = const Text(
    "Menu",
    textAlign: TextAlign.left,
    style: TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
        color: GlobalTheme.waiterrSecondaryText),
  );

  //Methods
  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _showModalBottomSheet(BuildContext context, MenuItemModel element) {
    int i = 0;
    List<CustomizablePageModel> custList = element.customizable;
    for (CustomizablePageModel custModel in custList) {
      if (custModel.qty != 0) {
        totalItems = totalItems - custModel.qty;
        totalCartAmount = totalCartAmount - custModel.price * custModel.qty;
      }
    }
    showModalBottomSheet<CustValTemp>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return BottomSheetContent(
          jsonData: custList,
          title: element.item,
          description: element.itemDescription ?? "",
        );
      },
    ).then((value) => {
          if (value != null)
            {
              setState(() {
                for (CustomizablePageModel a in element.customizable) {
                  a.qty = value.orderList[i++].qty;
                }
                i = 0;
                totalCartAmount = totalCartAmount + value.totalCartAmount!;
                totalItems = totalItems + value.totalItem;
                element.quantity = value.totalItem;
              })
            }
          else
            {
              setState(() {
                List<CustomizablePageModel> custList1 = element.customizable;
                for (CustomizablePageModel custModel in custList1) {
                  if (custModel.qty != 0) {
                    totalItems = totalItems + custModel.qty;
                    totalCartAmount =
                        totalCartAmount + custModel.price * custModel.qty;
                  }
                }
              }),
            },
        });
  }

  Future<void> _showProductPage(
      BuildContext context, MenuItemModel element) async {
    if (element.quantity != 0) {
      totalItems = totalItems - element.quantity;
      totalCartAmount = totalCartAmount - element.rate * element.quantity;
    }
    await Navigator.push(context,
        CupertinoPageRoute(builder: (context1) => ProductPage(item: element)));
    setState(() {
      totalCartAmount = totalCartAmount + element.rate * element.quantity;
      totalItems = totalItems + element.quantity;
    });
  }

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
      appBarTitle = const Text(
        "Menu",
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
      );
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
    MenuItemModel previousTotalValue;
    List<List<MenuItemModel>>? results = [];
    List<MenuItemModel> temp;
    MenuItemModel temp2;
    if (!widget.isWaiter) {
      await postForMenuItem(
              widget.addOrderData.userId ?? "", widget.addOrderData.outletId)
          .then((value) async => {
                if (PreviousCartManager.previousSalePointName ==
                        widget.addOrderData.salePointName &&
                    PreviousCartManager.previousOutletName ==
                        widget.addOrderData.outletName &&
                    PreviousCartManager.previousSalePointType ==
                        widget.addOrderData.salePointType &&
                    PreviousCartManager.runningCart.isNotEmpty)
                  {
                    setState(() {
                      previousTotalValue =
                          PreviousCartManager.runningCart.removeLast();
                      totalItems = previousTotalValue.quantity;
                      totalCartAmount = previousTotalValue.rate;
                    }),
                    for (MenuItemModel m in PreviousCartManager.runningCart)
                      {
                        temp2 = value
                            .where((element) => element.itemID == m.itemID)
                            .toList()[0],
                        temp2.quantity = m.quantity,
                        temp2.commentForKOT = m.commentForKOT
                      },
                    PreviousCartManager.runningCart.clear(),
                    PreviousCartManager.previousSalePointName = "",
                    PreviousCartManager.previousSalePointType = "",
                    PreviousCartManager.previousOutletName = ""
                  },
                productListSearch = value,
                distinctStockGroup =
                    await postForMenuGroupItem(widget.addOrderData.outletId),
                for (FilterItemModel stockGroup in distinctStockGroup!)
                  {
                    temp = value
                        .where((element) =>
                            element.stockGroup == stockGroup.stockGroup)
                        .toList(),
                    if (temp.isNotEmpty) results!.add(temp)
                  },
                favourites = productListSearch!
                    .where((element) => element.favourite)
                    .toList(),
                distinctStockGroup!.insert(
                    0,
                    FilterItemModel(
                        id: "",
                        outletId: "",
                        outletName: "",
                        image:
                            "https://firebasestorage.googleapis.com/v0/b/wiaterr-3fff2.appspot.com/o/StockGroupPictures%2Fall.png?alt=media&token=a1b58368-0fc4-459a-bfc1-19d8fb818152",
                        stockGroup: "All",
                        masterFilter: "All")),
                if (favourites.isNotEmpty)
                  distinctStockGroup!.insert(
                      1,
                      FilterItemModel(
                          id: "",
                          outletId: "",
                          outletName: "",
                          image:
                              "https://firebasestorage.googleapis.com/v0/b/wiaterr-3fff2.appspot.com/o/StockGroupPictures%2Fpreviousorder.png?alt=media&token=72d918d1-0d62-4b8e-aee4-451108acae0a",
                          stockGroup: "Previous Orders",
                          masterFilter: "previousorders")),
                setState(() {
                  _dataIsLoaded = true;
                })
              });
    } else {
      UserClientAllocationData.distinctStockGroup ??=
          await postForMenuGroupItem(widget.addOrderData.outletId);
      UserClientAllocationData.productList ??= await postForMenuItem(
          widget.addOrderData.userId ?? "", widget.addOrderData.outletId);
      if (PreviousCartManager.previousSalePointName ==
              widget.addOrderData.salePointName &&
          PreviousCartManager.previousOutletName ==
              widget.addOrderData.outletName &&
          PreviousCartManager.previousSalePointType ==
              widget.addOrderData.salePointType &&
          PreviousCartManager.runningCart.isNotEmpty) {
        previousTotalValue = PreviousCartManager.runningCart.removeLast();
        totalItems = previousTotalValue.quantity;
        totalCartAmount = previousTotalValue.rate;
        PreviousCartManager.runningCart.clear();
        PreviousCartManager.previousSalePointName = "";
        PreviousCartManager.previousSalePointType = "";
        PreviousCartManager.previousOutletName = "";
      } else {
        for (var element in UserClientAllocationData.productList!) {
          element.quantity = 0;
          element.commentForKOT = "";
        }
      }
      favourites = UserClientAllocationData.productList!
          .where((element) => element.favourite)
          .toList();
      productListSearch = UserClientAllocationData.productList;
      distinctStockGroup = UserClientAllocationData.distinctStockGroup;
      if (UserClientAllocationData.productListStockDiff == null) {
        for (FilterItemModel stockGroup in distinctStockGroup!) {
          temp = UserClientAllocationData.productList!
              .where((element) => element.stockGroup == stockGroup.stockGroup)
              .toList();
          if (temp.isNotEmpty) results.add(temp);
        }
        UserClientAllocationData.productListStockDiff = results;
      } else {
        results = UserClientAllocationData.productListStockDiff;
      }
      // favourites =
      //     productListSearch!.where((element) => element.favourite).toList();
      if (distinctStockGroup![0].stockGroup != "All") {
        distinctStockGroup!.insert(
            0,
            FilterItemModel(
                id: "",
                outletId: "",
                outletName: "",
                image:
                    "https://firebasestorage.googleapis.com/v0/b/wiaterr-3fff2.appspot.com/o/StockGroupPictures%2Fall.png?alt=media&token=a1b58368-0fc4-459a-bfc1-19d8fb818152",
                stockGroup: "All",
                masterFilter: "All"));
      }
      if (favourites.isNotEmpty &&
          distinctStockGroup![1].stockGroup != "Previous Orders") {
        distinctStockGroup!.insert(
            1,
            FilterItemModel(
                id: "",
                outletId: "",
                outletName: "",
                image:
                    "https://firebasestorage.googleapis.com/v0/b/wiaterr-3fff2.appspot.com/o/StockGroupPictures%2Fpreviousorder.png?alt=media&token=72d918d1-0d62-4b8e-aee4-451108acae0a",
                stockGroup: "Previous Orders",
                masterFilter: "previousorders"));
      } else if (favourites.isEmpty &&
          distinctStockGroup![1].stockGroup == "Previous Orders") {
        distinctStockGroup!.removeAt(1);
      }
      setState(() {
        _dataIsLoaded = true;
      });
    }

    return results;
  }

  Widget _header(String? name) => Text(
        "  $name",
        style: GoogleFonts.openSans(
            color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600),
      );

  void onTapAdd(MenuItemModel itemModel) {
    setState(() {
      if (itemModel.customizable.isEmpty) {
        totalItems = totalItems + 1;
        totalCartAmount = totalCartAmount + itemModel.rate;
        itemModel.quantity = itemModel.quantity + 1;
      } else {
        _showModalBottomSheet(context, itemModel);
      }
    });
  }

  void onTapRemove(MenuItemModel itemModel) {
    setState(() {
      if (itemModel.customizable.isEmpty) {
        if (itemModel.quantity - 1 >= 0) {
          totalItems = itemModel.quantity == 0.0 ? totalItems : totalItems - 1;
          totalCartAmount = itemModel.quantity == 0.0
              ? totalCartAmount
              : totalCartAmount - itemModel.rate;
          itemModel.quantity =
              itemModel.quantity == 0.0 ? 0.0 : itemModel.quantity - 1;
        } else {
          totalItems = itemModel.quantity == 0.0
              ? totalItems
              : totalItems - itemModel.quantity;
          totalCartAmount = itemModel.quantity == 0.0
              ? totalCartAmount
              : totalCartAmount - itemModel.rate * itemModel.quantity;
          itemModel.quantity = 0.0;
        }
      } else {
        _showModalBottomSheet(context, itemModel);
      }
    });
  }

  void onDoubleTap(MenuItemModel itemModel) {
    if (itemModel.quantity != 0) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            CommentForKotSuggestionsModel commentForKOT =
                CommentForKotSuggestionsModel();
            return AddCommentForKOTDialog(
              itemId: itemModel.itemID,
              previousValue: CommentForKotSuggestionsModel(
                  commentForKOT: itemModel.commentForKOT,
                  menuItemId: itemModel.itemID),
              setCommentForKOT: (value) {
                commentForKOT = value;
              },
              onTapAdd: () {
                setState(() {
                  itemModel.commentForKOT = commentForKOT.commentForKOT;
                  itemModel.commentForKOTId = commentForKOT.id;
                  Navigator.pop(context);
                });
              },
            );
          });
    } else {
      globalShowInSnackBar("Can't Add Remarks in the Items not added to cart.",
          null, scaffoldMessengerKey, null, null);
    }
  }

  void onLongPressedRemove(MenuItemModel itemModel) {
    setState(() {
      if (itemModel.customizable.isEmpty) {
        totalItems = itemModel.quantity == 0.0
            ? totalItems
            : totalItems - itemModel.quantity;
        totalCartAmount = itemModel.quantity == 0.0
            ? totalCartAmount
            : totalCartAmount - itemModel.rate * itemModel.quantity;
        itemModel.quantity = 0.0;
      } else {
        _showModalBottomSheet(context, itemModel);
      }
    });
  }

  void onLongPressedAdd(MenuItemModel itemModel) {
    itemModel.customizable.isEmpty
        ? showDialog(
            context: context,
            builder: (BuildContext context) {
              double quantity = 0;
              return AddQuantityDialog(
                setQuantity: (double value) {
                  quantity = value;
                },
                previousValue: itemModel.quantity,
                onTapAdd: () {
                  setState(() {
                    totalItems = totalItems + quantity - itemModel.quantity;
                    double info = itemModel.rate;
                    totalCartAmount = totalCartAmount +
                        info * (quantity - itemModel.quantity);
                    itemModel.quantity = quantity;
                  });
                  Navigator.pop(context);
                },
              );
            })
        : _showModalBottomSheet(context, itemModel);
  }

  List<MenuItemModel> getOrderList() {
    List<MenuItemModel> orderList = [];
    try {
      orderList = productListSearch!
          .where((element) => element.quantity > 0.0)
          .toList();
      orderList.add(MenuItemModel(
          stockGroupId: "",
          stockGroup: "",
          favourite: false,
          item: "Total",
          itemDescription: null,
          itemID: "",
          customizable: [],
          rate: totalCartAmount,
          quantity: totalItems,
          discount: 0,
          isEdited: false,
          taxClassID: "",
          taxRate: 0,
          masterFilter: "",
          isVeg: true,
          rateBeforeDiscount: 0,
          isDiscountable: false));
    } catch (E) {
      orderList.add(MenuItemModel(
          stockGroupId: "",
          stockGroup: "",
          favourite: false,
          item: "Total",
          itemID: "",
          customizable: [],
          itemDescription: null,
          rate: totalCartAmount,
          quantity: totalItems,
          discount: 0,
          isEdited: false,
          taxClassID: "",
          taxRate: 0,
          isVeg: true,
          rateBeforeDiscount: 0,
          masterFilter: "",
          isDiscountable: false));
    }
    return orderList;
  }

  setPreviousCartManager() {
    List<MenuItemModel> orderList = getOrderList();
    if (orderList.isNotEmpty) PreviousCartManager.runningCart = orderList;
    PreviousCartManager.previousSalePointName =
        widget.addOrderData.salePointName ?? "";
    PreviousCartManager.previousSalePointType =
        widget.addOrderData.salePointType ?? "";
    PreviousCartManager.previousOutletName =
        widget.addOrderData.outletName ?? "";
  }

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
                  return NonFavouritesCard(
                    key: ObjectKey(items[index].itemID),
                    item: items[index],
                    onMiddleTap: () {
                      _showProductPage(context, items[index]);
                    },
                    onTapAdd: () {
                      onTapAdd(items[index]);
                    },
                    onTapRemove: () {
                      onTapRemove(items[index]);
                    },
                    onLongPressedRemove: () {
                      onLongPressedRemove(items[index]);
                    },
                    onLongPressedAdd: () {
                      onLongPressedAdd(items[index]);
                    },
                    onDoubleTap: () {
                      onDoubleTap(items[index]);
                    },
                  );
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
    _dataIsLoaded = false;
    _isFilterOn = false;
    if (widget.addOrderData.outletId != UserClientAllocationData.lastOutletId) {
      UserClientAllocationData.clearMenuData();
    }
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
                  key: _scaffoldKey,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    centerTitle: true,
                    title: appBarTitle,
                    leading: IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: appbarIcon,
                      onPressed: () => _isSearching!
                          ? null
                          : {
                              setPreviousCartManager(),
                              Navigator.of(context).pop()
                            },
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
                      IconButton(
                        icon: _dataIsLoaded!
                            ? const Icon(Icons.remove_shopping_cart)
                            : const Icon(
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
                                        Navigator.pushReplacement(
                                            context,
                                            PageRouteBuilder(
                                                pageBuilder: (context,
                                                        animation1,
                                                        animation2) =>
                                                    MenuPageAll(
                                                      addOrderData:
                                                          widget.addOrderData,
                                                      isWaiter: widget.isWaiter,
                                                    )))
                                      }
                                  });
                        },
                      )
                    ],
                    elevation: 0,
                  ),
                  backgroundColor: GlobalTheme.tint,
                  resizeToAvoidBottomInset: true,
                  bottomNavigationBar: BottomAppBar(
                      elevation: 0,
                      color: Colors.white,
                      child: ViewCartButton(
                        key: _globalKey,
                        onPressed: () async {
                          List<MenuItemModel> orderList = getOrderList();
                          String? value = await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context1) => FoodOrderPage(
                                      orderList,
                                      widget.addOrderData,
                                      widget.isWaiter)));
                          if (value != null) {
                            var tmp = value.split("|");
                            totalItems = double.parse(tmp[0]);
                            totalCartAmount = double.parse(tmp[1]);
                            setState(() {});
                          }
                        },
                        totalCartAmount: totalCartAmount,
                        totalItems: totalItems,
                      )),
                  body: WillPopScope(
                      onWillPop: () {
                        setPreviousCartManager();
                        Navigator.pop(context);
                        return Future(() => false);
                      },
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            _isSearching!
                                ? Container()
                                : (_dataIsLoaded!
                                    ? SizedBox(
                                        height: 102,
                                        child: ListView.builder(
                                          itemCount: distinctStockGroup!.length,
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return SelectionCardResponsive(
                                                item:
                                                    distinctStockGroup![index],
                                                active: index == activeFilter
                                                    ? true
                                                    : false,
                                                onTap: () {
                                                  if (distinctStockGroup![index]
                                                          .stockGroup ==
                                                      "All") {
                                                    if (_isFilterOn!) {
                                                      setState(
                                                        () {
                                                          _isFilterOn = false;
                                                          activeFilter = index;
                                                        },
                                                      );
                                                    }
                                                  } else if (activeFilter ==
                                                      index) {
                                                  } else if (distinctStockGroup![
                                                              index]
                                                          .stockGroup ==
                                                      "Previous Orders") {
                                                    setState(
                                                      () {
                                                        _isFilterOn = true;
                                                        filterList = favourites;
                                                        activeFilter = index;
                                                      },
                                                    );
                                                  } else {
                                                    setState(
                                                      () {
                                                        _isFilterOn = true;
                                                        filterList = productListSearch!
                                                            .where((element) =>
                                                                element
                                                                    .stockGroup ==
                                                                distinctStockGroup![
                                                                        index]
                                                                    .stockGroup)
                                                            .toList();
                                                        activeFilter = index;
                                                      },
                                                    );
                                                  }
                                                });
                                          },
                                        ),
                                      )
                                    : Container()),
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
                                                  ? ListView(
                                                      shrinkWrap: true,
                                                      physics:
                                                          const BouncingScrollPhysics(),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15),
                                                      children: <Widget>[
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
                                                            return NonFavouritesCard(
                                                              key: ObjectKey(
                                                                  searchResult[
                                                                          index]
                                                                      .itemID),
                                                              item:
                                                                  searchResult[
                                                                      index],
                                                              onMiddleTap: () {
                                                                _showProductPage(
                                                                    context,
                                                                    searchResult[
                                                                        index]);
                                                              },
                                                              onTapAdd: () {
                                                                onTapAdd(
                                                                    searchResult[
                                                                        index]);
                                                              },
                                                              onTapRemove: () {
                                                                onTapRemove(
                                                                    searchResult[
                                                                        index]);
                                                              },
                                                              onLongPressedRemove:
                                                                  () {
                                                                onLongPressedRemove(
                                                                    searchResult[
                                                                        index]);
                                                              },
                                                              onLongPressedAdd:
                                                                  () {
                                                                onLongPressedAdd(
                                                                    searchResult[
                                                                        index]);
                                                              },
                                                              onDoubleTap: () {
                                                                onDoubleTap(
                                                                    searchResult[
                                                                        index]);
                                                              },
                                                            );
                                                          },
                                                        )
                                                      ],
                                                    )
                                                  : const NoDataError())
                                              : (_isFilterOn!
                                                  ? ListView(
                                                      physics:
                                                          const BouncingScrollPhysics(),
                                                      shrinkWrap: true,
                                                      children: <Widget>[
                                                        ExpandableGroup(
                                                          expandedIcon:
                                                              const Icon(
                                                            Icons
                                                                .arrow_drop_down,
                                                            size: 40,
                                                            color: GlobalTheme
                                                                .waiterrPrimaryColor,
                                                          ),
                                                          collapsedIcon:
                                                              const Icon(
                                                            Icons.arrow_right,
                                                            size: 40,
                                                            color: GlobalTheme
                                                                .waiterrPrimaryColor,
                                                          ),
                                                          isExpanded: true,
                                                          header: _header(
                                                              distinctStockGroup![
                                                                      activeFilter]
                                                                  .stockGroup),
                                                          items: _buildItems(
                                                              context,
                                                              filterList),
                                                          headerEdgeInsets:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 16.0,
                                                                  right: 16.0),
                                                        )
                                                      ],
                                                    )
                                                  : ListView(
                                                      physics:
                                                          const BouncingScrollPhysics(),
                                                      shrinkWrap: true,
                                                      controller: _controller,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      children: <Widget>[
                                                          MenuAllList(
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
                                                          // Column(
                                                          //   children: productList.map((group) {
                                                          //     int index = productList.indexOf(group);
                                                          //     return ExpandableGroup(
                                                          //       expandedIcon: Icon(Icons.arrow_drop_down,size:40,color: GlobalTheme.waiterrPrimaryColor,),
                                                          //       collapsedIcon: Icon(Icons.arrow_right,size: 40,color: GlobalTheme.waiterrPrimaryColor,),
                                                          //       isExpanded: true,
                                                          //       header: _header(productList[index][0].stockGroup),
                                                          //       items: _buildItems(context, group),
                                                          //       headerEdgeInsets: EdgeInsets.only(left: 16.0, right: 16.0),
                                                          //     );
                                                          //   }).toList(),
                                                          // ),
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
                                            if (kDebugMode) {
                                              print(snapshot.error);
                                            }
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

class ViewCartButton extends StatefulWidget {
  const ViewCartButton(
      {Key? key,
      this.totalItems,
      this.totalCartAmount,
      required this.onPressed})
      : super(key: key);
  final double? totalItems;
  final double? totalCartAmount;
  final Function() onPressed;

  @override
  State<ViewCartButton> createState() => _ViewCartButtonState();
}

class _ViewCartButtonState extends State<ViewCartButton> {
  _ViewCartButtonState();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.totalItems! > 0
            ? (widget.totalCartAmount! > 10000000000 ? 110 : 80)
            : 0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: GlobalTheme.primaryGradient),
        ),
        padding: const EdgeInsets.all(0),
        margin: const EdgeInsets.all(12),
        child: widget.totalItems! > 0
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0, backgroundColor: Colors.transparent),
                onPressed: widget.onPressed,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            '${widget.totalItems!.toStringAsFixed(2).replaceAllMapped(UserDetail.commaRegex, UserDetail.matchFunc as String Function(Match))} Items',
                            style: const TextStyle(
                                color: GlobalTheme.waiterrSecondaryText,
                                fontSize: 15),
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                  width: widget.totalCartAmount! > 10000000000
                                      ? MediaQuery.of(context).size.width * 0.43
                                      : null,
                                  child: Text(
                                    '₹${widget.totalCartAmount!.toStringAsFixed(2).replaceAllMapped(UserDetail.commaRegex, UserDetail.matchFunc as String Function(Match))} ',
                                    style: const TextStyle(
                                        color: GlobalTheme.waiterrSecondaryText,
                                        fontSize: 20),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  )),
                              const Text(
                                ' plus Taxes',
                                style: TextStyle(
                                    color: GlobalTheme.waiterrSecondaryText,
                                    fontSize: 10),
                              )
                            ],
                          )
                        ],
                      ),
                      const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              'View Cart',
                              style: TextStyle(
                                  color: GlobalTheme.waiterrSecondaryText,
                                  fontSize: 20),
                              textAlign: TextAlign.right,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.shopping_cart,
                              color: GlobalTheme.waiterrSecondaryText,
                              size: 20,
                            )
                          ]),
                    ]))
            : const SizedBox());
  }
}
