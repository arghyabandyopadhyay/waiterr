import 'package:waiterr/Model/menu_item_model.dart';
import 'package:waiterr/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddButtonLarge extends StatefulWidget {
  // This widget is the root of your application.
  const AddButtonLarge(
      {Key? key,
      this.item,
      required this.onTapAdd,
      required this.onLongPressedAdd,
      required this.onLongPressedRemove,
      required this.onTapRemove})
      : super(key: key);
  final MenuItemModel? item;
  final Function() onTapAdd;
  final Function() onLongPressedAdd;
  final Function() onLongPressedRemove;
  final Function() onTapRemove;
  @override
  State<AddButtonLarge> createState() => _AddButtonLargeState();
}

class _AddButtonLargeState extends State<AddButtonLarge> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      //padding: item['Quantity']=="0"?EdgeInsets.symmetric(horizontal: 13.5,vertical: 2.5):EdgeInsets.all(0),
      height: 80,
      alignment: Alignment.bottomRight,
      decoration: BoxDecoration(
        //gradient: item.quantity==0.0?LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter,colors: GlobalTheme.primaryGradient):null,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
            color: GlobalTheme.primaryColor,
            width: 1,
            style: BorderStyle.solid),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
              onTap: () {
                setState(() {
                  widget.item!.quantity == 0.0
                      ? widget.onTapAdd()
                      : widget.onTapRemove();
                });
              },
              onLongPress: widget.item!.quantity == 0.0
                  ? widget.onLongPressedAdd
                  : () {
                      setState(() {
                        widget.onLongPressedRemove();
                      });
                    },
              child: Container(
                alignment: Alignment.center,
                height: 80,
                width: widget.item!.quantity == 0.0
                    ? screenWidth / 4.25
                    : screenWidth / 14,
                color: Colors.transparent,
                padding: const EdgeInsets.all(1),
                child: widget.item!.quantity == 0.0
                    ? const Text(
                        "Add",
                        textAlign: TextAlign.center,
                        textScaleFactor: 1,
                        style: TextStyle(
                            fontSize: 15, color: GlobalTheme.secondaryText),
                      )
                    : const Icon(
                        Icons.remove,
                        size: 17,
                      ),
              )),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(0),
            width: widget.item!.quantity == 0.0 ? 0 : screenWidth / 10,
            height: widget.item!.quantity == 0.0 ? 0 : 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: GlobalTheme.primaryGradient),
            ),
            child: Text(
              widget.item!.quantity.toStringAsFixed(
                  (((widget.item!.quantity * 10) % 10) != 0) ? 1 : 0),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textScaleFactor: 1,
              style: const TextStyle(
                fontSize: 12.0,
                color: GlobalTheme.secondaryText,
              ),
            ),
          ),
          GestureDetector(
              onTap: () {
                setState(() {
                  widget.onTapAdd();
                });
              },
              onLongPress: widget.onLongPressedAdd,
              child: Container(
                height: widget.item!.quantity == 0.0 ? 0 : 80,
                width: widget.item!.quantity == 0.0 ? 0 : screenWidth / 14,
                color: Colors.transparent,
                padding: const EdgeInsets.all(1),
                child: widget.item!.quantity == 0.0
                    ? const Text(
                        "",
                        textScaleFactor: 1,
                      )
                    : const Icon(
                        Icons.add,
                        size: 17,
                        color: GlobalTheme.primaryColor,
                      ),
              )),
        ],
      ),
    );
  }
}
