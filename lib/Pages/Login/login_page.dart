import 'package:waiterr/Modules/universal_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:waiterr/stores/login_store.dart';
import 'package:waiterr/theme.dart';
import 'package:waiterr/widgets/loading_indicator.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../global_class.dart';
import '../../utilities/login_page_painter.dart';
// import 'home_page.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = "loginPage";
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneController = TextEditingController(text: "+91");
  bool _validateName(String value) {
    value = value.replaceAll(" ", "");
    if (value.isEmpty) {
      return false;
    }
    final nameExp = RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  // bool _autoValidate = false;
  var nameController = TextEditingController();
  final SmsAutoFill _autoFill = SmsAutoFill();
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int i = 0;
  // void _handleSubmitted() {
  //   final form = _formKey.currentState!;
  //   if (!form.validate()) {
  //     // _autoValidate = true; // Start validating on every change.
  //   } else {
  //     form.save();
  //     //Save Data
  //     Navigator.of(context).push(
  //         CupertinoPageRoute<void>(builder: (context) => const HomePage()));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Consumer<LoginStore>(
      builder: (_, loginStore, __) {
        return Observer(
          builder: (_) => LoadingIndicator(
            inAsyncCall: loginStore.isLoginLoading,
            child: ScaffoldMessenger(
              key: loginStore.loginScaffoldMessengerKey,
              child: Scaffold(
                  key: loginStore.loginScaffoldKey,
                  resizeToAvoidBottomInset: false,
                  body: CustomPaint(
                    painter: Sky(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "assets/img/waiter_icon.png",
                          height: 100,
                          width: 100,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text("Welcome!",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: GlobalTextStyles.loginHeaderTextStyle),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text("Sign in to Continue",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style:
                                  GlobalTextStyles.loginHeaderTextStyleMedium),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Card(
                                    elevation: 10,
                                    color: GlobalTheme.primaryGradient2[2],
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(40),
                                          bottomRight: Radius.circular(40)),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.centerRight,
                                            end: Alignment.centerLeft,
                                            colors:
                                                GlobalTheme.primaryGradient2),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      width: MediaQuery.of(context).size.width /
                                          1.40,
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            height: 40,
                                            child: CupertinoTextField(
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              style: const TextStyle(
                                                  color: Colors.white70),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 0,
                                                      style: BorderStyle.none)),
                                              keyboardType: TextInputType.name,
                                              controller: nameController,
                                              placeholderStyle: const TextStyle(
                                                  color: Colors.white54),
                                              placeholder:
                                                  'Enter your Name here :',
                                              textInputAction:
                                                  TextInputAction.next,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            height: 40,
                                            child: PhoneFieldHint(
                                              child: TextField(
                                                style: const TextStyle(
                                                    color: Colors.white70),
                                                cursorColor: Colors.white,
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                  hintStyle: TextStyle(
                                                      color: Colors.white),
                                                  hintText:
                                                      'Enter your Mobile Number here :',
                                                  contentPadding:
                                                      EdgeInsets.all(6),
                                                ),
                                                controller: phoneController,
                                                keyboardType:
                                                    TextInputType.phone,
                                                textInputAction:
                                                    TextInputAction.go,
                                                maxLines: 1,
                                                onTap: () async {
                                                  if (i == 0) {
                                                    String? val =
                                                        await _autoFill.hint;
                                                    if (val != null) {
                                                      phoneController.text =
                                                          val;
                                                    }
                                                    i++;
                                                  }
                                                },
                                              ),
                                            ),
                                            // child:CupertinoTextField(
                                            //   decoration: BoxDecoration(
                                            //       border: Border.all(width: 0,style: BorderStyle.none)
                                            //   ),
                                            //   controller: phoneController,
                                            //   clearButtonMode:
                                            //   OverlayVisibilityMode.editing,
                                            //   keyboardType: TextInputType.phone,
                                            //   textInputAction: TextInputAction.go,
                                            //   maxLines: 1,
                                            //   placeholder: '+91...',
                                            // ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(
                                          side: BorderSide(
                                              color: Colors.transparent)),
                                      elevation: 10,
                                    ),
                                    child: Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors:
                                                  GlobalTheme.buttonGradient),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: const Icon(
                                          Icons.arrow_forward,
                                        )),
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      if (phoneController.text
                                              .substring(0, 3) !=
                                          '+91') {
                                        phoneController.text =
                                            "+91${phoneController.text}";
                                      }
                                      if (phoneController.text.isNotEmpty &&
                                          _validateName(nameController.text)) {
                                        UserDetail.loginDetail.name =
                                            nameController.text;
                                        UserDetail.loginDetail.mobileNumber =
                                            phoneController.text
                                                .replaceFirst("+91", "");
                                        loginStore.getCodeWithPhoneNumber(
                                            context,
                                            phoneController.text.toString());
                                      } else if (phoneController.text.isEmpty) {
                                        globalShowInSnackBar(
                                            'Please enter a phone number',
                                            null,
                                            loginStore
                                                .loginScaffoldMessengerKey,
                                            SnackBarBehavior.floating,
                                            Colors.red);
                                      } else {
                                        globalShowInSnackBar(
                                            'Please enter your Name',
                                            null,
                                            loginStore
                                                .loginScaffoldMessengerKey,
                                            SnackBarBehavior.floating,
                                            Colors.red);
                                      }
                                    },
                                  )
                                ])),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(children: [
                                TextSpan(
                                    text: 'Waiterr',
                                    style: GlobalTextStyles.waiterrTextStyle),
                                TextSpan(
                                  text:
                                      ' will send an SMS message to verify your phone number.',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: GlobalTheme.primaryGradient2[1]),
                                ),
                              ]),
                            )),
                      ],
                    ),
                  )),
            ),
          ),
        );
      },
    );
  }
}
