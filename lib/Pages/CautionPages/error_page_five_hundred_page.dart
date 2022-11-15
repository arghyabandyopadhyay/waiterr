import 'package:waiterr/routing_page.dart';
import 'package:waiterr/Pages/User/about_page.dart';
import 'package:waiterr/Pages/User/profile_page.dart';
import 'package:waiterr/stores/login_store.dart';
import 'package:waiterr/widgets/drawer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:waiterr/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'error_page.dart';
import 'package:waiterr/Model/drawer_action_model.dart';

class ErrorPageFiveHundredPage extends StatefulWidget {
  const ErrorPageFiveHundredPage({Key? key}) : super(key: key);
  @override
  State<ErrorPageFiveHundredPage> createState() =>
      _ErrorPageFiveHundredPageState();
}

class _ErrorPageFiveHundredPageState extends State<ErrorPageFiveHundredPage> {
  _deleteUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'userData';
    prefs.remove(key);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStore>(builder: (_, loginStore, __) {
      return Scaffold(
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
                elevation: 0,
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () async {
                      Connectivity connectivity = Connectivity();
                      await connectivity.checkConnectivity().then((value) => {
                            if (value != ConnectivityResult.none)
                              {
                                Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                        pageBuilder:
                                            (context, animation1, animation2) =>
                                                RoutingPage(
                                                  context: context,
                                                )))
                              }
                          });
                    },
                  )
                ],
              ),
              drawer: Drawer(
                  child: DrawerContent(
                alternativeMno: "Error 500!!",
                alternativeName: "waiterr",
                drawerItems: [
                  DrawerActionModel(
                    title: "Profile",
                    iconData: Icons.account_circle,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(CupertinoPageRoute<void>(
                        title: "Profile Page",
                        builder: (context) => const ProfilePage(),
                      ));
                    },
                  ),
                  DrawerActionModel(
                    title: "About us",
                    iconData: Icons.info,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(CupertinoPageRoute<void>(
                        title: "About Page",
                        builder: (context) => const AboutPage(),
                      ));
                    },
                  ),
                  DrawerActionModel(
                    title: "Log out",
                    iconData: Icons.exit_to_app,
                    onTap: () {
                      Navigator.pop(context);
                      _deleteUserDetails();
                      loginStore.signOut(context);
                    },
                  ),
                ],
              )),
              body: Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "Waiterr",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.bold),
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
                          child: const ErrorPageFiveHundred()),
                    )
                  ])),
              backgroundColor: GlobalTheme.tint,
            )
          ],
        ),
      );
    });
  }
}
