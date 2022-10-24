import 'package:waiterr/Model/menu_item_model.dart';
import 'package:waiterr/theme.dart';
import 'package:flutter/material.dart';

class AddButton extends StatefulWidget {
  const AddButton(
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
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 70,
      alignment: Alignment.bottomRight,
      decoration: BoxDecoration(
        //for adding gradient to the button.
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
              onTap: widget.item!.quantity == 0.0
                  ? () {
                      setState(() {
                        widget.onTapAdd();
                      });
                    }
                  : () {
                      setState(() {
                        widget.onTapRemove();
                      });
                    },
              onLongPress: widget.item!.quantity == 0.0
                  ? () {
                      setState(() {
                        widget.onLongPressedAdd();
                      });
                    }
                  : () {
                      setState(() {
                        widget.onLongPressedRemove();
                      });
                    },
              child: Container(
                alignment: Alignment.center,
                height: 35,
                width: widget.item!.quantity == 0.0 ? 65 : null,
                color: Colors.transparent,
                padding: const EdgeInsets.all(1),
                child: widget.item!.quantity == 0.0
                    ? const Text(
                        "Add",
                        textAlign: TextAlign.center,
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
            width: widget.item!.quantity == 0.0 ? 0 : 25,
            height: widget.item!.quantity == 0.0 ? 0 : 35,
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
              style: const TextStyle(
                fontSize: 12.0,
                color: GlobalTheme.secondaryText,
              ),
            ),
          ),
          GestureDetector(
              onTap: widget.onTapAdd,
              onLongPress: widget.onLongPressedAdd,
              child: Container(
                height: widget.item!.quantity == 0.0 ? 0 : 35,
                width: widget.item!.quantity == 0.0 ? 0 : 20,
                color: Colors.transparent,
                padding: const EdgeInsets.all(1),
                child: widget.item!.quantity == 0.0
                    ? const Text(
                        "",
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
