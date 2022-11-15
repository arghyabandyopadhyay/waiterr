import 'package:flutter/material.dart';
import '../theme.dart';

class AddQuantityDialog extends StatefulWidget {
  final onTapAdd;
  final setQuantity;
  final previousValue;
  const AddQuantityDialog(
      {Key? key, this.onTapAdd, this.setQuantity, this.previousValue})
      : super(key: key);
  @override
  State<AddQuantityDialog> createState() => _AddQuantityDialogState();
}

class _AddQuantityDialogState extends State<AddQuantityDialog> {
  TextEditingController quantityController = TextEditingController();
  List<double> items = [0.25, 0.5, 1, 5, 10, 25, 50, 100];
  bool _showCross = false;
  //Overrides
  @override
  void initState() {
    super.initState();
    _showCross = widget.previousValue.toString().isNotEmpty;
    quantityController.text =
        widget.previousValue > 0.0 ? widget.previousValue.toString() : "";
    widget.setQuantity(widget.previousValue);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)), //this right here
      child: SizedBox(
        height: 170,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: quantityController,
                autofocus: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter Quantity',
                  suffixIcon: _showCross
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            widget.setQuantity(0.0);
                            quantityController.text = "";
                            setState(() {
                              _showCross = false;
                            });
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  widget.setQuantity(value == "" ? 0.0 : double.parse(value));
                  if (value == "" && _showCross) {
                    setState(() {
                      _showCross = false;
                    });
                  } else if (!_showCross) {
                    setState(() {
                      _showCross = true;
                    });
                  }
                },
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                width: 320.0,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onTapAdd();
                  },
                  // color: GlobalTheme.waiterrPrimaryColor,
                  child: const Text(
                    "Ok",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Flexible(
                child: SizedBox(
                  height: 40,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    itemBuilder: (context, id) {
                      return GestureDetector(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          alignment: Alignment.center,
                          height: 20,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: GlobalTheme.borderColorHighlight,
                                  width: 1.0,
                                  style: BorderStyle.solid),
                              color: GlobalTheme.boxDecorationColorHighlight),
                          child: Text(
                            items[id].toStringAsFixed(2),
                            style: const TextStyle(
                                fontSize: 17, color: Colors.white),
                          ),
                        ),
                        onTap: () {
                          double newVal = ((quantityController.text.isNotEmpty)
                                  ? double.parse(quantityController.text)
                                  : 0) +
                              items[id];
                          widget.setQuantity(newVal);
                          quantityController.text = newVal.toStringAsFixed(2);
                          if (!_showCross) {
                            setState(() {
                              _showCross = true;
                            });
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
