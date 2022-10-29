import 'package:flutter/foundation.dart';
import 'package:waiterr/Model/menu_item_model.dart';
import 'package:waiterr/Model/user_details_model.dart';
import 'package:waiterr/global_class.dart';
import 'package:waiterr/Model/user_restraunt_allocation_model.dart';
import 'package:waiterr/Modules/api_fetch_module.dart';
import 'package:waiterr/Modules/universal_module.dart';
import 'package:waiterr/widgets/chips.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import '../../theme.dart';

class AddMenuPage extends StatefulWidget {
  const AddMenuPage({Key? key}) : super(key: key);
  @override
  State<AddMenuPage> createState() => _AddMenuPageState();
}

class _AddMenuPageState extends State<AddMenuPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  bool _isLoadingTakeaway = false;
  bool _isLoadingAvailability = false;
  String? customerId;
  PersonData person = PersonData();
  late OutletConfigurationModel _selectedOutlet;
  late DiscountableListModel _selectedDiscountableLists;
  late MenuTypeListModel _selectedVegNonVegOptions;
  int _indexSelectedOutlet = -1;
  int _indexSelectedDiscountableLists = -1;
  int _indexSelectedVegNonVegOptions = -1;
  var phoneNumber = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController stockGroupController = TextEditingController();
  TextEditingController discountedPriceController = TextEditingController();
  TextEditingController discountPercentageController = TextEditingController();
  TextEditingController taxIdGroupController = TextEditingController();
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
    if (_isLoadingTakeaway || _isLoading || _isLoadingAvailability) {
      globalShowInSnackBar(
          "Data loading taking place.", null, scaffoldMessengerKey, null, null);
    } else {
      final form = _formKey.currentState!;
      if (!form.validate() || _indexSelectedOutlet < 0 || customerId == null) {
        // Start validating on every change.
        if (_indexSelectedOutlet < 0) {
          globalShowInSnackBar(
              "Please Select Outlet!!", null, scaffoldMessengerKey, null, null);
        } else if (customerId == null) {
          globalShowInSnackBar(
              "Either mobile number is not filled, or the given phone number doesn't exist!!",
              null,
              scaffoldMessengerKey,
              null,
              null);
        }
      } else {
        form.save();
        setState(() {
          _isLoadingAvailability = true;
        });
        try {
          await postForNewMenuItem(
                  MenuItemModel(
                      item: nameController.text,
                      quantity: 0,
                      rateBeforeDiscount: double.parse(priceController.text),
                      discount: double.parse(discountPercentageController.text),
                      rate: double.parse(discountedPriceController.text),
                      stockGroupId: "",
                      stockGroup: "",
                      taxClassID: taxIdGroupController.text,
                      taxRate: 5,
                      isDiscountable: _selectedDiscountableLists.isDiscountable,
                      customizable: [],
                      itemID: "",
                      isVeg: _selectedVegNonVegOptions.isVeg,
                      outletId: _selectedOutlet.id,
                      favourite: false,
                      isEdited: false),
                  false)
              .then((int resultCode) async => {Navigator.pop(context)});
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

  String? _validateName(String? value) {
    //final nameExp = RegExp(r'^[A-Za-z ]+$');
    // if (value.isNotEmpty&&!nameExp.hasMatch(value)) {
    //   return "Robots not allowed.!";
    // }
    if (value!.isEmpty) nameController.text = "";
    return null;
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
    nameController.text = "";
    _indexSelectedOutlet = 0;
    _selectedOutlet = outletConfiguration.first;
    _indexSelectedDiscountableLists = 0;
    _selectedDiscountableLists = discountableLists.first;
    _indexSelectedVegNonVegOptions = 0;
    _selectedVegNonVegOptions = vegNonVegOptions.first;
  }

  @override
  Widget build(BuildContext context) {
    const cursorColor = GlobalTheme.primaryColor;
    const sizedBoxSpace = SizedBox(height: 24);
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
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              key: _scaffoldKey,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "Add Menu",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.bold),
                    ),
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
                                            backgroundColor: GlobalTheme
                                                .progressBarBackground,
                                          )
                                        : null,
                                  ),
                                ),
                                const Text("Outlets:",
                                    style: TextStyle(
                                        color: GlobalTheme.primaryText)),
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
                                              if (value) {
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
                                  cursorColor: cursorColor,
                                  style: const TextStyle(),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Item Name",
                                    hintStyle: TextStyle(
                                        color: GlobalTheme.primaryText),
                                    labelStyle: TextStyle(
                                        color: GlobalTheme.primaryText),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        borderSide: BorderSide(
                                            color: GlobalTheme.primaryColor)),
                                    contentPadding: EdgeInsets.only(
                                        bottom: 10.0, left: 10.0, right: 10.0),
                                  ),
                                  onSaved: (value) {
                                    person.name = value;
                                  },
                                  validator: _validateName,
                                ),
                                sizedBoxSpace,
                                TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  controller: descriptionController,
                                  cursorColor: cursorColor,
                                  style: const TextStyle(),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Item Description",
                                    hintStyle: TextStyle(
                                        color: GlobalTheme.primaryText),
                                    labelStyle: TextStyle(
                                        color: GlobalTheme.primaryText),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        borderSide: BorderSide(
                                            color: GlobalTheme.primaryColor)),
                                    contentPadding: EdgeInsets.only(
                                        bottom: 10.0, left: 10.0, right: 10.0),
                                  ),
                                  onSaved: (value) {
                                    person.name = value;
                                  },
                                ),
                                sizedBoxSpace,
                                //isVeg
                                const Text("Types:",
                                    style: TextStyle(
                                        color: GlobalTheme.primaryText)),
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
                                  cursorColor: cursorColor,
                                  style: const TextStyle(),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Price",
                                    hintStyle: TextStyle(
                                        color: GlobalTheme.primaryText),
                                    labelStyle: TextStyle(
                                        color: GlobalTheme.primaryText),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        borderSide: BorderSide(
                                            color: GlobalTheme.primaryColor)),
                                    contentPadding: EdgeInsets.only(
                                        bottom: 10.0, left: 10.0, right: 10.0),
                                  ),
                                  onSaved: (value) {
                                    person.name = value;
                                  },
                                ),
                                sizedBoxSpace,
                                //isDiscountable
                                const Text("Is Discountable:",
                                    style: TextStyle(
                                        color: GlobalTheme.primaryText)),
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
                                  cursorColor: cursorColor,
                                  style: const TextStyle(),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Discount%",
                                    hintStyle: TextStyle(
                                        color: GlobalTheme.primaryText),
                                    labelStyle: TextStyle(
                                        color: GlobalTheme.primaryText),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        borderSide: BorderSide(
                                            color: GlobalTheme.primaryColor)),
                                    contentPadding: EdgeInsets.only(
                                        bottom: 10.0, left: 10.0, right: 10.0),
                                  ),
                                  onSaved: (value) {
                                    person.name = value;
                                  },
                                ),
                                sizedBoxSpace,
                                TextFormField(
                                  enabled: false,
                                  controller: discountedPriceController,
                                  cursorColor: cursorColor,
                                  style: const TextStyle(),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Discounted Price",
                                    hintStyle: TextStyle(
                                        color: GlobalTheme.primaryText),
                                    labelStyle: TextStyle(
                                        color: GlobalTheme.primaryText),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        borderSide: BorderSide(
                                            color: GlobalTheme.primaryColor)),
                                    contentPadding: EdgeInsets.only(
                                        bottom: 10.0, left: 10.0, right: 10.0),
                                  ),
                                  onSaved: (value) {
                                    person.name = value;
                                  },
                                ),
                                sizedBoxSpace,
                                TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  controller: stockGroupController,
                                  cursorColor: cursorColor,
                                  style: const TextStyle(),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Stock Group",
                                    hintStyle: TextStyle(
                                        color: GlobalTheme.primaryText),
                                    labelStyle: TextStyle(
                                        color: GlobalTheme.primaryText),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        borderSide: BorderSide(
                                            color: GlobalTheme.primaryColor)),
                                    contentPadding: EdgeInsets.only(
                                        bottom: 10.0, left: 10.0, right: 10.0),
                                  ),
                                  onSaved: (value) {
                                    person.name = value;
                                  },
                                ),
                                sizedBoxSpace,
                                TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  controller: taxIdGroupController,
                                  cursorColor: cursorColor,
                                  style: const TextStyle(),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Tax Group",
                                    hintStyle: TextStyle(
                                        color: GlobalTheme.primaryText),
                                    labelStyle: TextStyle(
                                        color: GlobalTheme.primaryText),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        borderSide: BorderSide(
                                            color: GlobalTheme.primaryColor)),
                                    contentPadding: EdgeInsets.only(
                                        bottom: 10.0, left: 10.0, right: 10.0),
                                  ),
                                  onSaved: (value) {
                                    person.name = value;
                                  },
                                ),
                                sizedBoxSpace,
                                TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  controller: tagsController,
                                  cursorColor: cursorColor,
                                  style: const TextStyle(),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Tags",
                                    hintStyle: TextStyle(
                                        color: GlobalTheme.primaryText),
                                    labelStyle: TextStyle(
                                        color: GlobalTheme.primaryText),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        borderSide: BorderSide(
                                            color: GlobalTheme.primaryColor)),
                                    contentPadding: EdgeInsets.only(
                                        bottom: 10.0, left: 10.0, right: 10.0),
                                  ),
                                  onSaved: (value) {
                                    person.name = value;
                                  },
                                ),
                                sizedBoxSpace,
                              ],
                            ),
                          )),
                    ),
                  ))
                ],
              ),
              backgroundColor: GlobalTheme.backgroundColor.withOpacity(0.7),
              floatingActionButton: FloatingActionButton.extended(
                icon: const Icon(
                  Icons.add,
                  color: GlobalTheme.floatingButtonText,
                ),
                label: const Text(
                  "Add",
                  style: TextStyle(
                    fontSize: 17,
                    color: GlobalTheme.floatingButtonText,
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

class _IndNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    try {
      final newTextLength = newValue.text.length;
      final newText = StringBuffer();
      var selectionIndex = newValue.selection.end;
      var usedSubstringIndex = 0;
      if (newTextLength >= 6) {
        if (newTextLength <= 11) {
          newText
              .write('${newValue.text.substring(0, usedSubstringIndex = 5)} ');
          if (newValue.selection.end >= 5) selectionIndex++;
        } else {
          newText
              .write('${newValue.text.substring(2, usedSubstringIndex = 7)} ');
          if (newValue.selection.end >= 7) selectionIndex++;
        }
      }
      if (newTextLength >= 11) {
        if (newTextLength <= 11) {
          newText.write(newValue.text.substring(5, usedSubstringIndex = 10));
          if (newValue.selection.end >= 10) {
            selectionIndex++;
          }
        } else {
          newText.write(newValue.text.substring(7, usedSubstringIndex = 12));
          if (newValue.selection.end >= 12) {
            selectionIndex++;
          }
        }
      }
      // Dump the rest.
      if (newTextLength >= usedSubstringIndex) {
        newText.write(newValue.text.substring(usedSubstringIndex));
      }
      if (newText.length <= 11) {
        return TextEditingValue(
          text: newText.toString(),
          selection: TextSelection.collapsed(offset: selectionIndex),
        );
      } else {
        return TextEditingValue(
          text: newText.toString().substring(0, 11),
          selection: TextSelection.collapsed(offset: selectionIndex),
        );
      }
    } catch (E) {
      return const TextEditingValue(
        text: "",
      );
    }
  }
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
