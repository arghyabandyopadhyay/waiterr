import 'package:waiterr/theme.dart';
import 'package:flutter/material.dart';

void globalShowInSnackBar(
    String value,
    SnackBarAction? barAction,
    GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
    SnackBarBehavior? barBehavior,
    Color? barColor) {
  if (value == "ErrorHasOccurred") {
    value = "Oops!! Error 404.";
  } else if (value == "NoData") {
    value = "No data received.";
  } else if (value == "500") {
    value = "Oops!! Error 500, It's not you, It's us.";
  } else if (value == "NoInternet") {
    value = "No Internet Connections present!!";
  }
  scaffoldMessengerKey.currentState!.hideCurrentSnackBar();
  scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
      behavior: barBehavior,
      backgroundColor: barColor,
      content: Text(
        value,
        textScaleFactor: 1,
        style: const TextStyle(),
      ),
      action: barAction));
}
