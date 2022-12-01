import 'package:flutter/foundation.dart';
import 'package:waiterr/Model/qr_json_model.dart';
import 'package:waiterr/global_class.dart';
import 'package:waiterr/Model/customer_details_model.dart';
import 'package:waiterr/Model/running_order_model.dart';
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
import '../../Model/outlet_configuration_model.dart';
import '../../theme.dart';

class AddOrder extends StatefulWidget {
  final QRJSONModel? qrjsonModel;
  final bool isThroughQr;
  const AddOrder({Key? key, this.qrjsonModel, required this.isThroughQr})
      : super(key: key);
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
  late OutletConfigurationModel _selectedOutlet;
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
  List<OutletConfigurationModel> outletConfiguration = [];
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
          String dataSource = "";
          await postForRunningOrders(true, true, _selectedSalesPoint,
                  salesPointNo.text, _selectedOutlet.outletName, null)
              .then((List<RunningOrderModel> rList) async => {
                    if (phoneNumber.text.isNotEmpty)
                      {
                        if (_mobileStatus == "New")
                          await postCustomerDetails(name.text,
                                  phoneNumber.text.replaceAll(" ", ""))
                              .catchError((e) {
                            if (kDebugMode) {
                              print(
                                  "Server Error Occurred. Please Contact Us If The problem Persists.");
                            }
                          })
                        else
                          {
                            await getCustomerDetails(
                                    phoneNumber.text.replaceAll(" ", ""))
                                .then((CustomerDetailsModel value) => {
                                      if (value.name != "New" &&
                                          value.dataSource == "CustomerBank")
                                        customerId = value.customerId,
                                      dataSource = value.dataSource
                                    })
                                .catchError((e) {
                              globalShowInSnackBar(
                                  "Server Error Occurred. Please Contact Us If The problem Persists.",
                                  null,
                                  scaffoldMessengerKey,
                                  null,
                                  null);
                            }),
                            if (customerId != null &&
                                dataSource == "CustomerBank")
                              await putCustomerDetails(CustomerDetailsModel(
                                  customerId: customerId!,
                                  name: name.text,
                                  mobileNumber:
                                      phoneNumber.text.replaceAll(" ", ""),
                                  dataSource: "CustomerBank"))
                          },
                      },
                    setState(() {
                      _isLoadingAvailability = false;
                    }),
                    if (rList.isEmpty)
                      {
                        print(widget.isThroughQr
                            ? UserDetail.userDetails.id
                            : dataSource == "UserDetails"
                                ? customerId ?? ""
                                : ""),
                        if (!FocusScope.of(context).hasPrimaryFocus)
                          {FocusScope.of(context).unfocus()},
                        Navigator.of(context).push(CupertinoPageRoute<void>(
                            builder: (context) => MenuPageAll(
                                  addOrderData: RunningOrderModel(
                                      id: "",
                                      amount: 0,
                                      outletName: _selectedOutlet.outletName,
                                      outletId: _selectedOutlet.id,
                                      salePointName: salesPointNo.text,
                                      name: name.text,
                                      billPrinted: false,
                                      mobileNo:
                                          phoneNumber.text.replaceAll(" ", ""),
                                      userId: widget.isThroughQr
                                          ? UserDetail.userDetails.id
                                          : dataSource == "UserDetails"
                                              ? customerId ?? ""
                                              : "",
                                      pax: int.parse(noOfPerson.text),
                                      salePointType: _selectedSalesPoint,
                                      masterFilter:
                                          name.text.replaceAll(" ", ""),
                                      waiterMobileNumber:
                                          UserDetail.userDetails.mobileNumber,
                                      isTerminated: false,
                                      waiterName: UserDetail.userDetails.name),
                                  isWaiter: !widget.isThroughQr,
                                )))
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
    if (widget.isThroughQr) {
      outletConfiguration = [
        OutletConfigurationModel(
            widget.qrjsonModel!.restaurantId,
            widget.qrjsonModel!.outletName,
            widget.qrjsonModel!.outletSalespointType)
      ];
      salesPointList = [widget.qrjsonModel!.table];
      _selectedSalesPoint = widget.qrjsonModel!.table;
      salesPointNo.text = widget.qrjsonModel!.table;
      phoneNumber.text =
          "${UserDetail.userDetails.mobileNumber.substring(0, 5)} ${UserDetail.userDetails.mobileNumber.substring(5)}";
      name.text = UserDetail.userDetails.name ?? "";
    } else {
      outletConfiguration = [];
      if (UserClientAllocationData.outletConfiguration != null) {
        UserClientAllocationData.outletConfiguration?.forEach((element) {
          outletConfiguration.add(element);
        });
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
      phoneNumber.text = "";
      name.text = "";
    }
    _indexSelectedOutlet = 0;
    _indexSelectedSalesPoint = 0;
    _activeSalesPoint = -1;
    _selectedSalesPoint =
        outletConfiguration.first.outletSalePoint!.split("|")[0];
    _selectedOutlet = outletConfiguration.first;
    _salesPoint = outletConfiguration
        .where((element) => element == _selectedOutlet)
        .first
        .outletSalePoint!
        .split("|");
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
                      "Add Order",
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
                                const Text("Outlets:"),
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
                                              _salesPoint = outletConfiguration
                                                  .where((element) =>
                                                      element ==
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
                                const Text("Sales Point:"),
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
                                                                      _selectedOutlet
                                                                          .id)
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
                                  enabled: !widget.isThroughQr,

                                  controller: phoneNumber,
                                  style: const TextStyle(),
                                  decoration: InputDecoration(
                                    suffixIcon: _isLoading
                                        ? Container(
                                            margin: const EdgeInsets.all(10),
                                            child:
                                                const CircularProgressIndicator(
                                              strokeWidth: 3,
                                            ),
                                          )
                                        : Text("$_mobileStatus  ",
                                            style: const TextStyle()),
                                    suffixIconConstraints: const BoxConstraints(
                                        maxHeight: 40, maxWidth: 40),
                                    labelText: "Mobile",
                                    prefixText: '+91 ',
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
                                                                        if (value.dataSource ==
                                                                            "UserDetails")
                                                                          customerId =
                                                                              value.customerId,
                                                                        if (name
                                                                            .text
                                                                            .isEmpty)
                                                                          {
                                                                            name.text =
                                                                                value.name
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
                                  enabled: !widget.isThroughQr,
                                  textCapitalization: TextCapitalization.words,
                                  controller: name,
                                  style: const TextStyle(),
                                  decoration: const InputDecoration(
                                    labelText: "Name",
                                  ),
                                  onSaved: (value) {
                                    person.name = value;
                                  },
                                  validator: _validateName,
                                ),
                                sizedBoxSpace,
                                const Text("Table No"),
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
                                          active: widget.isThroughQr
                                              ? true
                                              : (index == _activeSalesPoint
                                                  ? true
                                                  : false),
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
                                  enabled: !widget.isThroughQr,
                                  style: const TextStyle(),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
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
                                    // focusedBorder: const UnderlineInputBorder(
                                    //     borderSide: BorderSide(
                                    //         color: GlobalTheme.waiterrPrimaryColor)),
                                    contentPadding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                  ),
                                  onSaved: (value) {
                                    person.salesPointNo = value;
                                  },
                                  validator: _validateTableNo,
                                ),
                                sizedBoxSpace,
                                const Text("No of Persons"),
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
                                  controller: noOfPerson,
                                  style: const TextStyle(),
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    // focusedBorder: UnderlineInputBorder(
                                    //     borderSide: BorderSide(
                                    //         color: GlobalTheme.waiterrPrimaryColor)),
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
              backgroundColor: GlobalTheme.tint,
              floatingActionButton: FloatingActionButton.extended(
                icon: const Icon(
                  Icons.restaurant_menu,
                ),
                label: const Text(
                  "Menu",
                  style: TextStyle(
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
