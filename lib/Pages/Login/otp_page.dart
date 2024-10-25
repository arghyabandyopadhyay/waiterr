import 'package:waiterr/global_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:waiterr/stores/login_store.dart';
import 'package:waiterr/theme.dart';
import 'package:waiterr/utilities/login_page_painter.dart';
import 'package:waiterr/widgets/loading_indicator.dart';

class OtpPage extends StatefulWidget {
  static const String routeName = "otpPage";
  const OtpPage({super.key});
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
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text('Enter the Verification Code',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: GlobalTextStyles.otpHeaderTextStyle)),
                          Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: [
                                  // TextSpan(
                                  //   text: 'Waiterr',
                                  // style: TextStyle(
                                  //     fontSize: 20.0,
                                  //     fontFamily: 'Lobster',
                                  //     color: GlobalTheme.primaryGradient2[1]),
                                  // ),
                                  TextSpan(
                                    text:
                                        'Enter the 6-digit verification code that we have sent on',
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: GlobalTheme.primaryGradient2[1]),
                                  ),
                                  TextSpan(
                                    text:
                                        ' +91 ${UserDetail.loginDetail.mobileNumber ?? '0000000000'}',
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color: GlobalTheme.primaryGradient2[1]),
                                  ),
                                ]),
                              )),
                          // Container(
                          //     margin:
                          //         const EdgeInsets.symmetric(horizontal: 20),
                          //     child: Text(
                          //         '+91${UserDetail.loginDetail.mobileNumber}',
                          //         textAlign: TextAlign.center,
                          //         style: GlobalTheme.loginHeaderTextStyle)),
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
                                      color: GlobalTheme.primaryGradient2[2],
                                      elevation: 10,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(40),
                                            bottomRight: Radius.circular(40)),
                                      ),
                                      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)),
                                      // ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.centerRight,
                                              end: Alignment.centerLeft,
                                              colors:
                                                  GlobalTheme.primaryGradient2),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        // margin: const EdgeInsets.all(10),
                                        padding: const EdgeInsets.all(10),
                                        child: OTPTextField(
                                          length: 6,
                                          keyboardType: TextInputType.number,
                                          width: 260,
                                          textFieldAlignment:
                                              MainAxisAlignment.spaceAround,
                                          fieldStyle: FieldStyle.box,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.white70),
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
                                                colors:
                                                    GlobalTheme.buttonGradient),
                                            borderRadius:
                                                BorderRadius.circular(30),
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
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: 'Welcome to ',
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600,
                                        color: GlobalTheme.primaryGradient2[1]),
                                  ),
                                  TextSpan(
                                      text: 'Waiterr',
                                      style: GlobalTextStyles.waiterrTextStyle)
                                ]),
                              )),
                        ],
                      ),
                    ))),
          ),
        );
      },
    );
  }
}
