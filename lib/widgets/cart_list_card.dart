import 'package:waiterr/Model/menu_item_model.dart';
import 'package:waiterr/theme.dart';
import 'package:flutter/material.dart';
import '../global_class.dart';
import 'add_button.dart';

class CartListCard extends StatefulWidget {
  final MenuItemModel item;
  final Function() onTapAdd;
  final Function() onTapRemove;
  final Function() onLongPressedAdd;
  final Function() onLongPressedRemove;
  final Function() onDoubleTap;
  const CartListCard(
      {super.key,
      required this.item,
      required this.onTapAdd,
      required this.onLongPressedAdd,
      required this.onLongPressedRemove,
      required this.onTapRemove,
      required this.onDoubleTap});
  @override
  State<CartListCard> createState() => _CartListCardState();
}

class _CartListCardState extends State<CartListCard> {
  @override
  Widget build(BuildContext context) {
    List<String> tagList =
        (widget.item.tags != null) ? widget.item.tags!.split("|") : [];
    if (widget.item.discount != 0 && widget.item.isDiscountable) {
      tagList.insert(0, "${widget.item.discount}% Off");
    }
    return Card(
      elevation: 0,
      color: Colors.transparent,
      margin: const EdgeInsets.only(bottom: 2),
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onDoubleTap: widget.onDoubleTap,
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: const EdgeInsets.only(top: 3),
                                    child: widget.item.isVeg
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
                                    width: MediaQuery.of(context).size.width /
                                            1.5 +
                                        (0),
                                    child: Text(
                                      widget.item.item,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 17),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "₹${widget.item.rate.toStringAsFixed(((((widget.item.rate * 100) % 100) != 0) ? 2 : 0)).replaceAllMapped(UserDetail.commaRegex, UserDetail.matchFunc as String Function(Match))}",
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(fontSize: 17),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      (widget.item.discount != 0 &&
                                              widget.item.isDiscountable)
                                          ? "₹${widget.item.rateBeforeDiscount}"
                                          : "",
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          decoration:
                                              TextDecoration.lineThrough),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          AddButton(
                            item: widget.item,
                            onLongPressedRemove: widget.onLongPressedRemove,
                            onLongPressedAdd: widget.onLongPressedAdd,
                            onTapRemove: widget.onTapRemove,
                            onTapAdd: widget.onTapAdd,
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Container(
                            height: (widget.item.customizable.isNotEmpty)
                                ? null
                                : 0,
                            padding: const EdgeInsets.only(left: 1, right: 1),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.orange,
                                    width: 1.0,
                                    style: BorderStyle.solid)),
                            child: (widget.item.customizable.isNotEmpty)
                                ? const Text(
                                    " Customizable ",
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.orange),
                                  )
                                : null,
                          ),
                          Container(
                            height: widget.item.commentForKOT != null
                                ? (widget.item.commentForKOT!.isNotEmpty)
                                    ? null
                                    : 0
                                : 0,
                            padding: const EdgeInsets.only(left: 1, right: 1),
                            child: widget.item.commentForKOT != null
                                ? (widget.item.commentForKOT!.isNotEmpty)
                                    ? const Icon(
                                        Icons.comment,
                                        color: GlobalTheme.commentIconColor,
                                      )
                                    : null
                                : null,
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: (tagList.isNotEmpty) ? 20 : 0,
                    width: MediaQuery.of(context).size.width / 1.12,
                    child: (tagList.isNotEmpty)
                        ? ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: tagList.length,
                            itemBuilder: (context, id) {
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 1),
                                alignment: Alignment.center,
                                height: 20,
                                padding:
                                    const EdgeInsets.only(left: 2, right: 2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: GlobalTheme.borderColorHighlight,
                                        width: 1.0,
                                        style: BorderStyle.solid),
                                    color: GlobalTheme
                                        .boxDecorationColorHighlight),
                                child: Text(
                                  tagList[id],
                                  style: const TextStyle(
                                      fontSize: 10, color: Colors.white),
                                ),
                              );
                            },
                          )
                        : const SizedBox(
                            height: 0,
                            width: 0,
                          ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: (widget.item.itemDescription != null)
                        ? Text(
                            widget.item.itemDescription!,
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                            maxLines: 3,
                          )
                        : null,
                  ),
                ],
              ))
            ],
          )),
    );
  }
}
