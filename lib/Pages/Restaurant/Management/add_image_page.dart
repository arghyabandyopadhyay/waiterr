import 'package:waiterr/Modules/universal_module.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddImagePage extends StatefulWidget {
  final Function(String thumnailFilePath) callback;
  const AddImagePage({Key? key, required this.callback}) : super(key: key);
  @override
  State<AddImagePage> createState() => _AddImagePageState();
}

class _AddImagePageState extends State<AddImagePage> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  late DateTime now, today;
  var thumbnailTextField = TextEditingController();
  XFile? thumbnailFile;
  final focus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //Functions
  void _handleSubmitted() {
    final FormState form = _formKey.currentState ?? FormState();
    if (!form.validate()) {
      if (thumbnailTextField.text.isEmpty) {
        globalShowInSnackBar("Please upload an image to proceed!!", null,
            scaffoldMessengerKey, null, null);
      }
    } else {
      form.save();
      widget.callback(thumbnailTextField.text);
      Navigator.pop(context);
      FocusScope.of(context).unfocus();
    }
  }

  //Overrides
  @override
  void initState() {
    now = DateTime.now();
    today = DateTime(now.year, now.month, now.day);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 100);
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Upload Image",
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Row(children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.transparent,
                      child: Image.asset(
                        'assets/img/profile.png',
                        height: 30,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        enabled: false,
                        textCapitalization: TextCapitalization.words,
                        controller: thumbnailTextField,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Thumbnail",
                          helperText:
                              "If left empty, thumbnail will be automatically generated.",
                          contentPadding: EdgeInsets.only(
                              bottom: 10.0, left: 10.0, right: 10.0),
                        ),
                      ),
                    ),
                    if (thumbnailTextField.text.isEmpty)
                      IconButton(
                        icon: const Icon(Icons.insert_photo_outlined),
                        onPressed: () async {
                          thumbnailFile = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          );
                          setState(() {
                            thumbnailTextField.text = (thumbnailFile != null)
                                ? thumbnailFile!.path
                                : "";
                          });
                        },
                      )
                    else
                      IconButton(
                        icon: const Icon(Icons.remove_circle),
                        onPressed: () async {
                          setState(() {
                            thumbnailTextField.text = "";
                            thumbnailFile = null;
                          });
                        },
                      )
                  ]),
                  const SizedBox(
                    height: 8,
                  ),
                  sizedBoxSpace,
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: "uploadImageHeroTag",
          icon: const Icon(Icons.add),
          label: const Text(
            "Upload",
          ),
          onPressed: _handleSubmitted,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
