//ProductSpecification
import 'package:waiterr/global_class.dart';
import 'package:waiterr/Model/menu_item_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProductSpecification extends StatelessWidget {
  const ProductSpecification({super.key});

  @override
  Widget build(BuildContext context) {
    MenuItemModel? item = UserDetail.item;
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      children: const [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Specifications",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            // GestureDetector(
            //     child: Container(
            //       padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
            //       decoration:BoxDecoration(color:Colors.white,border: Border.all(color: GlobalTheme.primaryText.withOpacity(0.2),width: 1,style: BorderStyle.solid),),
            //       child:Text("Rate Product",style: TextStyle(fontSize:15,color: GlobalTheme.waiterrPrimaryColor,fontWeight: FontWeight.bold)),
            //     ),
            //     onTap:(){
            //       Navigator.push(context, CupertinoPageRoute(builder: (context1) => GetRatingAndReviews(item: item,)));
            //     })
          ],
        )
      ],
    );
  }
}
