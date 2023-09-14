import 'package:waiterr/Model/running_order_model.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

class RunningOrderCard extends StatelessWidget {
  const RunningOrderCard(
      {Key? key, this.item, required this.onBillPrintedClick})
      : super(key: key);
  final RunningOrderModel? item;
  final Function() onBillPrintedClick;

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
                          item!.salePointType ?? "",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: GlobalTheme.salePointTypeColor,
                              fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          item!.salePointName ?? "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: GlobalTheme.salePointNameColor,
                              fontSize: item!.salePointName!.length > 2
                                  ? (item!.salePointName!.length > 3
                                      ? (item!.salePointName!.length > 4
                                          ? 12
                                          : 20)
                                      : 28)
                                  : 36),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          item!.outletName ?? "",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: GlobalTheme.outletNameColor, fontSize: 12),
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
                                (item!.name == null || item!.name!.isEmpty)
                                    ? "Customer"
                                    : item!.name!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 22, height: 1),
                              ),
                            ),
                            GestureDetector(
                              onTap: onBillPrintedClick,
                              child: Container(
                                  width: MediaQuery.of(context).size.width / 15,
                                  alignment: Alignment.topRight,
                                  child: item!.billPrinted
                                      ? const Icon(Icons.print,
                                          color: GlobalTheme.printIconColor)
                                      : null),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.75,
                          child: Text(
                            (item!.mobileNo == null || item!.mobileNo!.isEmpty)
                                ? "XXXXX-XXXXX"
                                : item!.mobileNo!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.75,
                          child: Text(
                            "Waiter: ${(item!.waiterName == null || item!.waiterName!.isEmpty) ? "Waiter" : item!.waiterName}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13),
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
                                    "PAX: ${item!.pax}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                    "Active Since: ${(item!.activeSince == null || item!.activeSince!.isEmpty) ? DateTime.now() : item!.activeSince}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 4,
                              alignment: Alignment.bottomRight,
                              child: Text("₹${item!.amount.toStringAsFixed(2)}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
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
