import 'package:waiterr/routing_page.dart';
import 'package:waiterr/Pages/User/about_page.dart';
import 'package:waiterr/Pages/User/profile_page.dart';
import 'package:waiterr/widgets/drawer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:waiterr/stores/login_store.dart';
import 'package:waiterr/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waiterr/Model/drawer_action_model.dart';

class IdBlockedPage extends StatefulWidget {
  const IdBlockedPage({Key? key}) : super(key: key);
  @override
  State<IdBlockedPage> createState() => _IdBlockedPageState();
}

class _IdBlockedPageState extends State<IdBlockedPage> {
  _deleteUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'userData';
    prefs.remove(key);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStore>(
      builder: (_, loginStore, __) {
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
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  title: Text(
                    "",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 30.0,
                        height: 2.5,
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: GlobalTheme.primaryGradient,
                          ).createShader(
                              const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0))),
                  ),
                  actions: [
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
                                          pageBuilder: (context, animation1,
                                                  animation2) =>
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
                  alternativeMno: "Id Blocked!!",
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
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Center(
                                  child: Text(
                                    "Your Id Is Blocked Due To Suspicious Activities.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.all(50),
                                  child:
                                      Image.asset("assets/img/idBlocked.jpg"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ])),
                backgroundColor: GlobalTheme.tint,
              )
            ],
          ),
        );
      },
    );
  }
}
