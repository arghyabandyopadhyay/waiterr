import 'package:waiterr/Model/user_details_model.dart';
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

String getMonth(int month) {
  String monthString;
  switch (month) {
    case 1:
      monthString = "Jan ";
      break;
    case 2:
      monthString = "Feb ";
      break;
    case 3:
      monthString = "Mar ";
      break;
    case 4:
      monthString = "Apr ";
      break;
    case 5:
      monthString = "May ";
      break;
    case 6:
      monthString = "Jun ";
      break;
    case 7:
      monthString = "Jul ";
      break;
    case 8:
      monthString = "Aug ";
      break;
    case 9:
      monthString = "Sep ";
      break;
    case 10:
      monthString = "Oct ";
      break;
    case 11:
      monthString = "Nov ";
      break;
    case 12:
      monthString = "Dec ";
      break;
    default:
      monthString = "$month";
      break;
  }
  return monthString;
}

String? getFormattedDate(DateTime? dateTime) {
  if (dateTime != null) {
    return "${dateTime.day}${dateTime.month}${dateTime.year}";
  } else {
    return null;
  }
}

String getFormattedMobileNo(String value) {
  value = value.replaceAll(" ", "");
  RegExp mobileNoRegex = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
  if (value.isEmpty) {
    return value;
  } else if (mobileNoRegex.hasMatch(value)) {
    if (value.length == 10) {
      return "${value.substring(0, 5)} ${value.substring(5)}";
    } else if (value.length == 11) {
      return "${value.substring(1, 6)} ${value.substring(6)}";
    } else if (value.length == 12) {
      return "${value.substring(2, 7)} ${value.substring(7)}";
    } else if (value.length == 13) {
      return "${value.substring(3, 8)} ${value.substring(8)}";
    } else {
      return "";
    }
  } else {
    return "";
  }
}

String generateMasterFilter(UserDetailsModel client) {
  return ("${client.name ?? ""}${client.mobileNumber}${client.id}")
      .replaceAll(RegExp(r'\W+'), "")
      .toLowerCase();
}
