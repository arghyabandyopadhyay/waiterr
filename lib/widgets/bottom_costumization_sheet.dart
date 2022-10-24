import 'package:waiterr/Model/bottom_sheet_communication_template.dart';
import 'package:waiterr/Model/customizable_page_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import '../theme.dart';
import 'add_quantity_dialog.dart';
import 'customizable_list_card.dart';

class BottomSheetContent extends StatefulWidget {
  final List<CustomizablePageModel> jsonData;
  final String title;
  final String description;
  // This widget is the root of your application.
  const BottomSheetContent(
      {Key? key,
      required this.jsonData,
      required this.title,
      required this.description})
      : super(key: key);

  @override
  State<BottomSheetContent> createState() => _BottomSheetContent();
}

class _BottomSheetContent extends State<BottomSheetContent> {
  double? totalItems;
  double? totalCartAmount;

  _BottomSheetContent() {
    totalItems = 0;
    totalCartAmount = 0.0;
    for (CustomizablePageModel custModel in widget.jsonData) {
      if (custModel.qty != 0) {
        double qty = custModel.qty;
        totalItems = totalItems! + qty;
        totalCartAmount = totalCartAmount! + custModel.price * qty;
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 700,
      child: Column(
        children: [
          Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        widget.title,
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 20),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context, null);
                        },
                        child: const Icon(
                          Icons.close,
                          color: GlobalTheme.primaryText,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    child: Text(
                      widget.description,
                      style: const TextStyle(
                        color: GlobalTheme.primaryText,
                        fontSize: 13,
                      ),
                      maxLines: 3,
                    ),
                  ),
                ],
              )),
          const Divider(thickness: 1),
          Expanded(
            child: ListView.builder(
              itemCount: widget.jsonData.length,
              itemBuilder: (context, id) {
                return CustomizableListCard(
                  list: widget.jsonData[id],
                  onTapRemove: () {
                    setState(() {
                      totalItems = widget.jsonData[id].qty == 0
                          ? totalItems
                          : totalItems! - 1;
                      totalCartAmount = widget.jsonData[id].qty == 0
                          ? totalCartAmount
                          : totalCartAmount! - widget.jsonData[id].price;
                      widget.jsonData[id].qty = widget.jsonData[id].qty == 0
                          ? 0
                          : (widget.jsonData[id].qty - 1);
                    });
                  },
                  onTapAdd: () {
                    setState(() {
                      totalItems = totalItems! + 1;
                      totalCartAmount =
                          totalCartAmount! + widget.jsonData[id].price;
                      widget.jsonData[id].qty = widget.jsonData[id].qty + 1;
                    });
                  },
                  onLongPressAdd: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          late int quantity;
                          return AddQuantityDialog(
                            setQuantity: (int value) {
                              quantity = value;
                            },
                            onTapAdd: () {
                              setState(() {
                                totalItems = totalItems! + quantity;
                                double info = widget.jsonData[id].price;
                                totalCartAmount =
                                    totalCartAmount! + info * quantity;
                                widget.jsonData[id].qty =
                                    widget.jsonData[id].qty + quantity;
                                Navigator.pop(context);
                              });
                            },
                          );
                          /*return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(20.0)), //this right here
                              child: Container(
                                height: 150,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextFormField(
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Enter Quantity'),
                                        onChanged: (value) {
                                          quantity = value;
                                        },
                                      ),
                                      SizedBox(
                                        width: 320.0,
                                        child: RaisedButton(
                                          onPressed: () {
                                            setState(() {
                                              totalItems = totalItems + int.parse(quantity);
                                              double info=double.parse(widget.jsonData[id].price);
                                              totalCartAmount =
                                                  totalCartAmount + info*int.parse(quantity);
                                              widget.jsonData[id].qty =
                                                  (int.parse(
                                                      widget.jsonData[id].qty) +
                                                      int.parse(quantity)).toString();
                                              Navigator.pop(context);
                                            }
                                            );
                                          },
                                          child: Text(
                                            "Ok",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          color: GlobalTheme.primaryColor,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );*/
                        });
                  },
                  onLongPressRemove: () {
                    setState(() {
                      totalItems = widget.jsonData[id].qty == 0
                          ? totalItems
                          : totalItems! - widget.jsonData[id].qty;
                      totalCartAmount = widget.jsonData[id].qty == 0
                          ? totalCartAmount
                          : totalCartAmount! -
                              (widget.jsonData[id].price *
                                  widget.jsonData[id].qty);
                      widget.jsonData[id].qty = 0;
                    });
                  },
                );
              },
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 17),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Card(
                      elevation: 5,
                      color: Colors.transparent,
                      child: Container(
                        width: 120,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: GlobalTheme.primaryGradient),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          border: Border.all(
                              color: GlobalTheme.primaryColor,
                              width: 0.5,
                              style: BorderStyle.solid),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Text(
                          '$totalItems Items',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )),
                  GestureDetector(
                      onTap: () {
                        List<CustomizablePageModel> orderList =
                            widget.jsonData.toList();
                        //List<MotherJSONModel> temp=otherListString.map((tagJson) => MotherJSONModel.fromJson(tagJson)).toList();
                        //orderList.addAll(temp.where((element) => element.SubInfo!="0").toList());
                        //Navigator.push(context, CupertinoPageRoute(builder: (context) => FoodOrderPage(orderList)));
                        CustValTemp custValTemp = CustValTemp(
                            orderList, totalItems ?? 0, totalCartAmount);
                        Navigator.pop(context, custValTemp);
                      },
                      child: Card(
                          elevation: 5,
                          color: Colors.transparent,
                          child: Container(
                            alignment: Alignment.center,
                            width: 200,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: GlobalTheme.primaryGradient),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                  color: GlobalTheme.primaryColor,
                                  width: 0.5,
                                  style: BorderStyle.solid),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Text('Add ₹$totalCartAmount',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20)),
                          ))),
                ],
              )),
        ],
      ),
    );
  }
}
