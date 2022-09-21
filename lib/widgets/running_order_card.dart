import 'package:waiterr/Model/running_order_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

class RunningOrderCard extends StatelessWidget {
  const RunningOrderCard({Key? key, this.item}) : super(key: key);
  final RunningOrderModel? item;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width / 6.04,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              gradient: LinearGradient(
                colors: GlobalTheme.primaryGradient,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: const EdgeInsets.only(left: 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          item!.SalePointType!,
                          textAlign: TextAlign.center,
                          textScaleFactor: 1,
                          style: const TextStyle(
                              color: GlobalTheme.secondaryText, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          item!.SalePointName!,
                          textAlign: TextAlign.center,
                          textScaleFactor: 1,
                          style: TextStyle(
                              color: GlobalTheme.secondaryText,
                              fontSize: item!.SalePointName!.length > 2
                                  ? (item!.SalePointName!.length > 3
                                      ? (item!.SalePointName!.length > 4
                                          ? 12
                                          : 20)
                                      : 28)
                                  : 36),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          item!.OutletName!,
                          textAlign: TextAlign.center,
                          textScaleFactor: 1,
                          style: const TextStyle(
                              color: GlobalTheme.secondaryText, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: Text(
                                (item!.Name != null) ? item!.Name! : "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textScaleFactor: 1,
                                style: const TextStyle(fontSize: 22, height: 1),
                              ),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width / 15,
                                alignment: Alignment.topRight,
                                child: item!.BillPrinted!
                                    ? const Icon(Icons.print,
                                        color: GlobalTheme.primaryColor)
                                    : null),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.75,
                          child: Text(
                            (item!.MobileNo != null) ? item!.MobileNo! : "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textScaleFactor: 1,
                            style: const TextStyle(
                                fontSize: 13, color: GlobalTheme.primaryText),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.75,
                          child: Text(
                            "Waiter: ${item!.WaiterName!}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textScaleFactor: 1,
                            style: const TextStyle(
                                fontSize: 13, color: GlobalTheme.primaryText),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                    "PAX: ${item!.PAX}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textScaleFactor: 1,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: GlobalTheme.primaryText),
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                    "Active Since: ${item!.ActiveSince!}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textScaleFactor: 1,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: GlobalTheme.primaryText),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 4,
                              alignment: Alignment.bottomRight,
                              child: Text("₹${item!.Amount}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textScaleFactor: 1,
                                  style:
                                      const TextStyle(fontSize: 20, height: 1)),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ]),
          ),
        ));
  }
}
