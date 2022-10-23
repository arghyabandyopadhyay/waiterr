import 'package:waiterr/Model/customizable_page_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../theme.dart';

class CustomizableListCard extends StatelessWidget {
  final Function() onTapRemove;
  final Function() onTapAdd;
  final Function() onLongPressAdd;
  final Function() onLongPressRemove;
  final CustomizablePageModel? list;
  const CustomizableListCard(
      {Key? key,
      this.list,
      required this.onTapRemove,
      required this.onTapAdd,
      required this.onLongPressAdd,
      required this.onLongPressRemove})
      : super(key: key);

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
                    style: TextStyle(
                        fontSize: 17,
                        color: list!.qty == 0
                            ? GlobalTheme.primaryText
                            : GlobalTheme.primaryColor),
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
                    child: Text(
                      "₹${list!.price}",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: list!.qty == 0
                              ? GlobalTheme.primaryText
                              : GlobalTheme.primaryColor,
                          fontSize: 17),
                    ),
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
                          color: GlobalTheme.primaryColor,
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
                                    color: GlobalTheme.primaryColor,
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
