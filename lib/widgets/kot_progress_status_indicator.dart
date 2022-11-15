import 'package:waiterr/Model/kot_model.dart';
import 'package:waiterr/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class KOTProgressStatusIndicator extends StatefulWidget {
  final KOTModel currentKot;
  const KOTProgressStatusIndicator(this.currentKot, {super.key});
  @override
  KOTProgressStatusIndicatorState createState() =>
      KOTProgressStatusIndicatorState();
}

class KOTProgressStatusIndicatorState
    extends State<KOTProgressStatusIndicator> {
  int currentStep = 0;
  void getCurrentStep(KOTModel currentKot) {
    if (currentKot.orderPlaced) {
      if (currentKot.orderApproved) {
        if (currentKot.orderPrepared) {
          if (currentKot.orderProcessed) {
            currentStep = 3;
          } else {
            currentStep = 2;
          }
        } else {
          currentStep = 1;
        }
      } else {
        currentStep = 0;
      }
    } else {
      currentStep = -1;
    }
  }

  @override
  void initState() {
    getCurrentStep(widget.currentKot);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.fastfood,
                size: 35,
                color: currentStep >= 0
                    ? GlobalTheme.kotActiveColor
                    : GlobalTheme.kotInActiveColor),
            Container(
              width: MediaQuery.of(context).size.width / 6.5,
              alignment: Alignment.center,
              child: Text(
                'Order Placed',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12,
                    color: currentStep >= 0
                        ? GlobalTheme.kotActiveColor
                        : GlobalTheme.kotInActiveColor),
              ),
            ),
          ],
        ),
        Column(
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 2,
              width: MediaQuery.of(context).size.width / 12.25,
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              color: currentStep >= 0
                  ? GlobalTheme.kotActiveColor
                  : GlobalTheme.kotInActiveColor,
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.assignment,
                size: 35,
                color: currentStep >= 1
                    ? GlobalTheme.kotActiveColor
                    : GlobalTheme.kotInActiveColor),
            Container(
              width: MediaQuery.of(context).size.width / 6.5,
              alignment: Alignment.center,
              child: Text(
                'Order Approved',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12,
                    color: currentStep >= 1
                        ? GlobalTheme.kotActiveColor
                        : GlobalTheme.kotInActiveColor),
              ),
            ),
          ],
        ),
        Column(
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 2,
              width: MediaQuery.of(context).size.width / 12.25,
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              color: currentStep >= 1
                  ? GlobalTheme.kotActiveColor
                  : GlobalTheme.kotInActiveColor,
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.restaurant,
                size: 35,
                color: currentStep >= 2
                    ? GlobalTheme.kotActiveColor
                    : GlobalTheme.kotInActiveColor),
            Container(
              width: MediaQuery.of(context).size.width / 6.5,
              alignment: Alignment.center,
              child: Text(
                'Order Prepared',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12,
                    color: currentStep >= 2
                        ? GlobalTheme.kotActiveColor
                        : GlobalTheme.kotInActiveColor),
              ),
            ),
          ],
        ),
        Column(
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 2,
              width: MediaQuery.of(context).size.width / 12.25,
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              color: currentStep >= 2
                  ? GlobalTheme.kotActiveColor
                  : GlobalTheme.kotInActiveColor,
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.done_all,
                size: 35,
                color: currentStep >= 3
                    ? GlobalTheme.kotActiveColor
                    : GlobalTheme.kotInActiveColor),
            Container(
              width: MediaQuery.of(context).size.width / 6.5,
              alignment: Alignment.center,
              child: Text(
                'Order Delivered',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12,
                    color: currentStep >= 3
                        ? GlobalTheme.kotActiveColor
                        : GlobalTheme.kotInActiveColor),
              ),
            ),
          ],
        )
      ],
    );
  }
}
