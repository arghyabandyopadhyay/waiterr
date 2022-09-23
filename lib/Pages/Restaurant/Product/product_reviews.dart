import 'package:waiterr/global_class.dart';
import 'package:waiterr/Model/menu_item_model.dart';
import 'package:waiterr/widgets/get_rating_and_reviews.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../theme.dart';

class ProductReviews extends StatelessWidget {
  const ProductReviews({super.key});

  @override
  Widget build(BuildContext context) {
    MenuItemModel? item = UserDetail.item;
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Ratings & Reviews",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: GlobalTheme.primaryText.withOpacity(0.2),
                        width: 1,
                        style: BorderStyle.solid),
                  ),
                  child: const Text("Rate Product",
                      textScaleFactor: 1,
                      style: TextStyle(
                          fontSize: 15,
                          color: GlobalTheme.primaryColor,
                          fontWeight: FontWeight.bold)),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context1) => GetRatingAndReviews(
                                item: item,
                              )));
                })
          ],
        )
      ],
    );
  }
}
