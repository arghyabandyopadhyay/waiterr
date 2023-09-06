import 'dart:async';
import 'dart:io';

import 'package:waiterr/Modules/api_fetch_module.dart';
import 'package:waiterr/Modules/universal_module.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import '../../global_class.dart';
import '../../theme.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' show join;

class ProfilePage extends StatefulWidget {
  final List<List<dynamic>>? data;
  const ProfilePage({Key? key, this.data}) : super(key: key);
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  var phoneNumber = TextEditingController();
  var name = TextEditingController();
  final _IndNumberTextInputFormatter _phoneNumberFormatter =
      _IndNumberTextInputFormatter();
  _ProfilePageState() {
    name.text = UserDetail.userDetails.name!;
    phoneNumber.text =
        "${UserDetail.userDetails.mobileNumber.substring(0, 5)} ${UserDetail.userDetails.mobileNumber.substring(5)}";
  }
  XFile? _imageFile;
  dynamic _pickImageError;
  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  // final TextEditingController maxWidthController = TextEditingController();
  // final TextEditingController maxHeightController = TextEditingController();
  // final TextEditingController qualityController = TextEditingController();
  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  Widget _previewImage() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      if (kIsWeb) {
        // Why network?
        // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
        return Image.network(_imageFile!.path);
      } else {
        return Image.file(File(_imageFile!.path));
      }
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  void _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 100,
        maxHeight: 100,
        imageQuality: 10,
      );
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    // maxWidthController.dispose();
    // maxHeightController.dispose();
    // qualityController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value!.isEmpty) {
      return "Value is empty!";
    }
    final nameExp = RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value)) {
      return "Robots not allowed.!";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
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
              backgroundColor: GlobalTheme.tint,
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
              body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "My Profile",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Flexible(
                        child: Container(
                            height: MediaQuery.of(context).size.height,
                            padding: const EdgeInsets.only(top: 10),
                            decoration: GlobalTheme.waiterrAppBarBoxDecoration,
                            child: ListView(
                              shrinkWrap: true,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              physics: const BouncingScrollPhysics(),
                              children: <Widget>[
                                const SizedBox(
                                  height: 15,
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
                                          children: [
                                            TextFormField(
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              controller: name,
                                              validator: _validateName,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              decoration: const InputDecoration(
                                                labelText: "Name",
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 24,
                                            ),
                                            TextFormField(
                                              enabled: false,
                                              controller: phoneNumber,
                                              style: const TextStyle(),
                                              decoration: const InputDecoration(
                                                labelText: "Mobile",
                                                prefixText: '+91 ',
                                              ),
                                              keyboardType: TextInputType.phone,
                                              // TextInputFormatters are applied in sequence.
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                // Fit the validating format.
                                                _phoneNumberFormatter,
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Colors.transparent,
                                          child: ClipOval(
                                            child: UserDetail.userDetails
                                                            .profileUrl !=
                                                        null &&
                                                    UserDetail.userDetails
                                                            .profileUrl !=
                                                        ""
                                                ? CachedNetworkImage(
                                                    imageUrl: UserDetail
                                                        .userDetails
                                                        .profileUrl!,
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      height: 100,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover,
                                                          //colorFilter:ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                                                        ),
                                                      ),
                                                    ),
                                                    placeholder: (context,
                                                            url) =>
                                                        SizedBox(
                                                            width:
                                                                double.infinity,
                                                            child: Center(
                                                              child: Shimmer
                                                                  .fromColors(
                                                                baseColor: Colors
                                                                    .grey[300]!
                                                                    .withOpacity(
                                                                        0.3),
                                                                highlightColor:
                                                                    Colors
                                                                        .white,
                                                                enabled: true,
                                                                child:
                                                                    Container(
                                                                  width: 100,
                                                                  height: 100,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            )),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  )
                                                : Image(
                                                    height: 100,
                                                    width: 100,
                                                    fit: BoxFit.fitHeight,
                                                    image: Image.asset(
                                                      'assets/img/profile.png',
                                                    ).image),
                                          )),
                                    ),
                                    // Badge(
                                    //     position: BadgePosition.bottomEnd(bottom: 2, end: 6),
                                    //     animationDuration: Duration(milliseconds: 300),
                                    //     animationType: BadgeAnimationType.slide,
                                    //     badgeContent: IconButton(
                                    //       padding: EdgeInsets.all(0),
                                    //       constraints: BoxConstraints(maxWidth: 30),
                                    //       icon:Icon(Icons.camera_alt,color: Colors.white),
                                    //       onPressed: ()async {
                                    //       showDialog(
                                    //           context: context,
                                    //           builder: (context) {
                                    //             return AlertDialog(
                                    //               shape: RoundedRectangleBorder(
                                    //                   borderRadius:
                                    //                   BorderRadius.circular(20.0)), //
                                    //               title: Text('Profile photo',style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                                    //               content: Container(
                                    //                 height: 175,
                                    //                 width: 100,
                                    //                 child: ListView(
                                    //                   shrinkWrap: true,
                                    //                   children: <Widget>[
                                    //                     ListTile(
                                    //                       leading:Icon(Icons.photo_library),
                                    //                       title: const Text('Gallery',),
                                    //                       onTap: () {
                                    //                         Navigator.of(context).pop();
                                    //                         _onImageButtonPressed(ImageSource.gallery, context: context);
                                    //                       },
                                    //                     ),
                                    //                     ListTile(
                                    //                       leading:Icon(Icons.camera_alt),
                                    //                       title: const Text('Camera',),
                                    //                       onTap: () {
                                    //                         Navigator.of(context).pop();
                                    //                         _onImageButtonPressed(ImageSource.camera, context: context);
                                    //                       },
                                    //                     ),
                                    //                     ListTile(
                                    //                         leading:Icon(Icons.delete),
                                    //                         title: const Text('Remove Photo',),
                                    //                         onTap: () {
                                    //                           Navigator.of(context).pop();
                                    //                         }),
                                    //                   ],
                                    //                 ),
                                    //               ),
                                    //             );
                                    //           });
                                    //     },),
                                    //     badgeColor: Colors.black,
                                    //     child: Container(
                                    //       width: MediaQuery.of(context).size.width*0.3,
                                    //       child: CircleAvatar(
                                    //           radius: 50,
                                    //           backgroundColor: Colors.transparent,
                                    //           child: ClipOval(
                                    //             child: UserDetail.userProfileImageUrl!=null&&UserDetail.userProfileImageUrl!=""?CachedNetworkImage(
                                    //               imageUrl: UserDetail.userProfileImageUrl,
                                    //               imageBuilder: (context, imageProvider) => Container(
                                    //                 height: 100,
                                    //                 width: 100,
                                    //                 decoration: BoxDecoration(
                                    //                   image: DecorationImage(
                                    //                     image: imageProvider,
                                    //                     fit: BoxFit.cover,
                                    //                     //colorFilter:ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                                    //                   ),
                                    //                 ),
                                    //               ),
                                    //               placeholder: (context, url) => Container(
                                    //                   width: double.infinity,
                                    //                   child: Center(
                                    //                     child: Shimmer.fromColors(
                                    //                       baseColor: Colors.grey[300].withOpacity(0.3),
                                    //                       highlightColor: Colors.white,
                                    //                       enabled: true,
                                    //                       child: Container(
                                    //                         width:100,
                                    //                         height: 100,
                                    //                         color: Colors.white,
                                    //                       ),
                                    //                     ),
                                    //                   )
                                    //               ),
                                    //               errorWidget: (context, url, error) => Icon(Icons.error),
                                    //             ):Image(height:100,width:100,fit: BoxFit.fitHeight,image: Image.asset(
                                    //               'assets/img/profile.png',
                                    //             ).image)
                                    //             ,)
                                    //       ),
                                    //     )),
                                  ],
                                ),
                                // Center(
                                //   child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
                                //       ? FutureBuilder<void>(
                                //     future: retrieveLostData(),
                                //     builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                                //       switch (snapshot.connectionState) {
                                //         case ConnectionState.none:
                                //         case ConnectionState.waiting:
                                //           return const Text(
                                //             'You have not yet picked an image.',
                                //             textAlign: TextAlign.center,
                                //           );
                                //         case ConnectionState.done:
                                //           return _previewImage();
                                //         default:
                                //           if (snapshot.hasError) {
                                //             return Text(
                                //               'Pick image/video error: ${snapshot.error}}',
                                //               textAlign: TextAlign.center,
                                //             );
                                //           } else {
                                //             return const Text(
                                //               'You have not yet picked an image.',
                                //               textAlign: TextAlign.center,
                                //             );
                                //           }
                                //       }
                                //     },
                                //   ): _previewImage(),
                                // )
                              ],
                            )))
                  ]),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              floatingActionButton: FloatingActionButton.extended(
                icon: const Icon(Icons.save),
                label: const Text(
                  "Save",
                  style: TextStyle(fontSize: 17),
                ),
                onPressed: () async {
                  if (_validateName(name.text) == null) {
                    FocusScope.of(context).unfocus();
                    UserDetail.loginDetail.name = name.text;
                    await putRegistrationDetails(UserDetail.userDetails);
                    globalShowInSnackBar("Profile Saved!!", null,
                        scaffoldMessengerKey, null, null);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
}

typedef void OnPickImageCallback(
    double maxWidth, double maxHeight, int quality);

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
      return const TextEditingValue(text: "");
    }
  }
}
// class _IndNumberTextInputFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue,
//       TextEditingValue newValue,
//       ) {
//     final newTextLength = newValue.text.length;
//     final newText = StringBuffer();
//     var selectionIndex = newValue.selection.end;
//     var usedSubstringIndex = 0;
//     if (newTextLength >= 6) {
//       newText.write(newValue.text.substring(0, usedSubstringIndex = 5) + ' ');
//       if (newValue.selection.end >= 5) selectionIndex ++;
//     }
//     if (newTextLength >= 11) {
//       newText.write(newValue.text.substring(5, usedSubstringIndex = 10));
//       if (newValue.selection.end >= 10) {
//         selectionIndex++;
//       }
//     }
//     // Dump the rest.
//     if (newTextLength >= usedSubstringIndex) {
//       newText.write(newValue.text.substring(usedSubstringIndex));
//     }
//     if(newText.length<=11)
//       return TextEditingValue(
//         text: newText.toString(),
//         selection: TextSelection.collapsed(offset: selectionIndex),
//       );
//     else
//       return TextEditingValue(
//         text: newText.toString().substring(0,11),
//         selection: TextSelection.collapsed(offset: selectionIndex),
//       );
//   }
// }

