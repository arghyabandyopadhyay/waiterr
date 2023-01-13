import 'package:flutter/foundation.dart';
import 'package:waiterr/Modules/universal_module.dart';
import 'package:waiterr/Pages/Login/splash_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:waiterr/Pages/Login/login_page.dart';
import 'package:waiterr/Pages/Login/otp_page.dart';
import 'package:sms_autofill/sms_autofill.dart';
part 'login_store.g.dart';

class LoginStore = LoginStoreBase with _$LoginStore;

abstract class LoginStoreBase with Store {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SmsAutoFill _autoFill = SmsAutoFill();
  late String actualCode;

  @observable
  bool isLoginLoading = false;
  @observable
  bool isOtpLoading = false;

  @observable
  GlobalKey<ScaffoldState> loginScaffoldKey = GlobalKey<ScaffoldState>();
  @observable
  GlobalKey<ScaffoldState> otpScaffoldKey = GlobalKey<ScaffoldState>();
  @observable
  final GlobalKey<ScaffoldMessengerState> loginScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  @observable
  final GlobalKey<ScaffoldMessengerState> otpScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @observable
  User? firebaseUser;

  @action
  Future<bool> isAlreadyAuthenticated() async {
    firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      return true;
    } else {
      return false;
    }
  }

  @action
  Future<void> getCodeWithPhoneNumber(
      BuildContext context, String phoneNumber) async {
    isLoginLoading = true;

    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (AuthCredential auth) async {
          await _auth.signInWithCredential(auth).then((UserCredential value) {
            if (value.user != null) {
              onAuthenticationSuccessful(context, value);
            } else {
              globalShowInSnackBar(
                  'Invalid code/invalid authentication',
                  null,
                  loginScaffoldMessengerKey,
                  SnackBarBehavior.floating,
                  Colors.red);
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //   behavior: SnackBarBehavior.floating,
              //   backgroundColor: Colors.red,
              //   content: Text(
              //     'Invalid code/invalid authentication',
              //     style: TextStyle(color: Colors.white),
              //   ),
              // ));
            }
          }).catchError((error) {
            globalShowInSnackBar(
                'Something has gone wrong, please try later',
                null,
                loginScaffoldMessengerKey,
                SnackBarBehavior.floating,
                Colors.red);
          });
        },
        verificationFailed: (authException) async {
          globalShowInSnackBar(
              'The phone number format is incorrect. Please enter your number in E.164 format. [+][country code][number]',
              null,
              loginScaffoldMessengerKey,
              SnackBarBehavior.floating,
              Colors.red);
          isLoginLoading = false;
        },
        codeSent: (String verificationId, [int? forceResendingToken]) async {
          actualCode = verificationId;
          isLoginLoading = false;
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const OtpPage()));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          actualCode = verificationId;
        });
  }

  @action
  Future<void> validateOtpAndLogin(BuildContext context, String smsCode) async {
    isOtpLoading = true;
    final AuthCredential authCredential = PhoneAuthProvider.credential(
        verificationId: actualCode, smsCode: smsCode);

    await _auth.signInWithCredential(authCredential).catchError((error) {
      isOtpLoading = false;
      globalShowInSnackBar('Wrong code ! Please enter the last code received.',
          null, otpScaffoldMessengerKey, SnackBarBehavior.floating, Colors.red);
    }).then((UserCredential authResult) {
      if (authResult != null && authResult.user != null) {
        onAuthenticationSuccessful(context, authResult);
      }
    });
  }

  Future<void> onAuthenticationSuccessful(
      BuildContext context, UserCredential result) async {
    isLoginLoading = true;
    isOtpLoading = true;
    firebaseUser = result.user;
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const SplashPage()),
        (Route<dynamic> route) => false);
    isLoginLoading = false;
    isOtpLoading = false;
  }

  @action
  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (Route<dynamic> route) => false);
    firebaseUser = null;
  }
}
