import 'package:waiterr/Model/menu_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../global_class.dart';

class TotalCalculationWidget extends StatelessWidget {
  final MenuItemModel? item;
  const TotalCalculationWidget({Key? key, this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (item!.customizable!.isEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
              width: MediaQuery.of(context).size.width / 1.75,
              child: Text(
                "${item!.item} x ${item!.quantity!.toStringAsFixed(2).replaceAllMapped(UserDetail.commaRegex, UserDetail.matchFunc as String Function(Match))}",
                textScaleFactor: 1,
                style: const TextStyle(fontSize: 17),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )),
          Container(
              width: MediaQuery.of(context).size.width / 6,
              alignment: Alignment.topRight,
              child: Text(
                "₹${(item!.quantity! * item!.rate!).toStringAsFixed(2).replaceAllMapped(UserDetail.commaRegex, UserDetail.matchFunc as String Function(Match))}",
                textScaleFactor: 1,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 17),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ))
        ],
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: item!.customizable!.length,
        itemBuilder: (context, id) {
          if (double.parse(item!.customizable![id].qty!) != 0) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Text(
                      "${item!.item}(${item!.customizable![id].name!}) x ${item!.customizable![id].qty!}",
                      textScaleFactor: 1,
                      style: const TextStyle(fontSize: 17),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )),
                Container(
                    width: MediaQuery.of(context).size.width / 6,
                    alignment: Alignment.topRight,
                    child: Text(
                      "₹${double.parse(item!.customizable![id].qty!) * double.parse(item!.customizable![id].price!)}",
                      textScaleFactor: 1,
                      style: const TextStyle(fontSize: 17),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ))
              ],
            );
          }
          return Container();
        },
      );
    }
  }
}