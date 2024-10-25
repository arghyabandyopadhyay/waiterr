import 'package:waiterr/Model/customizable_page_model.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

class CustomizableListCard extends StatelessWidget {
  final Function() onTapRemove;
  final Function() onTapAdd;
  final Function() onLongPressAdd;
  final Function() onLongPressRemove;
  final CustomizablePageModel? list;
  const CustomizableListCard(
      {super.key,
      this.list,
      required this.onTapRemove,
      required this.onTapAdd,
      required this.onLongPressAdd,
      required this.onLongPressRemove});

  @override
  Widget build(BuildContext context) {
    double qty = list!.qty;
    return Card(
      elevation: 0,
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    list!.name,
                    style: list!.qty == 0
                        ? Theme.of(context).textTheme.displayMedium
                        : const TextStyle(
                            fontSize: 17,
                            color: GlobalTheme.waiterrPrimaryText),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                    child: Text("₹${list!.price}",
                        textAlign: TextAlign.end,
                        style: list!.qty == 0
                            ? Theme.of(context).textTheme.displayMedium
                            : const TextStyle(
                                fontSize: 17,
                                color: GlobalTheme.waiterrPrimaryText)),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    //padding: list.Qty=="0"?EdgeInsets.symmetric(horizontal: 13.5,vertical:3.5):EdgeInsets.all(0),
                    height: 35,
                    width: 70,
                    alignment: Alignment.bottomRight,
                    decoration: BoxDecoration(
                      gradient: list!.qty == 0
                          ? LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: GlobalTheme.primaryGradient)
                          : null,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                          color: GlobalTheme.borderColorHighlight,
                          width: 1,
                          style: BorderStyle.solid),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(1),
                          child: list!.qty == 0
                              ? GestureDetector(
                                  child: const Text(
                                    "Add",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        height: 2),
                                  ),
                                  onTap: () {
                                    onTapAdd();
                                  },
                                  onLongPress: () {
                                    onLongPressAdd();
                                  },
                                )
                              : GestureDetector(
                                  child: const Icon(
                                    Icons.remove,
                                    size: 17,
                                  ),
                                  onTap: () {
                                    onTapRemove();
                                  },
                                  onLongPress: () {
                                    onLongPressRemove();
                                  },
                                ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(0),
                          width: list!.qty == 0 ? 0 : 25,
                          height: list!.qty == 0 ? 0 : 35,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: GlobalTheme.primaryGradient),
                          ),
                          child: Center(
                            child: GestureDetector(
                              child: Text(
                                '$qty',
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () {
                                onTapAdd();
                              },
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(1),
                          child: GestureDetector(
                            child: list!.qty == 0
                                ? const Text(
                                    "",
                                  )
                                : const Icon(
                                    Icons.add,
                                    size: 17,
                                    color: GlobalTheme.waiterrPrimaryColor,
                                  ),
                            onTap: () {
                              onTapAdd();
                            },
                            onLongPress: () {
                              onLongPressAdd();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
