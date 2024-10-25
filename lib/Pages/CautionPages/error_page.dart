import 'package:flutter/material.dart';

import '../../theme.dart';

class ErrorPageFiveHundred extends StatelessWidget {
  const ErrorPageFiveHundred({super.key});
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
          Text(
            "Technical Error!!, We are working on it.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium,
          )
        ],
      )),
    );
  }
}

class ErrorPageFourHundredOne extends StatelessWidget {
  const ErrorPageFourHundredOne({super.key});
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
          Text(
            "Unauthorised Access!!",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium,
          )
        ],
      )),
    );
  }
}

class ErrorPageNoInternet extends StatelessWidget {
  const ErrorPageNoInternet({super.key});
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
          Text(
            "No Internet Connection!!",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium,
          )
        ],
      )),
    );
  }
}

class NoRunningOrders extends StatelessWidget {
  const NoRunningOrders({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          GlobalTheme.internalScaffoldResizeToAvoidBottomInset,
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
              Text(
                "No Running Orders",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium,
              )
            ],
          )),
    );
  }
}

class NoDataError extends StatelessWidget {
  const NoDataError({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          GlobalTheme.internalScaffoldResizeToAvoidBottomInset,
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
              Text(
                "No Data Found!!",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium,
              )
            ],
          )),
    );
  }
}

class ErrorHasOccurred extends StatelessWidget {
  const ErrorHasOccurred({super.key});
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
              Text(
                "An Error Has Occurred!!",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium,
              )
            ],
          )),
    );
  }
}

class BuildContextNotMounted extends StatelessWidget {
  const BuildContextNotMounted({super.key});
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
              Text(
                "The Build Context Referred To Is Not Mounted Anymore!!",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium,
              )
            ],
          )),
    );
  }
}
