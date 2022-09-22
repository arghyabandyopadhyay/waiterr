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

class NoInternetPage extends StatefulWidget {
  const NoInternetPage({Key? key}) : super(key: key);
  @override
  _NoInternetPageState createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  _deleteUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'userData';
    prefs.remove(key);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStore>(builder: (_, loginStore, __) {
      return Scaffold(
          backgroundColor: GlobalTheme.backgroundColor,
          body: Stack(children: [
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
                    icon: Icon(Icons.refresh),
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
              backgroundColor: GlobalTheme.backgroundColor.withOpacity(0.7),
              drawer: Drawer(
                  child: DrawerContent(
                alternativeMno: "No Internet!!",
                alternativeName: "waiterr",
                drawerItems: [
                  DrawerActionModel(
                    title: "Profile",
                    iconData: Icons.account_circle,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(CupertinoPageRoute<void>(
                        title: "Profile Page",
                        builder: (context) => ProfilePage(),
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
                        builder: (context) => AboutPage(),
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
                  child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                    Padding(
                      child: Text(
                        "Waiterr",
                        textScaleFactor: 1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.bold),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    new Flexible(
                      child: Container(
                          height: MediaQuery.of(context).size.height,
                          padding: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: GlobalTheme.primaryText,
                                blurRadius: 25.0, // soften the shadow
                                spreadRadius: 5.0, //extend the shadow
                                offset: Offset(
                                  15.0, // Move to right 10  horizontally
                                  15.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ],
                          ),
                          child: ErrorPageNoInternet()),
                    )
                  ])),
            )
          ]));
    });
  }
}
