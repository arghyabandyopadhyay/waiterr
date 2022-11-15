import 'package:flutter/foundation.dart';
import 'package:waiterr/Model/user_details_model.dart';
import 'package:waiterr/global_class.dart';
import 'package:waiterr/Modules/api_fetch_module.dart';
import 'package:waiterr/Modules/universal_module.dart';
import 'package:waiterr/widgets/chips.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import '../../../Model/outlet_configuration_model.dart';
import '../../../theme.dart';

class AddWaiterPage extends StatefulWidget {
  const AddWaiterPage({Key? key}) : super(key: key);
  @override
  State<AddWaiterPage> createState() => _AddWaiterPageState();
}

class _AddWaiterPageState extends State<AddWaiterPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  bool _isLoadingTakeaway = false;
  bool _isLoadingAvailability = false;
  String? customerId;
  PersonData person = PersonData();
  var noOfPerson = TextEditingController();
  var salesPointNo = TextEditingController();
  late OutletConfigurationModel _selectedOutlet;
  String _mobileStatus = "";
  int _indexSelectedOutlet = -1;
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
          await postForUserClientAllocation(
                  customerId ?? "", _selectedOutlet.id)
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

    outletConfiguration = [];
    if (UserClientAllocationData.outletConfiguration != null) {
      UserClientAllocationData.outletConfiguration?.forEach((element) {
        outletConfiguration.add(element);
      });
    }
    salesPointNo.text = "";
    phoneNumber.text = "";
    name.text = "";
    _indexSelectedOutlet = 0;
    _selectedOutlet = outletConfiguration.first;
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
                      "Add Waiter",
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
                                              if (value) {
                                                salesPointNo.text = "";
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
                                                      await getUserDetail(
                                                              phoneNumber.text
                                                                  .replaceAll(
                                                                      " ", ""))
                                                          .then(
                                                              (UserDetailsModel
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
                                                                            value.id,
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
                                  enabled: false,
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
                  Icons.add,
                ),
                label: const Text(
                  "Add",
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
