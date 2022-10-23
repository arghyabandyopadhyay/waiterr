import 'package:waiterr/Model/kot_model.dart';
import 'package:flutter/material.dart';

import '../global_class.dart';

class KOTDetailsWidget extends StatelessWidget {
  final KOTModel? list;
  const KOTDetailsWidget({Key? key, this.list}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        child: Column(
          children: <Widget>[
            KOTDetailsList(
              list: list,
            ),
            //progress indicator
          ],
        ));
  }
}

class KOTDetailsList extends StatelessWidget {
  final KOTModel? list;
  const KOTDetailsList({Key? key, this.list}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    try {
      double.parse(list!.rate.toString());
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width / 1.75,
              child: Text(
                "${list!.item!} x ${list!.quantity}",
                style: const TextStyle(fontSize: 17),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              )),
          Container(
              width: MediaQuery.of(context).size.width * 0.21,
              alignment: Alignment.centerRight,
              child: Text(
                "₹${(list!.quantity! * list!.rate! * (1 + (list!.taxRate! * 0.01))).toStringAsFixed(2).replaceAllMapped(UserDetail.commaRegex, UserDetail.matchFunc as String Function(Match))}",
                style: const TextStyle(fontSize: 17),
              ))
        ],
      );
    } catch (e) {
      return Container();
      /*return Container(
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: list.rate.toString().length,
          itemBuilder: (context, id) {
            if(double.parse(list["Info"][id]['Qty'])!=0)return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[Container(alignment:Alignment.centerLeft,width: MediaQuery.of(context).size.width/1.75,child:Text(list["Particulars"]+"("+list["Info"][id]['Name']+")"+" x "+list["Info"][id]['Qty'],style: TextStyle(fontSize: 17),overflow: TextOverflow.ellipsis,maxLines: 2,)),Center(child:Text("₹"+(double.parse(list["Info"][id]['Qty'])*double.parse(list["Info"][id]['Price'])).toString(),style: TextStyle(fontSize: 17),))],);
            return Container();
          },
        ),
      );

       */
    }
  }
}
