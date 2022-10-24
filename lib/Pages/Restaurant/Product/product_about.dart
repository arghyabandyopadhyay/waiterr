import 'package:waiterr/Model/menu_item_model.dart';
import 'package:flutter/material.dart';

import '../../../theme.dart';

class ProductAbout extends StatelessWidget {
  final MenuItemModel item;
  const ProductAbout({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> tagList = (item.tags != null) ? item.tags!.split("|") : [];
    if (item.discount != null && item.discount != 0) {
      tagList.insert(0, "${item.discount}% Off");
    }
    double screenWidth = MediaQuery.of(context).size.width;
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            item.isVeg != null
                ? Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(top: 8),
                    child: item.isVeg!
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
                  )
                : Container(),
            Text(
              item.item,
              style: const TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
        Container(
          child: (item.itemDescription != null)
              ? Text(
                  item.itemDescription ?? "",
                  style: const TextStyle(
                    color: GlobalTheme.primaryText,
                    fontSize: 13,
                  ),
                  maxLines: 3,
                )
              : null,
        ),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: screenWidth / 1.5,
                          child: Row(
                            children: <Widget>[
                              Text(
                                "₹${item.rate.toStringAsFixed((((item.rate * 100) % 100) != 0) ? 2 : 0)}",
                                textAlign: TextAlign.start,
                                style: const TextStyle(fontSize: 30),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                (item.discount != null && item.discount != 0)
                                    ? "₹${item.rateBeforeDiscount}"
                                    : "",
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: GlobalTheme.primaryText,
                                    decoration: TextDecoration.lineThrough),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          height: (item.customizable.isNotEmpty) ? null : 0,
                          padding: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.orange,
                                  width: 1.0,
                                  style: BorderStyle.solid)),
                          child: (item.customizable.isNotEmpty)
                              ? const Text(
                                  " Customizable ",
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.orange),
                                )
                              : null,
                        ),
                        Container(
                          height: ((item.commentForKOT ?? "").isNotEmpty)
                              ? null
                              : 0,
                          padding: const EdgeInsets.symmetric(horizontal: 1),
                          child: ((item.commentForKOT ?? "").isNotEmpty)
                              ? const Icon(
                                  Icons.comment,
                                  color: GlobalTheme.primaryColor,
                                )
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
                  width: screenWidth / 1.12,
                  child: (tagList.isNotEmpty)
                      ? ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: tagList.length,
                          itemBuilder: (context, id) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 1),
                              alignment: Alignment.center,
                              height: 20,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: GlobalTheme.primaryColor,
                                      width: 1.0,
                                      style: BorderStyle.solid),
                                  color: GlobalTheme.primaryColor),
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
              ],
            )),
      ],
    );
  }
}
