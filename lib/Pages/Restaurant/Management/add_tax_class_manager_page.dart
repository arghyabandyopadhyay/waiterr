import 'package:flutter/foundation.dart';
import 'package:waiterr/global_class.dart';
import 'package:waiterr/Model/user_restraunt_allocation_model.dart';
import 'package:waiterr/Modules/api_fetch_module.dart';
import 'package:waiterr/Modules/universal_module.dart';
import 'package:waiterr/widgets/chips.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import '../../../theme.dart';

class AddTaxClassPage extends StatefulWidget {
  const AddTaxClassPage({Key? key}) : super(key: key);
  @override
  State<AddTaxClassPage> createState() => _AddTaxClassPageState();
}

class _AddTaxClassPageState extends State<AddTaxClassPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  bool _isLoadingTakeaway = false;
  bool _isLoadingAvailability = false;
  TextEditingController name = TextEditingController();
  TextEditingController rate = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  //Functions
  Future<void> _handleSubmitted() async {
    if (_isLoadingTakeaway || _isLoading || _isLoadingAvailability) {
      globalShowInSnackBar(
          "Data loading taking place.", null, scaffoldMessengerKey, null, null);
    } else if (name.text.isEmpty || rate.text.isEmpty) {
      globalShowInSnackBar(
          "Please fill all the fields", null, scaffoldMessengerKey, null, null);
    } else {
      final form = _formKey.currentState!;
      if (!form.validate()) {
        // Start validating on every change.
      } else {
        form.save();
        setState(() {
          _isLoadingAvailability = true;
        });
        try {
          await postForTaxClassAddition(name.text, double.parse(rate.text))
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

  //Overrides
  @override
  void initState() {
    super.initState();
    name.text = "";
    rate.text = "";
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
                      "Add Tax Class",
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
                                sizedBoxSpace,
                                TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  controller: name,
                                  cursorColor: cursorColor,
                                  style: const TextStyle(),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Tax Class",
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
                                  validator: _validateName,
                                ),
                                sizedBoxSpace,
                                TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  controller: rate,
                                  cursorColor: cursorColor,
                                  style: const TextStyle(),
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Tax Rate",
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
