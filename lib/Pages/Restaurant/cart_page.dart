import 'package:waiterr/Model/bottom_sheet_communication_template.dart';
import 'package:waiterr/Model/customizable_page_model.dart';
import 'package:waiterr/Model/menu_item_model.dart';
import 'package:waiterr/Model/place_order_menu_list.dart';
import 'package:waiterr/Model/RequestJson/place_order_json.dart';
import 'package:waiterr/Model/running_order_model.dart';
import 'package:waiterr/Modules/universal_module.dart';
import 'package:waiterr/widgets/add_comment_for_kot_dialog.dart';
import 'package:waiterr/widgets/add_quantity_dialog.dart';
import 'package:waiterr/widgets/bottom_costumization_sheet.dart';
import 'package:waiterr/widgets/cart_list_card.dart';
import 'package:waiterr/widgets/confirmation_dialog.dart';
import 'package:waiterr/widgets/loading_indicator.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Model/comment_for_kot_suggestion_model.dart';
import '../../global_class.dart';
import '../../theme.dart';
import 'package:waiterr/Modules/api_fetch_module.dart';

class FoodOrderPage extends StatefulWidget {
  final List<MenuItemModel> cartList;
  final bool isWaiter;
  final RunningOrderModel addOrderData;
  const FoodOrderPage(this.cartList, this.addOrderData, this.isWaiter,
      {super.key});
  @override
  State<FoodOrderPage> createState() => _FoodOrderPageState();
}

class _FoodOrderPageState extends State<FoodOrderPage> {
  double? totalItems;
  double? totalCartAmount;
  double totalTax = 0;
  double globalBillingRate = 0;
  TextEditingController remarks = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  bool isLoading = false;
  Widget _shoppingCartBadge() {
    return Badge(
      position: BadgePosition.topEnd(top: 0, end: 3),
      animationDuration: const Duration(milliseconds: 300),
      animationType: BadgeAnimationType.slide,
      badgeContent: Text(
        totalItems!.round().toString(),
        style: const TextStyle(color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child:
            IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () {}),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context, MenuItemModel element) {
    int i = 0;
    List<CustomizablePageModel> custList = element.customizable;
    for (CustomizablePageModel custModel in custList) {
      if (custModel.qty != 0) {
        totalItems = totalItems! - custModel.qty;
        totalCartAmount = totalCartAmount! - custModel.price * custModel.qty;
      }
    }
    showModalBottomSheet<CustValTemp>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: GlobalTheme.backgroundColor,
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
                totalCartAmount = totalCartAmount! + value.totalCartAmount!;
                totalItems = totalItems! + value.totalItem;
                element.quantity = value.totalItem;
              })
            }
          else
            {
              setState(() {
                List<CustomizablePageModel> custList1 = element.customizable;
                for (CustomizablePageModel custModel in custList1) {
                  if (custModel.qty != 0) {
                    totalItems = totalItems! + custModel.qty;
                    totalCartAmount =
                        totalCartAmount! + custModel.price * custModel.qty;
                  }
                }
              }),
            },
        });
  }

  void onTapAdd(MenuItemModel itemModel) {
    if (itemModel.customizable.isEmpty) {
      setState(() {
        totalItems = totalItems! + 1;
        totalCartAmount = totalCartAmount! + itemModel.rate;
        totalTax = totalTax + itemModel.rate * itemModel.taxRate * 0.01;
        itemModel.quantity = itemModel.quantity + 1;
      });
    } else {
      _showModalBottomSheet(context, itemModel);
    }
  }

  void onTapRemove(MenuItemModel itemModel) {
    if (itemModel.customizable.isEmpty) {
      setState(() {
        if (itemModel.quantity - 1 >= 0) {
          totalItems = itemModel.quantity == 0.0 ? totalItems : totalItems! - 1;
          totalCartAmount = itemModel.quantity == 0.0
              ? totalCartAmount
              : totalCartAmount! - itemModel.rate;
          totalTax = itemModel.quantity == 0.0
              ? totalTax
              : totalTax - itemModel.rate * itemModel.taxRate * 0.01;
          itemModel.quantity =
              itemModel.quantity == 0.0 ? 0.0 : itemModel.quantity - 1;
        } else {
          totalItems = itemModel.quantity == 0.0
              ? totalItems
              : totalItems! - itemModel.quantity;
          totalCartAmount = itemModel.quantity == 0.0
              ? totalCartAmount
              : totalCartAmount! - (itemModel.rate * itemModel.quantity);
          totalTax = itemModel.quantity == 0.0
              ? totalTax
              : totalTax -
                  itemModel.rate *
                      itemModel.quantity *
                      itemModel.taxRate *
                      0.01;
          itemModel.quantity = 0.0;
        }
      });
    } else {
      setState(() {
        _showModalBottomSheet(context, itemModel);
      });
    }
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
    if (itemModel.customizable.isEmpty) {
      setState(() {
        totalItems = itemModel.quantity == 0.0
            ? totalItems
            : totalItems! - itemModel.quantity;
        totalCartAmount = itemModel.quantity == 0.0
            ? totalCartAmount
            : totalCartAmount! - (itemModel.rate * itemModel.quantity);
        totalTax = itemModel.quantity == 0.0
            ? totalTax
            : totalTax -
                itemModel.rate * itemModel.quantity * itemModel.taxRate * 0.01;
        itemModel.quantity = 0.0;
      });
    } else {
      _showModalBottomSheet(context, itemModel);
    }
  }

  void onLongPressedAdd(MenuItemModel itemModel) {
    (itemModel.customizable.isEmpty)
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
                    totalItems = totalItems! + quantity - itemModel.quantity;
                    double info = itemModel.rate;
                    totalCartAmount = totalCartAmount! +
                        info * (quantity - itemModel.quantity);
                    totalTax = totalTax +
                        itemModel.rate *
                            (quantity - itemModel.quantity) *
                            itemModel.taxRate *
                            0.01;
                    itemModel.quantity = quantity;
                  });
                  Navigator.pop(context);
                },
              );
            })
        : _showModalBottomSheet(context, itemModel);
  }

  @override
  void initState() {
    super.initState();
    totalItems = widget.cartList.last.quantity;
    totalCartAmount = widget.cartList.last.rate;
    for (int a = 0; a < widget.cartList.length - 1; a++) {
      totalTax = totalTax +
          widget.cartList[a].rate *
              widget.cartList[a].quantity *
              widget.cartList[a].taxRate *
              0.01;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingIndicator(
        inAsyncCall: isLoading,
        child: ScaffoldMessenger(
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
                    key: _scaffoldKey,
                    appBar: AppBar(
                        backgroundColor: Colors.transparent,
                        centerTitle: true,
                        elevation: 0,
                        leading: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                            ),
                            onPressed: () => {
                                  if (isLoading)
                                    {
                                      globalShowInSnackBar(
                                          "Data loading..",
                                          SnackBarAction(
                                            label: "Undo",
                                            onPressed: () {
                                              Navigator.of(_scaffoldKey
                                                      .currentState!.context)
                                                  .popUntil(
                                                      (route) => route.isFirst);
                                            },
                                          ),
                                          scaffoldMessengerKey,
                                          null,
                                          null)
                                    }
                                  else
                                    {
                                      Navigator.pop(context,
                                          ("$totalItems|$totalCartAmount")),
                                    }
                                }
                            //
                            ),
                        actions: <Widget>[_shoppingCartBadge()]),
                    body: WillPopScope(
                        onWillPop: () {
                          if (isLoading) {
                            globalShowInSnackBar(
                                "Data loading..",
                                SnackBarAction(
                                  label: "Undo",
                                  onPressed: () {
                                    Navigator.of(
                                            _scaffoldKey.currentState!.context)
                                        .popUntil((route) => route.isFirst);
                                  },
                                ),
                                scaffoldMessengerKey,
                                null,
                                null);
                            return Future(() => false);
                          } else {
                            Navigator.pop(
                                context, ("$totalItems|$totalCartAmount"));
                            return Future(() => false);
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                "Cart",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold),
                              ),
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
                              child: ListView(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 5),
                                  children: <Widget>[
                                    ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: widget.cartList.length - 1,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return CartListCard(
                                          item: widget.cartList[index],
                                          onTapAdd: () {
                                            onTapAdd(widget.cartList[index]);
                                          },
                                          onTapRemove: () {
                                            onTapRemove(widget.cartList[index]);
                                          },
                                          onLongPressedAdd: () {
                                            onLongPressedAdd(
                                                widget.cartList[index]);
                                          },
                                          onLongPressedRemove: () {
                                            onLongPressedRemove(
                                                widget.cartList[index]);
                                          },
                                          onDoubleTap: () {
                                            onDoubleTap(widget.cartList[index]);
                                          },
                                        );
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Card(
                                      elevation: 0,
                                      child: TextFormField(
                                        controller: remarks,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        style: GoogleFonts.robotoCondensed(
                                            fontWeight: FontWeight.bold),
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: "Remarks",
                                          hintStyle: TextStyle(
                                              color: GlobalTheme.primaryText),
                                          labelStyle: TextStyle(
                                              color: GlobalTheme.primaryText),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0)),
                                              borderSide: BorderSide(
                                                  color: GlobalTheme
                                                      .primaryColor)),
                                          contentPadding: EdgeInsets.only(
                                              bottom: 10.0,
                                              left: 10.0,
                                              right: 10.0),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    // Card(
                                    //   elevation: 2,
                                    //   child: Container(
                                    //     padding: EdgeInsets.all(10),
                                    //     decoration: BoxDecoration(
                                    //       borderRadius:const BorderRadius.all(Radius.circular(5)),
                                    //       border: Border.all(color: GlobalTheme.primaryText,width: 1,style: BorderStyle.solid),
                                    //       color: Colors.white,
                                    //     ),
                                    //     child: ListView.builder(
                                    //       shrinkWrap: true,
                                    //       physics: NeverScrollableScrollPhysics(),
                                    //       itemCount: CartList.length-1,
                                    //       itemBuilder: (context, id) {
                                    //         return Card(
                                    //           elevation: 0,
                                    //           child: TotalCalculationWidget(item:CartList[id]),
                                    //         );
                                    //       },
                                    //     ),
                                    //   ),
                                    // ),
                                    Card(
                                        elevation: 2,
                                        child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                              border: Border.all(
                                                  color:
                                                      GlobalTheme.primaryText,
                                                  width: 1,
                                                  style: BorderStyle.solid),
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text("Tax",
                                                      style: TextStyle(
                                                          fontSize: 17)),
                                                  Text(
                                                    "₹${totalTax.toStringAsFixed(2).replaceAllMapped(UserDetail.commaRegex, UserDetail.matchFunc as String Function(Match))}",
                                                    textAlign: TextAlign.end,
                                                    style: const TextStyle(
                                                        fontSize: 20),
                                                  ),
                                                ]))),
                                    Card(
                                        elevation: 2,
                                        child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                              border: Border.all(
                                                  color:
                                                      GlobalTheme.primaryText,
                                                  width: 1,
                                                  style: BorderStyle.solid),
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text("Total",
                                                      style: TextStyle(
                                                          fontSize: 20)),
                                                  Text(
                                                    "₹${(totalCartAmount! + totalTax).toStringAsFixed(2).replaceAllMapped(UserDetail.commaRegex, UserDetail.matchFunc as String Function(Match))}",
                                                    textAlign: TextAlign.end,
                                                    style: const TextStyle(
                                                        fontSize: 20),
                                                  ),
                                                ]))),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                  ]),
                            ))
                          ],
                        )),
                    backgroundColor:
                        GlobalTheme.backgroundColor.withOpacity(0.7),
                    floatingActionButton: FloatingActionButton.extended(
                        elevation: 5,
                        label: const Text("Place Order",
                            style: TextStyle(
                              fontSize: 17,
                              color: GlobalTheme.floatingButtonText,
                            )),
                        icon: const Icon(
                          Icons.restaurant,
                          color: GlobalTheme.floatingButtonText,
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ConfirmationDialog(
                                  headerText: "Place Order",
                                  question: "Are you sure to place the order?",
                                  onTap_Yes: () {
                                    {
                                      Navigator.pop(context);
                                      setState(() {
                                        isLoading = true;
                                      });
                                      List<PlaceOrderMenuList> order = [];
                                      for (int a = 0;
                                          a < widget.cartList.length - 1;
                                          a++) {
                                        if (widget.cartList[a].customizable
                                                .isEmpty &&
                                            widget.cartList[a].quantity > 0.0) {
                                          order.add(PlaceOrderMenuList(
                                              itemID: widget.cartList[a].itemID,
                                              quantity:
                                                  widget.cartList[a].quantity,
                                              rate: widget.cartList[a].rate,
                                              commentForKOT: widget
                                                  .cartList[a].commentForKOT,
                                              commentForKOTId: widget
                                                  .cartList[a].commentForKOTId,
                                              taxClassID:
                                                  widget.cartList[a].taxClassID,
                                              taxRate:
                                                  widget.cartList[a].taxRate,
                                              discountable: widget
                                                  .cartList[a].isDiscountable));
                                        } else {}
                                      }
                                      PlaceOrderJson placeOrderJson =
                                          PlaceOrderJson(
                                              salePointName: widget
                                                  .addOrderData.salePointName,
                                              salePointType: widget
                                                  .addOrderData.salePointType,
                                              waiterId:
                                                  UserDetail.userDetails.id,
                                              outletName: widget
                                                  .addOrderData.outletName,
                                              customerName:
                                                  widget.addOrderData.name,
                                              mobileNumber:
                                                  widget.addOrderData.mobileNo,
                                              pAX: widget.addOrderData.pax,
                                              outletId:
                                                  widget.addOrderData.outletId,
                                              narration:
                                                  (remarks.text.isNotEmpty)
                                                      ? remarks.text
                                                      : "",
                                              createdOn: DateTime.now()
                                                  .toIso8601String(),
                                              menuList: order,
                                              userRole: !widget.isWaiter
                                                  ? "User"
                                                  : "Waiter");
                                      _placeOrder(placeOrderJson)
                                          .then((value) => {
                                                if (value == 200)
                                                  {
                                                    setState(() {
                                                      isLoading = false;
                                                    }),
                                                    Navigator.of(_scaffoldKey
                                                            .currentState!
                                                            .context)
                                                        .popUntil((route) =>
                                                            route.isFirst),
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
                                                                    route
                                                                        .isFirst);
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
                                                                    route
                                                                        .isFirst);
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
                                                                    route
                                                                        .isFirst);
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
                        }),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.endFloat,
                  )
                ],
              ),
            )));
  }

  Future<int?> _placeOrder(PlaceOrderJson json) async {
    int? status;
    try {
      await postForPlaceOrder(json).then((value) => {status = value});

      return status;
    } catch (E) {
      return 404;
    }
  }
}

class CartIconWithBadge extends StatelessWidget {
  final int counter = 3;

  const CartIconWithBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        IconButton(
            icon: const Icon(
              Icons.business_center,
              color: Color(0xFF3a3737),
            ),
            onPressed: () {}),
        counter != 0
            ? Positioned(
                right: 11,
                top: 11,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Text(
                    '$counter',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}

class AddToCartMenu extends StatelessWidget {
  final int productCounter;
  const AddToCartMenu(this.productCounter, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.remove),
          color: Colors.black,
          iconSize: 18,
        ),
        InkWell(
          onTap: () => print('hello'),
          child: Container(
            width: 100.0,
            height: 35.0,
            decoration: BoxDecoration(
              color: const Color(0xFFfd2c2c),
              border: Border.all(color: Colors.white, width: 2.0),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: Text(
                'Add To $productCounter',
                style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.add),
          color: const Color(0xFFfd2c2c),
          iconSize: 18,
        ),
      ],
    );
  }
}
