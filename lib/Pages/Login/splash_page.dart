import 'dart:convert';
import 'package:waiterr/Model/qr_json_model.dart';
import 'package:waiterr/routing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SplashPage extends StatefulWidget {
  static const String routeName = "splashPage";
  const SplashPage({Key? key}) : super(key: key);
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: RoutingPage(
        context: context,
      ),
    );
  }

  // Replace these two methods in the examples that follow
  QRJSONModel getJson(String json) {
    var qrList = jsonDecode(json);
    QRJSONModel qrJsonModel = QRJSONModel.fromJson(qrList);
    return qrJsonModel;
  }
}
