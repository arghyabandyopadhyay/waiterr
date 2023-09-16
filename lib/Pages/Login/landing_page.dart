import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waiterr/Pages/Login/login_page.dart';
import 'package:waiterr/theme.dart';
import '../../utilities/login_page_painter.dart';
import '../../widgets/welcome_to_waiterr.dart';

class LandingPage extends StatefulWidget {
  static const String routeName = "loginPage";
  const LandingPage({Key? key}) : super(key: key);
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: CustomPaint(
          painter: Sky(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: const WelcomeToWaiterr()),
              const SizedBox(
                height: 100,
              ),
              Image.asset(
                "assets/img/waiter_icon.png",
                height: 100,
                width: 100,
              ),
              const SizedBox(
                height: 100,
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 40),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Unlock your dineline",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: GlobalTextStyles
                                        .unlockYourDinelineTextStyle),
                                Text("Sign in now!",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: GlobalTextStyles.signInNowTextStyle)
                              ]),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                            shape: const CircleBorder(
                                eccentricity: 0,
                                side: BorderSide(color: Colors.transparent)),
                            elevation: 10,
                          ),
                          child: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 50, 10, 50),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: GlobalTheme.buttonGradient),
                                borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(100)),
                              ),
                              child: const Icon(
                                size: 30,
                                Icons.arrow_forward,
                              )),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                CupertinoPageRoute<void>(
                                    title: "",
                                    builder: ((_) => const LoginPage())));
                          },
                        )
                      ])),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ));
  }
}
