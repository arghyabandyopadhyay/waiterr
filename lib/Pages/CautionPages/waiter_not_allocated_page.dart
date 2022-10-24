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

class WaiterNotAllocatedPage extends StatefulWidget {
  const WaiterNotAllocatedPage({Key? key}) : super(key: key);
  @override
  _WaiterNotAllocatedPageState createState() => _WaiterNotAllocatedPageState();
}

class _WaiterNotAllocatedPageState extends State<WaiterNotAllocatedPage> {
  _deleteUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'userData';
    prefs.remove(key);
    const key1 = 'userClientAllocationData';
    prefs.remove(key1);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStore>(
      builder: (_, loginStore, __) {
        return Scaffold(
          backgroundColor: GlobalTheme.backgroundColor,
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
                  alternativeMno: "Waiter Not allocated!!",
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
                          decoration: const BoxDecoration(
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Center(
                                child: Text(
                                  "No Company has been allocated to you. Ask your manager to allocate you.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                              Center(
                                child: Image.asset(
                                    "assets/img/waiter_not_allocated.jpg"),
                              ),
                            ],
                          ),
                        ),
                      )
                    ])),
                backgroundColor: GlobalTheme.backgroundColor.withOpacity(0.7),
              )
            ],
          ),
        );
      },
    );
  }
}
