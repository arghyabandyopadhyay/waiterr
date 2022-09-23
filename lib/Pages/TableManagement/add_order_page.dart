import 'package:flutter/foundation.dart';
import 'package:waiterr/global_class.dart';
import 'package:waiterr/Model/customer_details_model.dart';
import 'package:waiterr/Model/running_order_model.dart';
import 'package:waiterr/Model/user_restraunt_allocation_model.dart';
import 'package:waiterr/Modules/api_fetch_module.dart';
import 'package:waiterr/Modules/universal_module.dart';
import 'package:waiterr/Pages/Restaurant/menu_page_all.dart';
import 'package:waiterr/widgets/chips.dart';
import 'package:waiterr/widgets/selection_cart.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import '../../theme.dart';

class AddOrder extends StatefulWidget {
  const AddOrder({Key? key}) : super(key: key);
  @override
  State<AddOrder> createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  bool _isLoadingTakeaway = false;
  bool _isLoadingAvailability = false;
  String? customerId;
  PersonData person = PersonData();
  var noOfPerson = TextEditingController();
  var salesPointNo = TextEditingController();
  late List<String?> _outlet;
  late List<String> _salesPoint;
  List<String> noOfPersonList = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10'
  ];
  late List<String> salesPointList;
  String? _selectedOutlet;
  String? _selectedSalesPoint;
  String _mobileStatus = "";
  int? _activeSalesPoint;
  int? _activeNoOfPerson;
  int _indexSelectedOutlet = -1;
  int _indexSelectedSalesPoint = -1;
  var phoneNumber = TextEditingController();
  var name = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final _IndNumberTextInputFormatter _phoneNumberFormatter =
      _IndNumberTextInputFormatter();
  List<OutletConfigurationModel>? outletConfiguration;
  //Functions
  Future<void> _handleSubmitted() async {
    if (_isLoadingTakeaway || _isLoading || _isLoadingAvailability) {
      globalShowInSnackBar(
          "Data loading taking place.", null, scaffoldMessengerKey, null, null);
    } else {
      final form = _formKey.currentState!;
      if (!form.validate() ||
          _indexSelectedSalesPoint < 0 ||
          _indexSelectedOutlet < 0) {
// Start validating on every change.
        if (_indexSelectedOutlet < 0) {
          globalShowInSnackBar(
              "Please Select Outlet!!", null, scaffoldMessengerKey, null, null);
        }
        if (_indexSelectedSalesPoint < 0) {
          globalShowInSnackBar("Please Select SalesPoint Type.!!", null,
              scaffoldMessengerKey, null, null);
        }
      } else {
        form.save();
        setState(() {
          _isLoadingAvailability = true;
        });
        try {
          await postForRunningOrders(
                  true, _selectedSalesPoint, salesPointNo.text, _selectedOutlet)
              .then((List<RunningOrderModel> rList) async => {
                    // if (phoneNumber.text.isNotEmpty)
                    //   {
                    //     if (_mobileStatus == "New")
                    //       await postCustomerDetails(name.text,
                    //               phoneNumber.text.replaceAll(" ", ""))
                    //           .catchError((e) {
                    //         if (kDebugMode) {
                    //           print(
                    //               "Server Error Occurred. Please Contact Us If The problem Persists.");
                    //         }
                    //       })
                    //     else
                    //       {
                    //         await getCustomerDetails(
                    //                 phoneNumber.text.replaceAll(" ", ""))
                    //             .then((CustomerDetailsModel value) => {
                    //                   if (value.name != "New")
                    //                     customerId = value.customerID,
                    //                 })
                    //             .catchError((e) {
                    //           globalShowInSnackBar(
                    //               "Server Error Occurred. Please Contact Us If The problem Persists.",
                    //               null,
                    //               scaffoldMessengerKey,
                    //               null,
                    //               null);
                    //         }),
                    //         await putCustomerDetails(customerId, name.text,
                    //                 phoneNumber.text.replaceAll(" ", ""))
                    //             .catchError((e) {
                    //           globalShowInSnackBar(
                    //               "Server Error Occurred. Please Contact Us If The problem Persists.",
                    //               null,
                    //               scaffoldMessengerKey,
                    //               null,
                    //               null);
                    //         })
                    //       },
                    //   },
                    setState(() {
                      _isLoadingAvailability = false;
                    }),
                    if (rList.isEmpty)
                      {
                        if (!FocusScope.of(context).hasPrimaryFocus)
                          {FocusScope.of(context).unfocus()},
                        Navigator.of(context).push(CupertinoPageRoute<void>(
                            builder: (context) => MenuPageAll(
                                addOrderData: RunningOrderModel(
                                    outletName: _selectedOutlet,
                                    salePointName: salesPointNo.text,
                                    name: name.text,
                                    mobileNo:
                                        phoneNumber.text.replaceAll(" ", ""),
                                    pax: int.parse(noOfPerson.text),
                                    salePointType: _selectedSalesPoint,
                                    masterFilter: name.text.replaceAll(" ", ""),
                                    waiterName: ""))))
                      }
                    else
                      {
                        globalShowInSnackBar(
                            "The Table selected is already Occupied, Please Select From Running Orders Page.",
                            null,
                            scaffoldMessengerKey,
                            null,
                            null)
                      },
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

  String? _validateTableNo(String? value) {
    if (value!.isEmpty) {
      return "Table No is Empty.!";
    }
    return null;
  }

  String? _validatePax(String? value) {
    if (value!.isNotEmpty) {
      try {
        int.parse(value);
        return null;
      } catch (E) {
        return "No Of Person should be a number.!";
      }
    } else {
      noOfPerson.text = "0";
      return null;
    }
  }

  String? _validateName(String? value) {
    //final nameExp = RegExp(r'^[A-Za-z ]+$');
    // if (value.isNotEmpty&&!nameExp.hasMatch(value)) {
    //   return "Robots not allowed.!";
    // }
    if (value!.isEmpty) name.text = "";
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    final phoneExp = RegExp(r'^\d\d\d\d\d\ \d\d\d\d\d$');
    if (value!.isNotEmpty && !phoneExp.hasMatch(value)) {
      return "Wrong Mobile No.!";
    } else if (value.isEmpty) {
      phoneNumber.text = "";
    }
    return null;
  }

  //Overrides
  @override
  void initState() {
    super.initState();
    outletConfiguration = UserClientAllocationData.outletConfiguration;
    List<String?> outletListOfClient = [];
    for (OutletConfigurationModel outletValues in outletConfiguration!) {
      outletListOfClient.add(outletValues.outletName);
    }
    salesPointList = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
      '11',
      '12',
      '13',
      '14',
      '15',
      '16',
      '17',
      '18',
      '19',
      '20',
      '21',
      '22',
      '23',
      '24',
      '25',
      '26',
      '27',
      '28',
      '29',
      '30',
      '31',
      '32',
      '33',
      '34',
      '35',
      '36',
      '37',
      '38',
      '39',
      '40',
      '41',
      '42',
      '43',
      '44',
      '45',
      '46',
      '47',
      '48',
      '49',
      '50',
      '51',
      '52',
      '53',
      '54',
      '55',
      '56',
      '57',
      '58',
      '59',
      '60'
    ];
    salesPointNo.text = "";
    phoneNumber.text = (UserDetail.userDetails.roleID == 1)
        ? "${UserDetail.userDetails.mobileNumber.substring(0, 5)} ${UserDetail.userDetails.mobileNumber.substring(5)}"
        : "";
    name.text = (UserDetail.userDetails.roleID == 1)
        ? UserDetail.userDetails.name!
        : "";
    _indexSelectedOutlet = 0;
    _indexSelectedSalesPoint = 0;
    _activeSalesPoint = -1;
    _selectedSalesPoint =
        outletConfiguration!.first.outletSalePoint!.split("|")[0];
    _selectedOutlet = outletListOfClient.first;
    _outlet = outletListOfClient;
    _salesPoint = outletConfiguration!
        .where((element) => element.outletName == _selectedOutlet)
        .first
        .outletSalePoint!
        .split("|");
  }

  @override
  Widget build(BuildContext context) {
    const cursorColor = GlobalTheme.primaryColor;
    const sizedBoxSpace = SizedBox(height: 24);
    bool userType = UserDetail.userDetails.roleID == 1;
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
                      "Add Order",
                      textScaleFactor: 1,
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
                                    textScaleFactor: 1,
                                    style: TextStyle(
                                        color: GlobalTheme.primaryText)),
                                SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _outlet.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Chips(
                                          item: _outlet[index],
                                          index: index,
                                          indexSelected: _indexSelectedOutlet,
                                          onSelected: (value) {
                                            setState(() {
                                              _indexSelectedOutlet = index;
                                              _selectedOutlet = _outlet[index];
                                              _salesPoint = outletConfiguration!
                                                  .where((element) =>
                                                      element.outletName ==
                                                      _selectedOutlet)
                                                  .first
                                                  .outletSalePoint!
                                                  .split("|");
                                              if (value) {
                                                salesPointNo.text = "";
                                                _activeSalesPoint = -1;
                                                _indexSelectedSalesPoint = 0;
                                                _isLoadingTakeaway = false;
                                              }
                                              //get list of table
                                            });
                                          });
                                    },
                                  ),
                                ),
                                const Text("Sales Point:",
                                    textScaleFactor: 1,
                                    style: TextStyle(
                                        color: GlobalTheme.primaryText)),
                                SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    itemCount: _salesPoint.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Chips(
                                          item: _salesPoint[index],
                                          index: index,
                                          indexSelected:
                                              _indexSelectedSalesPoint,
                                          onSelected: (value) async {
                                            setState(() {
                                              _indexSelectedSalesPoint = index;
                                              _selectedSalesPoint =
                                                  _salesPoint[index];
                                              if (value) {
                                                salesPointNo.text = "";
                                                _activeSalesPoint = -1;
                                                if (_isLoadingTakeaway) {
                                                  _isLoadingTakeaway = false;
                                                }
                                              }
                                              //get list of table
                                            });
                                            if (_selectedSalesPoint ==
                                                "TAKE-AWAY") {
                                              Connectivity connectivity =
                                                  Connectivity();
                                              try {
                                                await connectivity
                                                    .checkConnectivity()
                                                    .then((value) async => {
                                                          if (value !=
                                                              ConnectivityResult
                                                                  .none)
                                                            {
                                                              setState(() {
                                                                _isLoadingTakeaway =
                                                                    true;
                                                              }),
                                                              await postForTakeAway(
                                                                      _selectedOutlet)
                                                                  .then((String
                                                                          a) =>
                                                                      {
                                                                        if (a.isNotEmpty &&
                                                                            _isLoadingTakeaway)
                                                                          {
                                                                            salesPointNo.text =
                                                                                a,
                                                                            _activeSalesPoint =
                                                                                -1
                                                                          },
                                                                        setState(
                                                                            () {
                                                                          _isLoadingTakeaway =
                                                                              false;
                                                                        }),
                                                                      }),
                                                            }
                                                          else
                                                            {
                                                              setState(() {
                                                                _isLoadingTakeaway =
                                                                    false;
                                                              }),
                                                              globalShowInSnackBar(
                                                                  "Please Check Internet Connection",
                                                                  null,
                                                                  scaffoldMessengerKey,
                                                                  null,
                                                                  null),
                                                            }
                                                        });
                                              } catch (E) {
                                                if (_isLoadingTakeaway) {
                                                  setState(() {
                                                    _isLoadingTakeaway = false;
                                                  });
                                                  globalShowInSnackBar(
                                                      "Something went wrong.",
                                                      null,
                                                      scaffoldMessengerKey,
                                                      null,
                                                      null);
                                                }
                                              }
                                            }
                                          });
                                    },
                                  ),
                                ),
                                sizedBoxSpace,
                                TextFormField(
                                  enabled: !userType,
                                  cursorColor: cursorColor,
                                  controller: phoneNumber,
                                  style: const TextStyle(),
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    suffixIcon: _isLoading
                                        ? Container(
                                            margin: const EdgeInsets.all(10),
                                            child:
                                                const CircularProgressIndicator(
                                              strokeWidth: 3,
                                            ),
                                          )
                                        : Text("$_mobileStatus  ",
                                            textScaleFactor: 1,
                                            style: const TextStyle()),
                                    suffixIconConstraints: const BoxConstraints(
                                        maxHeight: 40, maxWidth: 40),
                                    labelText: "Mobile",
                                    prefixText: '+91 ',
                                    hintStyle: const TextStyle(
                                        color: GlobalTheme.primaryText),
                                    labelStyle: const TextStyle(
                                        color: GlobalTheme.primaryText),
                                    focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        borderSide: BorderSide(
                                            color: GlobalTheme.primaryColor)),
                                    contentPadding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  onChanged: (String value) async {
                                    if (value.length < 11 && _isLoading) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                    if (value.length < 11 &&
                                        _mobileStatus == "New") {
                                      setState(() {
                                        _mobileStatus = "";
                                      });
                                    }
                                    if (value.length == 11) {
                                      //Timer(Duration(seconds: 5),handleTimeout);
                                      Connectivity connectivity =
                                          Connectivity();
                                      try {
                                        await connectivity
                                            .checkConnectivity()
                                            .then((value) async => {
                                                  if (value !=
                                                      ConnectivityResult.none)
                                                    {
                                                      setState(() {
                                                        _isLoading = true;
                                                      }),
                                                      await getCustomerDetails(
                                                              phoneNumber.text
                                                                  .replaceAll(
                                                                      " ", ""))
                                                          .then(
                                                              (CustomerDetailsModel
                                                                      value) =>
                                                                  {
                                                                    setState(
                                                                        () {
                                                                      _isLoading =
                                                                          false;
                                                                    }),
                                                                    if (value
                                                                            .name ==
                                                                        "New")
                                                                      {
                                                                        _mobileStatus =
                                                                            "New"
                                                                      }
                                                                    else
                                                                      {
                                                                        customerId =
                                                                            value.customerID,
                                                                        if (name
                                                                            .text
                                                                            .isEmpty)
                                                                          {
                                                                            name.text =
                                                                                value.name!
                                                                          }
                                                                      }
                                                                  })
                                                    }
                                                  else
                                                    {
                                                      setState(() {
                                                        _isLoading = false;
                                                      }),
                                                      globalShowInSnackBar(
                                                          "Please Check Internet Connection",
                                                          null,
                                                          scaffoldMessengerKey,
                                                          null,
                                                          null),
                                                    }
                                                });
                                      } catch (E) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        globalShowInSnackBar(
                                            "Something went wrong.",
                                            null,
                                            scaffoldMessengerKey,
                                            null,
                                            null);
                                      }
                                    }
                                  },
                                  onSaved: (value) {
                                    person.phoneNumber = value;
                                  },
                                  validator: _validatePhoneNumber,
                                  // TextInputFormatters are applied in sequence.
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                    // Fit the validating format.
                                    _phoneNumberFormatter,
                                  ],
                                ),
                                sizedBoxSpace,
                                TextFormField(
                                  enabled: !userType,
                                  textCapitalization: TextCapitalization.words,
                                  controller: name,
                                  cursorColor: cursorColor,
                                  style: const TextStyle(),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Name",
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
                                const Text("Table No",
                                    textScaleFactor: 1,
                                    style: TextStyle(
                                        color: GlobalTheme.primaryText)),
                                //Options for Table No
                                SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    itemCount: salesPointList.length,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return SelectionCard(
                                          item: salesPointList[index],
                                          active: index == _activeSalesPoint
                                              ? true
                                              : false,
                                          onTap: () {
                                            setState(() {
                                              _activeSalesPoint = index;
                                              salesPointNo.text =
                                                  salesPointList[index];
                                              FocusScopeNode currentFocus =
                                                  FocusScope.of(context);
                                              if (!currentFocus
                                                  .hasPrimaryFocus) {
                                                currentFocus.unfocus();
                                              }
                                            });
                                          });
                                    },
                                  ),
                                ),
                                TextFormField(
                                  controller: salesPointNo,
                                  cursorColor: cursorColor,
                                  style: const TextStyle(),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintStyle: const TextStyle(
                                        color: GlobalTheme.primaryText),
                                    labelStyle: const TextStyle(
                                        color: GlobalTheme.primaryText),
                                    suffixIcon: _isLoadingTakeaway
                                        ? Container(
                                            margin: const EdgeInsets.all(10),
                                            child:
                                                const CircularProgressIndicator(
                                              strokeWidth: 3,
                                            ),
                                          )
                                        : null,
                                    suffixIconConstraints: const BoxConstraints(
                                        maxHeight: 40, maxWidth: 40),
                                    focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: GlobalTheme.primaryColor)),
                                    contentPadding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                  ),
                                  onSaved: (value) {
                                    person.salesPointNo = value;
                                  },
                                  validator: _validateTableNo,
                                ),
                                sizedBoxSpace,
                                const Text("No of Persons",
                                    textScaleFactor: 1,
                                    style: TextStyle(
                                        color: GlobalTheme.primaryText)),
                                const SizedBox(),
                                //Options for No of Persons
                                SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    itemCount: noOfPersonList.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return SelectionCard(
                                          item: noOfPersonList[index],
                                          active: index == _activeNoOfPerson
                                              ? true
                                              : false,
                                          onTap: () {
                                            setState(() {
                                              _activeNoOfPerson = index;
                                              noOfPerson.text =
                                                  noOfPersonList[index];
                                              FocusScopeNode currentFocus =
                                                  FocusScope.of(context);
                                              if (!currentFocus
                                                  .hasPrimaryFocus) {
                                                currentFocus.unfocus();
                                              }
                                            });
                                          });
                                    },
                                  ),
                                ),
                                TextFormField(
                                  cursorColor: cursorColor,
                                  controller: noOfPerson,
                                  style: const TextStyle(),
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintStyle: TextStyle(
                                        color: GlobalTheme.primaryText),
                                    labelStyle: TextStyle(
                                        color: GlobalTheme.primaryText),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: GlobalTheme.primaryColor)),
                                    contentPadding: EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                  ),
                                  maxLines: 1,
                                  onSaved: (value) {
                                    person.pax = value;
                                  },
                                  validator: _validatePax,
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
                  Icons.restaurant_menu,
                  color: GlobalTheme.floatingButtonText,
                ),
                label: const Text(
                  "Menu",
                  textScaleFactor: 1,
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
