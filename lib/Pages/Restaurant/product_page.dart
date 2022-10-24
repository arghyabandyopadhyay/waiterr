import 'package:waiterr/Model/bottom_sheet_communication_template.dart';
import 'package:waiterr/Model/customizable_page_model.dart';
import 'package:waiterr/Model/menu_item_model.dart';
import 'package:waiterr/Model/product_detail_model.dart';
import 'package:waiterr/Modules/api_fetch_module.dart';
import 'package:waiterr/Pages/Restaurant/Product/product_tab.dart';
import 'package:waiterr/widgets/add_button_large.dart';
import 'package:waiterr/widgets/add_quantity_dialog.dart';
import 'package:waiterr/widgets/bottom_costumization_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../global_class.dart';
import '../../theme.dart';
import 'Product/product_about.dart';
import 'Product/product_reviews.dart';
import 'Product/product_specification.dart';

class ProductPage extends StatefulWidget {
  final MenuItemModel item;
  const ProductPage({Key? key, required this.item}) : super(key: key);
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with TickerProviderStateMixin {
  //Variables
  Future<Image?>? _futureMenuImage;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AnimationController? _cardController;
  //Controller
  final TextEditingController _searchController = TextEditingController();

  //Member Functions
  Future<Image?> fetchMenuImage() async {
    Image? menuImage;
    await postForMenuItemDetails(widget.item.itemID)
        .then((ProductDetailModel i) => {
              menuImage = i.image,
            });
    return menuImage;
  }

  void _showModalBottomSheet(BuildContext context, MenuItemModel element) {
    int i = 0;
    List<CustomizablePageModel> custList = element.customizable;
    for (CustomizablePageModel custModel in custList) {
      if (custModel.qty != 0) {}
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
                element.quantity = value.totalItem;
              })
            }
          else
            {
              setState(() {
                List<CustomizablePageModel> custList1 = element.customizable;
                for (CustomizablePageModel custModel in custList1) {
                  if (custModel.qty != 0) {}
                }
              }),
            },
        });
  }

  //Overrides
  @override
  void dispose() {
    _cardController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _futureMenuImage = fetchMenuImage();
    _cardController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
  }

  void onTapAdd() {
    if (widget.item.customizable.isEmpty) {
      widget.item.quantity = widget.item.quantity + 1;
    } else {
      _showModalBottomSheet(context, widget.item);
    }
    setState(() {});
  }

  void onLongPressedAdd() {
    (widget.item.customizable.isEmpty)
        ? showDialog(
            context: context,
            builder: (BuildContext context) {
              double quantity = 0;
              return AddQuantityDialog(
                setQuantity: (double value) {
                  quantity = value;
                },
                previousValue: widget.item.quantity,
                onTapAdd: () {
                  setState(() {
                    widget.item.quantity = quantity;
                  });
                  Navigator.pop(context);
                },
              );
            })
        : _showModalBottomSheet(context, widget.item);
  }

  @override
  Widget build(BuildContext context) {
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
            key: _scaffoldKey,
            appBar: AppBar(
              leading: IconButton(
                padding: const EdgeInsets.all(0),
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => {Navigator.of(context).pop()},
              ),
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: widget.item.favourite ? Colors.red : Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.item.favourite = widget.item.favourite;
                      });
                      //send data to api server
                    }),
              ],
            ),
            backgroundColor: GlobalTheme.backgroundColor.withOpacity(0.7),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FutureBuilder<Image?>(
                      future: _futureMenuImage,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Center(
                            child: SizedBox(
                              height: 200,
                              child: Image(
                                image: snapshot.data!.image,
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: SizedBox(
                              height: 200,
                              child:
                                  Image.asset("assets/img/all_filter_icon.png"),
                            ),
                          );
                        }
                        // By default, show a loading spinner.
                        return SizedBox(
                            width: double.infinity,
                            child: Center(
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!.withOpacity(0.3),
                                highlightColor: Colors.white,
                                enabled: true,
                                child: Container(
                                  width: 200,
                                  height: 200.0,
                                  color: Colors.white,
                                ),
                              ),
                            ));
                      }),
                  Flexible(
                    child: MultiProvider(
                      providers: [
                        ListenableProvider.value(value: _cardController)
                      ],
                      child: Scaffold(
                        body: ProductTab(
                          item: widget.item,
                          tabs: [
                            TabData("Abouts", ProductAbout(item: widget.item)),
                            TabData("Specs", const ProductSpecification()),
                            TabData("Reviews", const ProductReviews()),
                          ],
                        ),
                      ),
                    ),
                  )
                ]),
            bottomNavigationBar: BottomAppBar(
              color: Colors.transparent,
              elevation: 0.5,
              notchMargin: 5.0,
              clipBehavior: Clip.antiAlias,
              child: Container(
                  height: 70,
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 4,
                        child: AddButtonLarge(
                            item: widget.item,
                            onLongPressedAdd: onLongPressedAdd,
                            onLongPressedRemove: () {
                              if (widget.item.customizable.isEmpty) {
                                widget.item.quantity = 0.0;
                              } else {
                                _showModalBottomSheet(context, widget.item);
                              }
                              setState(() {});
                            },
                            onTapRemove: () {
                              if (widget.item.customizable.isEmpty) {
                                if (widget.item.quantity - 1 >= 0) {
                                  widget.item.quantity =
                                      widget.item.quantity == 0.0
                                          ? 0.0
                                          : widget.item.quantity - 1;
                                } else {
                                  widget.item.quantity = 0.0;
                                }
                              } else {
                                _showModalBottomSheet(context, widget.item);
                              }
                              setState(() {});
                            },
                            onTapAdd: onTapAdd),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: GlobalTheme.primaryGradient),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: GlobalTheme.primaryColor,
                                  width: 1.0,
                                  style: BorderStyle.solid)),
                          width: MediaQuery.of(context).size.width * 0.60,
                          child: Text(
                              'Add ₹ ${(widget.item.rate * widget.item.quantity).toStringAsFixed(2)}',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }
}
