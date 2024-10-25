import 'package:waiterr/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../Model/menu_item_model.dart';
import '../global_class.dart';

class MenuDetailsCard extends StatefulWidget {
  final MenuItemModel item;
  final Function() onMiddleTap;
  const MenuDetailsCard(
      {super.key, required this.item, required this.onMiddleTap});
  @override
  State<MenuDetailsCard> createState() => _MenuDetailsCardState();
}

class _MenuDetailsCardState extends State<MenuDetailsCard> {
  @override
  Widget build(BuildContext context) {
    List<String> tagList =
        (widget.item.tags != null) ? widget.item.tags!.split("|") : [];
    if (widget.item.discount != 0 && widget.item.isDiscountable) {
      tagList.insert(0, "${widget.item.discount}% Off");
    }
    double screenWidth = MediaQuery.of(context).size.width;
    return Card(
        elevation: 0,
        color: Colors.transparent,
        margin: const EdgeInsets.only(bottom: 2),
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                (widget.item.itemImage != null && widget.item.itemImage != "")
                    ? Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width / 7,
                        child: CachedNetworkImage(
                          width: 40,
                          height: 40,
                          imageUrl: widget.item.itemImage!,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                                //colorFilter:ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                              ),
                            ),
                          ),
                          placeholder: (context, url) => SizedBox(
                              width: double.infinity,
                              child: Center(
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!.withOpacity(0.3),
                                  highlightColor: Colors.white,
                                  enabled: true,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 7,
                                    height: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              )),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ))
                    : const SizedBox(
                        height: 0,
                        width: 0,
                      ),
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
                            onTap: widget.onMiddleTap,
                            child: Container(
                              color: Colors.transparent,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        width: screenWidth / 1.5 -
                                            ((widget.item.itemImage != null &&
                                                    widget.item.itemImage != "")
                                                ? screenWidth / 7
                                                : 0) +
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
                                    width: screenWidth / 1.5 -
                                        ((widget.item.itemImage != null &&
                                                widget.item.itemImage != "")
                                            ? screenWidth / 7
                                            : 0),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "₹${widget.item.rate.toStringAsFixed((((widget.item.rate * 100) % 100) != 0) ? 2 : 0).replaceAllMapped(UserDetail.commaRegex, UserDetail.matchFunc as String Function(Match))}",
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
                              const SizedBox(
                                height: 2,
                              ),
                              Container(
                                height: (widget.item.customizable.isNotEmpty)
                                    ? null
                                    : 0,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 1),
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
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: (tagList.isNotEmpty) ? 20 : 0,
                        width: screenWidth / 1.12 -
                            ((widget.item.itemImage != null &&
                                    widget.item.itemImage != "")
                                ? screenWidth / 7
                                : 0),
                        child: (tagList.isNotEmpty)
                            ? ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: tagList.length,
                                itemBuilder: (context, id) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 1),
                                    alignment: Alignment.center,
                                    height: 20,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: GlobalTheme
                                                .borderColorHighlight,
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
                        width: screenWidth / 1.1 -
                            ((widget.item.itemImage != null &&
                                    widget.item.itemImage != "")
                                ? screenWidth / 7
                                : 0),
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
                  ),
                )
              ],
            )));
  }
}
