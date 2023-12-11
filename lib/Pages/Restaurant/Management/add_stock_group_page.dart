import 'package:waiterr/global_class.dart';
import 'package:waiterr/Modules/api_fetch_module.dart';
import 'package:waiterr/Modules/universal_module.dart';
import 'package:waiterr/widgets/chips.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:waiterr/widgets/circular_image_widget.dart';
import '../../../Model/filter_item_model.dart';
import '../../../Model/outlet_configuration_model.dart';
import '../../../theme.dart';

class AddStockGroupPage extends StatefulWidget {
  final FilterItemModel? filterItem;
  final bool isEdit;
  const AddStockGroupPage({Key? key, required this.isEdit, this.filterItem})
      : super(key: key);
  @override
  State<AddStockGroupPage> createState() => _AddStockGroupPageState();
}

class _AddStockGroupPageState extends State<AddStockGroupPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final bool _isLoading = false;
  bool _isLoadingTakeaway = false;
  bool _isLoadingAvailability = false;
  late OutletConfigurationModel _selectedOutlet;
  int _indexSelectedOutlet = -1;
  var name = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  List<OutletConfigurationModel> outletConfiguration = [];
  //Functions
  Future<void> _handleSubmitted() async {
    if (_isLoadingTakeaway || _isLoading || _isLoadingAvailability) {
      globalShowInSnackBar(
          "Data loading taking place.", null, scaffoldMessengerKey, null, null);
    } else {
      final form = _formKey.currentState!;
      if (!form.validate() || _indexSelectedOutlet < 0) {
        // Start validating on every change.
        if (_indexSelectedOutlet < 0) {
          globalShowInSnackBar(
              "Please Select Outlet!!", null, scaffoldMessengerKey, null, null);
        }
      } else {
        form.save();
        setState(() {
          _isLoadingAvailability = true;
        });
        try {
          await postForMenuGroupItemModification(
                  name.text,
                  _selectedOutlet.id,
                  widget.filterItem?.id ?? "",
                  widget.filterItem?.image ?? "",
                  widget.isEdit ? "Edit" : "Create")
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

    outletConfiguration = [];
    if (UserClientAllocationData.outletConfiguration != null) {
      UserClientAllocationData.outletConfiguration?.forEach((element) {
        outletConfiguration.add(element);
      });
    }
    if (widget.isEdit) {
      name.text = widget.filterItem!.stockGroup ?? "";
      _selectedOutlet = outletConfiguration
          .where((element) => widget.filterItem!.outletId == element.id)
          .first;
      _indexSelectedOutlet = outletConfiguration.indexOf(_selectedOutlet);
    } else {
      name.text = "";
      _indexSelectedOutlet = 0;
      _selectedOutlet = outletConfiguration.first;
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
                      "${widget.isEdit ? "Edit" : "Add"} Stock Group",
                      textAlign: TextAlign.left,
                      style: GlobalTextStyles.waiterrTextStyleAppBar,
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text("Outlets:"),
                                            SizedBox(
                                              height: 50,
                                              child: widget.isEdit
                                                  ? ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: 1,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Chips(
                                                            item: widget
                                                                .filterItem!
                                                                .outletName,
                                                            index: 0,
                                                            indexSelected: 0,
                                                            onSelected:
                                                                (value) {
                                                              setState(() {});
                                                            });
                                                      })
                                                  : ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          outletConfiguration
                                                              .length,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Chips(
                                                            item:
                                                                outletConfiguration[
                                                                        index]
                                                                    .outletName,
                                                            index: index,
                                                            indexSelected:
                                                                _indexSelectedOutlet,
                                                            onSelected:
                                                                (value) {
                                                              setState(() {
                                                                _indexSelectedOutlet =
                                                                    index;
                                                                _selectedOutlet =
                                                                    outletConfiguration[
                                                                        index];
                                                                if (value) {
                                                                  _isLoadingTakeaway =
                                                                      false;
                                                                }
                                                                //get list of table
                                                              });
                                                            });
                                                      },
                                                    ),
                                            ),
                                            sizedBoxSpace,
                                            TextFormField(
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              controller: name,
                                              style: const TextStyle(),
                                              decoration: const InputDecoration(
                                                labelText: "Stock Group",
                                              ),
                                              validator: _validateName,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: CircularImageWidget(
                                        radius: 50,
                                        size: const Size(100, 100),
                                        isImageUploader: true,
                                        imageUrl:
                                            widget.filterItem?.image ?? "",
                                        imageId: widget.filterItem?.id ?? "",
                                        directory: "StockGroupPictures",
                                        updateUrl: (imageUrl) async {
                                          widget.filterItem?.image = imageUrl;
                                          if (widget.isEdit) {
                                            await postForMenuGroupItemModification(
                                                name.text,
                                                _selectedOutlet.id,
                                                widget.filterItem?.id ?? "",
                                                widget.filterItem?.image ?? "",
                                                "Edit");
                                          }
                                          setState(() {});
                                        },
                                        scaffoldMessengerKey:
                                            scaffoldMessengerKey,
                                      ),
                                    ),
                                  ],
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
