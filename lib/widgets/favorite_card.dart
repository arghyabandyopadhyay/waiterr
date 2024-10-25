import 'package:waiterr/Model/menu_item_model.dart';
import 'package:waiterr/widgets/add_button.dart';
import 'package:flutter/material.dart';

class FavouritesCard extends StatelessWidget {
  final MenuItemModel item;
  final Function() onTapAdd;
  final Function() onTapRemove;
  final Function() onLongPressedAdd;
  final Function() onLongPressedRemove;
  final Function() onDoubleTap;
  const FavouritesCard(
      {super.key,
      required this.item,
      required this.onTapAdd,
      required this.onLongPressedAdd,
      required this.onLongPressedRemove,
      required this.onTapRemove,
      required this.onDoubleTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7,
      child: GestureDetector(
        onDoubleTap: onDoubleTap,
        child: Container(
            width: 300,
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(bottom: 2),
                          child: item.isVeg
                              ? Image.asset(
                                  'assets/img/veg.png',
                                  height: 15,
                                  width: 15,
                                )
                              : Image.asset(
                                  'assets/img/nonveg.png',
                                  height: 15,
                                  width: 15,
                                ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width: (item.customizable.isNotEmpty)
                              ? MediaQuery.of(context).size.width / 3
                              : null,
                          child: Text(
                            item.item,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: (item.customizable.isNotEmpty) ? null : 0,
                      padding: const EdgeInsets.only(left: 1, right: 1),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Colors.orange,
                              width: 1.0,
                              style: BorderStyle.solid)),
                      child: (item.customizable.isNotEmpty)
                          ? const Text(
                              " Customizable ",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.orange),
                            )
                          : null,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.85,
                      child: Row(
                        children: <Widget>[
                          Text(
                            "₹${item.rate}",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(fontSize: 17),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            (item.discount != 0)
                                ? "₹${item.rateBeforeDiscount}"
                                : "",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 15,
                                decoration: TextDecoration.lineThrough),
                          )
                        ],
                      ),
                    ),
                    AddButton(
                      item: item,
                      onLongPressedRemove: onLongPressedRemove,
                      onLongPressedAdd: onLongPressedAdd,
                      onTapRemove: onTapRemove,
                      onTapAdd: onTapAdd,
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 22),
                  child: (item.itemDescription != null)
                      ? Text(
                          item.itemDescription!,
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : null,
                ),
              ],
            )),
      ),
    );
  }
}
