import 'package:flutter/foundation.dart';
import 'package:waiterr/Model/filter_item_model.dart';
import 'package:waiterr/Model/menu_item_model.dart';
import 'package:waiterr/Model/tax_model.dart';
import 'package:waiterr/global_class.dart';
import 'package:waiterr/Modules/api_fetch_module.dart';
import 'package:waiterr/Modules/universal_module.dart';
import 'package:waiterr/widgets/chips.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import '../../../Model/outlet_configuration_model.dart';
import '../../../theme.dart';

class AddMenuPage extends StatefulWidget {
  final MenuItemModel? menuItemModel;
  final bool isEdit;
  const AddMenuPage({Key? key, this.menuItemModel, required this.isEdit})
      : super(key: key);
  @override
  State<AddMenuPage> createState() => _AddMenuPageState();
}

class _AddMenuPageState extends State<AddMenuPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  bool _isLoadingTakeaway = false;
  bool _isLoadingAvailability = false;
  bool _stockGroupLoaded = false;
  bool _taxClassLoaded = false;
  PersonData person = PersonData();
  late OutletConfigurationModel _selectedOutlet;
  late DiscountableListModel _selectedDiscountableLists;
  late MenuTypeListModel _selectedVegNonVegOptions;
  late FilterItemModel _selectedStockGroup;
  late TaxModel _selectedTaxClass;
  int _indexSelectedOutlet = -1;
  int _indexSelectedStockGroup = -1;
  int _indexSelectedTaxClass = -1;
  int _indexSelectedDiscountableLists = -1;
  int _indexSelectedVegNonVegOptions = -1;
  List<FilterItemModel>? stockGroups;
  Future<List<FilterItemModel>>? _futureStockGroups;
  List<TaxModel>? taxClasses;
  Future<List<TaxModel>>? _futureTaxClasses;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController discountedPriceController = TextEditingController();
  TextEditingController discountPercentageController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  List<OutletConfigurationModel> outletConfiguration = [];
  List<DiscountableListModel> discountableLists = [
    DiscountableListModel(isDiscountable: false, name: "Not Discountable"),
    DiscountableListModel(isDiscountable: true, name: "Discountable")
  ];
  List<MenuTypeListModel> vegNonVegOptions = [
    MenuTypeListModel(name: "Veg", isVeg: true),
    MenuTypeListModel(name: "Non Veg", isVeg: false)
  ];
  //Functions
  Future<void> _handleSubmitted() async {
    if (_isLoadingTakeaway ||
        _isLoading ||
        _isLoadingAvailability ||
        !_stockGroupLoaded ||
        !_taxClassLoaded) {
      globalShowInSnackBar(
          "Data loading taking place.", null, scaffoldMessengerKey, null, null);
    } else {
      final form = _formKey.currentState!;
      if (!form.validate() ||
          _indexSelectedOutlet < 0 ||
          _indexSelectedDiscountableLists < 0 ||
          _indexSelectedStockGroup < 0 ||
          _indexSelectedTaxClass < 0) {
        // Start validating on every change.
        if (_indexSelectedOutlet < 0) {
          globalShowInSnackBar(
              "Please Select Outlet!!", null, scaffoldMessengerKey, null, null);
        } else if (_indexSelectedDiscountableLists < 0) {
          globalShowInSnackBar("Please select is discountable or not!!", null,
              scaffoldMessengerKey, null, null);
        } else if (_indexSelectedStockGroup < 0) {
          globalShowInSnackBar("Please select a stock group!!", null,
              scaffoldMessengerKey, null, null);
        } else if (_indexSelectedTaxClass < 0) {
          globalShowInSnackBar("Please select a tax calls!!", null,
              scaffoldMessengerKey, null, null);
        }
      } else {
        form.save();
        setState(() {
          _isLoadingAvailability = true;
        });
        try {
          await postForMenuItemModification(
                  MenuItemModel(
                      item: nameController.text,
                      quantity: 0,
                      rateBeforeDiscount: double.parse(priceController.text),
                      discount: double.parse(
                          discountPercentageController.text.isEmpty
                              ? "0"
                              : discountPercentageController.text),
                      rate: double.parse(discountedPriceController.text),
                      stockGroupId: _selectedStockGroup.id,
                      stockGroup: _selectedStockGroup.stockGroup ?? "",
                      taxClassID: _selectedTaxClass.id,
                      taxRate: _selectedTaxClass.taxRate,
                      isDiscountable: _selectedDiscountableLists.isDiscountable,
                      customizable: [],
                      itemID: widget.isEdit
                          ? widget.menuItemModel?.itemID ?? ""
                          : "",
                      tags: tagsController.text,
                      isVeg: _selectedVegNonVegOptions.isVeg,
                      outletId: widget.isEdit
                          ? widget.menuItemModel?.outletId
                          : _selectedOutlet.id,
                      favourite: false,
                      isEdited: false),
                  widget.isEdit)
              .then((int resultCode) async => {
                    if (resultCode == 500)
                      {
                        globalShowInSnackBar("Something went wrong", null,
                            scaffoldMessengerKey, null, null)
                      }
                    else
                      {Navigator.pop(context)}
                  });
        } catch (E) {
          if (kDebugMode) {
            print(E);
          }
          setState(() {
            _isLoadingAvailability = false;
          });
          if (E == "NoInternet") {
            globalShowInSnackBar("No Internet Connection!!", null,
                scaffoldMessengerKey, null, null);
          } else if (E == "500") {
            globalShowInSnackBar(
                "Server Error Occurred. Please Contact Us If The problem Persists.",
                null,
                scaffoldMessengerKey,
                null,
                null);
          } else {
            if (kDebugMode) {
              print(E);
            }
            globalShowInSnackBar("Some Error Has Occurred.", null,
                scaffoldMessengerKey, null, null);
          }
        }
      }
    }
  }

  String? _validateRequired(String? value) {
    if (value!.isEmpty) return "Please fill the required fields";
    return null;
  }

  Future<List<FilterItemModel>> fetchStockGroups() async {
    List<FilterItemModel> stockGroups = [];
    await postForMenuGroupItem(_selectedOutlet.id)
        .then((List<FilterItemModel> rList) => {stockGroups.addAll(rList)});
    setState(() {
      if (stockGroups.isNotEmpty) {
        if (widget.isEdit) {
          _selectedStockGroup = stockGroups
              .where(
                  (element) => element.id == widget.menuItemModel!.stockGroupId)
              .first;
          _indexSelectedStockGroup = stockGroups.indexOf(_selectedStockGroup);
        } else {
          _selectedStockGroup = stockGroups.first;
        }
      }
      _isLoading = false;
      _stockGroupLoaded = true;
    });
    return stockGroups;
  }

  Future<List<TaxModel>> fetchTaxClasses() async {
    List<TaxModel> taxClasses = [];
    await postForTaxClass()
        .then((List<TaxModel> rList) => {taxClasses.addAll(rList)});
    setState(() {
      if (taxClasses.isNotEmpty) {
        if (widget.isEdit) {
          _selectedTaxClass = taxClasses
              .where(
                  (element) => element.id == widget.menuItemModel!.taxClassID)
              .first;
          _indexSelectedTaxClass = taxClasses.indexOf(_selectedTaxClass);
        } else {
          _selectedTaxClass = taxClasses.first;
        }
      }
      _isLoading = false;
      _taxClassLoaded = true;
    });
    return taxClasses;
  }

  //Overrides
  @override
  void initState() {
    super.initState();
    outletConfiguration = [];
    if (UserClientAllocationData.outletConfiguration != null) {
      UserClientAllocationData.outletConfiguration?.forEach((element) {
        outletConfiguration.add(element);
      });
    }
    if (widget.isEdit) {
      nameController.text = widget.menuItemModel!.item;
      descriptionController.text = widget.menuItemModel!.itemDescription ?? "";
      priceController.text =
          widget.menuItemModel!.rateBeforeDiscount.toString();
      discountedPriceController.text = widget.menuItemModel!.rate.toString();
      discountPercentageController.text =
          widget.menuItemModel!.discount.toString();
      tagsController.text = widget.menuItemModel!.tags ?? "";
      _indexSelectedDiscountableLists =
          (widget.menuItemModel?.isDiscountable ?? false) ? 1 : 0;
      _selectedDiscountableLists =
          discountableLists[_indexSelectedDiscountableLists];
      _indexSelectedVegNonVegOptions =
          (widget.menuItemModel?.isVeg ?? true) ? 0 : 1;
      _selectedVegNonVegOptions =
          vegNonVegOptions[_indexSelectedVegNonVegOptions];
    } else {
      _indexSelectedDiscountableLists = 0;
      _selectedDiscountableLists = discountableLists.first;
      _indexSelectedVegNonVegOptions = 0;
      _selectedVegNonVegOptions = vegNonVegOptions.first;
    }
    _indexSelectedOutlet = 0;
    _selectedOutlet = outletConfiguration.first;
    _futureStockGroups = fetchStockGroups();
    _futureTaxClasses = fetchTaxClasses();
  }

  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 24);
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
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                centerTitle: true,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              key: _scaffoldKey,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "Add Menu",
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                  Flexible(
                      child: Container(
                    height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.only(top: 10),
                    decoration: GlobalTheme.waiterrAppBarBoxDecoration,
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                          dragStartBehavior: DragStartBehavior.down,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          physics: const BouncingScrollPhysics(),
                          child: GestureDetector(
                            onTap: () {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    height: _isLoadingAvailability ? 40 : 0,
                                    width: _isLoadingAvailability ? 40 : 0,
                                    padding: const EdgeInsets.all(10),
                                    child: _isLoadingAvailability
                                        ? const CircularProgressIndicator(
                                            strokeWidth: 3,
                                          )
                                        : null,
                                  ),
                                ),
                                if (!widget.isEdit) const Text("Outlets:"),
                                if (!widget.isEdit)
                                  SizedBox(
                                    height: 50,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: outletConfiguration.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return Chips(
                                            item: outletConfiguration[index]
                                                .outletName,
                                            index: index,
                                            indexSelected: _indexSelectedOutlet,
                                            onSelected: (value) {
                                              setState(() {
                                                _indexSelectedOutlet = index;
                                                _selectedOutlet =
                                                    outletConfiguration[index];
                                                _futureStockGroups =
                                                    fetchStockGroups();
                                                if (value) {
                                                  _stockGroupLoaded = false;
                                                  _isLoadingTakeaway = false;
                                                }
                                                //get list of table
                                              });
                                            });
                                      },
                                    ),
                                  ),
                                sizedBoxSpace,
                                TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  controller: nameController,
                                  style: const TextStyle(),
                                  decoration: const InputDecoration(
                                    labelText: "Item Name",
                                  ),
                                  onSaved: (value) {
                                    person.name = value;
                                  },
                                  validator: _validateRequired,
                                ),
                                sizedBoxSpace,
                                TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  controller: descriptionController,
                                  style: const TextStyle(),
                                  decoration: const InputDecoration(
                                    labelText: "Item Description",
                                  ),
                                  onSaved: (value) {
                                    person.name = value;
                                  },
                                ),
                                sizedBoxSpace,
                                //isVeg
                                const Text("Types:"),
                                SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: vegNonVegOptions.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Chips(
                                          item: vegNonVegOptions[index].name,
                                          index: index,
                                          indexSelected:
                                              _indexSelectedVegNonVegOptions,
                                          onSelected: (value) {
                                            setState(() {
                                              _indexSelectedVegNonVegOptions =
                                                  index;
                                              _selectedVegNonVegOptions =
                                                  vegNonVegOptions[index];
                                              //get list of table
                                            });
                                          });
                                    },
                                  ),
                                ),
                                sizedBoxSpace,
                                TextFormField(
                                  controller: priceController,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(),
                                  decoration: const InputDecoration(
                                    labelText: "Price",
                                  ),
                                  onChanged: (value) {
                                    discountedPriceController
                                        .text = (double.parse(value) *
                                            (1 -
                                                double.parse(
                                                        discountPercentageController
                                                                    .text ==
                                                                ""
                                                            ? "0"
                                                            : discountPercentageController
                                                                .text) /
                                                    100))
                                        .toString();
                                  },
                                  validator: _validateRequired,
                                ),
                                sizedBoxSpace,
                                //isDiscountable
                                const Text("Is Discountable:"),
                                SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: discountableLists.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Chips(
                                          item: discountableLists[index].name,
                                          index: index,
                                          indexSelected:
                                              _indexSelectedDiscountableLists,
                                          onSelected: (value) {
                                            setState(() {
                                              _indexSelectedDiscountableLists =
                                                  index;
                                              _selectedDiscountableLists =
                                                  discountableLists[index];
                                            });
                                          });
                                    },
                                  ),
                                ),
                                sizedBoxSpace,
                                TextFormField(
                                  enabled:
                                      _selectedDiscountableLists.isDiscountable,
                                  keyboardType: TextInputType.number,
                                  controller: discountPercentageController,
                                  style: const TextStyle(),
                                  decoration: const InputDecoration(
                                    labelText: "Discount %",
                                  ),
                                  onChanged: (value) {
                                    discountedPriceController
                                        .text = (double.parse(
                                                priceController.text == ""
                                                    ? "0"
                                                    : priceController.text) *
                                            (1 -
                                                double.parse(value == ""
                                                        ? "0"
                                                        : discountPercentageController
                                                            .text) /
                                                    100))
                                        .toString();
                                  },
                                ),
                                sizedBoxSpace,
                                TextFormField(
                                  enabled: false,
                                  controller: discountedPriceController,
                                  style: const TextStyle(),
                                  decoration: const InputDecoration(
                                    labelText: "Discounted Price",
                                  ),
                                  onSaved: (value) {
                                    person.name = value;
                                  },
                                ),
                                sizedBoxSpace,
                                const Text("Stock Group:"),
                                FutureBuilder<List<FilterItemModel>>(
                                    future: _futureStockGroups,
                                    builder: ((context, snapshot) {
                                      if (snapshot.hasData) {
                                        stockGroups = snapshot.data;
                                        return SizedBox(
                                          height: 50,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: stockGroups!.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return Chips(
                                                  item: stockGroups![index]
                                                      .stockGroup,
                                                  index: index,
                                                  indexSelected:
                                                      _indexSelectedStockGroup,
                                                  onSelected: (value) {
                                                    setState(() {
                                                      _indexSelectedStockGroup =
                                                          index;
                                                      _selectedStockGroup =
                                                          stockGroups![index];
                                                    });
                                                  });
                                            },
                                          ),
                                        );
                                      } else if (snapshot.hasError) {
                                        return ListTile(
                                            title: Text(
                                                snapshot.error.toString()));
                                      }
                                      // By default, show a loading spinner.
                                      return const Text(
                                          "Stock Group Loading...");
                                    })),
                                sizedBoxSpace,
                                const Text("Tax Class:"),
                                FutureBuilder<List<TaxModel>>(
                                    future: _futureTaxClasses,
                                    builder: ((context, snapshot) {
                                      if (snapshot.hasData) {
                                        taxClasses = snapshot.data;
                                        return SizedBox(
                                          height: 50,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: taxClasses!.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return Chips(
                                                  item: taxClasses![index]
                                                      .taxClass,
                                                  index: index,
                                                  indexSelected:
                                                      _indexSelectedTaxClass,
                                                  onSelected: (value) {
                                                    setState(() {
                                                      _indexSelectedTaxClass =
                                                          index;
                                                      _selectedTaxClass =
                                                          taxClasses![index];
                                                    });
                                                  });
                                            },
                                          ),
                                        );
                                      } else if (snapshot.hasError) {
                                        return ListTile(
                                            title: Text(
                                                snapshot.error.toString()));
                                      }
                                      // By default, show a loading spinner.
                                      return const Text(
                                          "Tax Classes Loading...");
                                    })),
                                sizedBoxSpace,
                                TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  controller: tagsController,
                                  style: const TextStyle(),
                                  decoration: const InputDecoration(
                                    labelText: "Tags",
                                  ),
                                  validator: _validateRequired,
                                ),
                                sizedBoxSpace,
                              ],
                            ),
                          )),
                    ),
                  ))
                ],
              ),
              backgroundColor: GlobalTheme.tint,
              floatingActionButton: FloatingActionButton.extended(
                icon: Icon(
                  widget.isEdit ? Icons.save : Icons.add,
                ),
                label: Text(
                  widget.isEdit ? "Save" : "Add",
                  style: const TextStyle(
                    fontSize: 17,
                  ),
                ),
                onPressed: _handleSubmitted,
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
            )
          ],
        ),
      ),
    );
  }
}

class PersonData {
  String? name = '';
  String? phoneNumber = '';
  String outlet = '';
  String? salesPointNo = '';
  String? pax = '';
}

class DiscountableListModel {
  String name;
  bool isDiscountable;
  DiscountableListModel({required this.name, required this.isDiscountable});
}

class MenuTypeListModel {
  String name;
  bool isVeg;
  MenuTypeListModel({required this.name, required this.isVeg});
}
