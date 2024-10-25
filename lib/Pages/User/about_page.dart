import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme.dart';

class AboutPage extends StatefulWidget {
  final List<List<dynamic>>? data;
  const AboutPage({super.key, this.data});
  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            child: Image.asset(
              "assets/img/background.jpg",
            ),
          ),
          Scaffold(
            backgroundColor: GlobalTheme.tint,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "About Us",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GlobalTextStyles.waiterrTextStyleAppBar,
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
                              )),
                        )
                      ],
                    ),
                  ))
                ]),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: FloatingActionButton.extended(
              icon: const Icon(Icons.call),
              label: const Text(
                "Contact Us",
                style: TextStyle(fontSize: 17),
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
