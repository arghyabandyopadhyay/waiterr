import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../theme.dart';

class ErrorPageFiveHundred extends StatelessWidget {
  const ErrorPageFiveHundred({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset("assets/img/error_page_five_hundred.png"),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Technical Error!!, We are working on it.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17, color: GlobalTheme.primaryColor),
          )
        ],
      )),
    );
  }
}

class ErrorPageFourHundredOne extends StatelessWidget {
  const ErrorPageFourHundredOne({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset("assets/img/error_page_five_hundred.png"),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Unauthorised Access!!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17, color: GlobalTheme.primaryColor),
          )
        ],
      )),
    );
  }
}

class ErrorPageNoInternet extends StatelessWidget {
  const ErrorPageNoInternet({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset("assets/img/no_internet_error.webp"),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "No Internet Connection!!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17, color: GlobalTheme.primaryColor),
          )
        ],
      )),
    );
  }
}

class NoRunningOrders extends StatelessWidget {
  const NoRunningOrders({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
          margin: const EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/img/no_running_order.png"),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "No Running Orders",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, color: GlobalTheme.primaryColor),
              )
            ],
          )),
    );
  }
}

class NoDataError extends StatelessWidget {
  const NoDataError({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
          margin: const EdgeInsets.all(50),
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/img/no_data.jpg"),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "No Data Found!!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, color: GlobalTheme.primaryColor),
              )
            ],
          )),
    );
  }
}

class ErrorHasOccurred extends StatelessWidget {
  const ErrorHasOccurred({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
          margin: const EdgeInsets.all(50),
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/img/error_has_occured.jpg"),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "An Error Has Occurred!!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, color: GlobalTheme.primaryColor),
              )
            ],
          )),
    );
  }
}
