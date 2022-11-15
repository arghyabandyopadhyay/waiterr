import 'package:waiterr/global_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:waiterr/stores/login_store.dart';
import 'package:waiterr/theme.dart';
import 'package:waiterr/widgets/loading_indicator.dart';

class OtpPage extends StatefulWidget {
  static const String routeName = "otpPage";
  const OtpPage({Key? key}) : super(key: key);
  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String text = '';
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Consumer<LoginStore>(
      builder: (_, loginStore, __) {
        return Observer(
          builder: (_) => LoadingIndicator(
            inAsyncCall: loginStore.isOtpLoading,
            child: ScaffoldMessenger(
                key: loginStore.otpScaffoldMessengerKey,
                child: Scaffold(
                  key: loginStore.otpScaffoldKey,
                  resizeToAvoidBottomInset: false,
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Image.asset(
                      //   "assets/img/AYS_complete_icon.png",
                      //   height: 70,
                      //   width: 70,
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Text(
                            'Code Verification',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25.0,
                              height: 2.5,
                            ),
                          )),
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Text('Enter one time password sent on',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                              ))),
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child:
                              Text('+91${UserDetail.loginDetail.mobileNumber}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 30,
                                  ))),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Card(
                                  elevation: 10,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(40),
                                        bottomRight: Radius.circular(40)),
                                  ),
                                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)),
                                  // ),
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.all(2),
                                    child: OTPTextField(
                                      length: 6,
                                      keyboardType: TextInputType.number,
                                      width: 260,
                                      textFieldAlignment:
                                          MainAxisAlignment.spaceAround,
                                      fieldStyle: FieldStyle.box,
                                      style: const TextStyle(fontSize: 15),
                                      fieldWidth: 40,
                                      onCompleted: (pin) {
                                        text = pin;
                                        loginStore.validateOtpAndLogin(
                                            context, pin);
                                      },
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
                                            colors: GlobalTheme.buttonGradient),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: const Icon(
                                        Icons.done,
                                      )),
                                  onPressed: () {
                                    loginStore.validateOtpAndLogin(
                                        context, text);
                                  },
                                )
                              ])),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: const Text(
                          "Enter the 6-digit code.",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            // color: GlobalTheme.primaryText,
                            fontSize: 15.0,
                            height: 1.5,
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          ),
        );
      },
    );
  }
}
