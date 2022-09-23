import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme.dart';

class AboutPage extends StatefulWidget {
  final List<List<dynamic>>? data;
  const AboutPage({Key? key, this.data}) : super(key: key);
  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalTheme.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            child: Image.asset(
              "assets/img/background.jpg",
            ),
          ),
          Scaffold(
            backgroundColor: GlobalTheme.backgroundColor.withOpacity(0.7),
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
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "About Us",
                      textScaleFactor: 1,
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
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      children: <Widget>[
                        const SizedBox(
                          height: 10,
                        ),
                        // Image(
                        //   height: 100,
                        //   alignment: Alignment.center,
                        //   image: Image.asset(
                        //     'assets/img/AYS_complete_icon.png',
                        //   ).image,
                        // ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border: Border.all(width: 0.2)),
                          child: const ListTile(
                            dense: true,
                            title: Text("App Version"),
                            subtitle: Text(
                              "1.0",
                              style: TextStyle(color: GlobalTheme.primaryText),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border: Border.all(width: 0.2)),
                          child: const ListTile(
                              dense: true,
                              title: Text("Powered By"),
                              subtitle: Text(
                                "Business Genie.",
                                style:
                                    TextStyle(color: GlobalTheme.primaryText),
                              )),
                        )
                      ],
                    ),
                  ))
                ]),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: FloatingActionButton.extended(
              icon:
                  const Icon(Icons.call, color: GlobalTheme.floatingButtonText),
              label: const Text(
                "Contact Us",
                textScaleFactor: 1,
                style: TextStyle(
                    fontSize: 17, color: GlobalTheme.floatingButtonText),
              ),
              onPressed: () async {
                final Uri url = Uri.parse('tel:<+917224077631>');
                if (!await launchUrl(url)) {
                  throw 'Could not launch $url';
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
