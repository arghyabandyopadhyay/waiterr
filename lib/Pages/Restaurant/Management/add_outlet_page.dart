import 'package:flutter/foundation.dart';
import 'package:waiterr/Model/outlet_configuration_model.dart';
import 'package:waiterr/Modules/api_fetch_module.dart';
import 'package:waiterr/Modules/universal_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:waiterr/global_class.dart';
import '../../../theme.dart';

class AddOutletPage extends StatefulWidget {
  final OutletConfigurationModel? outletDetail;
  final bool isEdit;
  const AddOutletPage({Key? key, required this.isEdit, this.outletDetail})
      : super(key: key);
  @override
  State<AddOutletPage> createState() => _AddOutletPageState();
}

class _AddOutletPageState extends State<AddOutletPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final bool _isLoading = false;
  final bool _isLoadingTakeaway = false;
  bool _isLoadingAvailability = false;
  TextEditingController name = TextEditingController();
  TextEditingController salePointName = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  //Functions
  Future<void> _handleSubmitted() async {
    if (_isLoadingTakeaway || _isLoading || _isLoadingAvailability) {
      globalShowInSnackBar(
          "Data loading taking place.", null, scaffoldMessengerKey, null, null);
    } else if (name.text.isEmpty || salePointName.text.isEmpty) {
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
          await postForOutletModification(
                  name.text,
                  salePointName.text,
                  widget.isEdit
                      ? widget.outletDetail!.id
                      : UserDetail.userDetails.id,
                  widget.isEdit ? "Update" : "Create")
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
    if (widget.isEdit) {
      name.text = widget.outletDetail!.outletName;
      salePointName.text = widget.outletDetail!.outletSalePoint ?? "";
    } else {
      name.text = "";
      salePointName.text = "";
    }
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
                      "Add Outlet",
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.displayLarge,
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
                                sizedBoxSpace,
                                TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  controller: name,
                                  style: const TextStyle(),
                                  decoration: const InputDecoration(
                                    labelText: "Name",
                                  ),
                                  validator: _validateName,
                                ),
                                sizedBoxSpace,
                                TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  controller: salePointName,
                                  style: const TextStyle(),
                                  keyboardType: TextInputType.name,
                                  decoration: const InputDecoration(
                                    labelText: "Sale points",
                                    hintText: "Separate sale points by '|'.",
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
              backgroundColor: GlobalTheme.tint,
              floatingActionButton: FloatingActionButton.extended(
                icon: Icon(
                  widget.isEdit ? Icons.edit : Icons.add,
                ),
                label: Text(
                  widget.isEdit ? "Edit" : "Add",
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
