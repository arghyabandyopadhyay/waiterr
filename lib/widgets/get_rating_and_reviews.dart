import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../theme.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class GetRatingAndReviews extends StatefulWidget {
  final item;
  const GetRatingAndReviews({Key? key, this.item}) : super(key: key);
  @override
  _GetRatingAndReviewsState createState() =>
      _GetRatingAndReviewsState(this.item);
}

class _GetRatingAndReviewsState extends State<GetRatingAndReviews> {
  final item;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // This widget is the root of your application.
  _GetRatingAndReviewsState(this.item);
  bool _showCross = false;
  //Overrides
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalTheme.backgroundColor,
      body: Stack(
        children: [
          Positioned(
            child: Image.asset(
              "assets/img/background.jpg",
            ),
          ),
          Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              leading: IconButton(
                padding: const EdgeInsets.all(0),
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => {Navigator.of(context).pop()},
              ),
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
            ),
            backgroundColor: GlobalTheme.backgroundColor.withOpacity(0.7),
            body: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                  // Container(
                  //   padding:EdgeInsets.symmetric(horizontal: 15),
                  //   child: NonFavouritesCard(
                  //     key: ObjectKey(item.itemID),
                  //     item: item,
                  //     onMiddleTap:(){
                  //     },
                  //     onTapAdd: (){
                  //       if(item.customizable.length==0) {
                  //         item.quantity =item.quantity +1;
                  //       }
                  //       else
                  //       {
                  //         _showModalBottomSheet(context,item);
                  //       }
                  //     },
                  //     onTapRemove:(){
                  //       if(item.customizable.length==0) {
                  //         if(item.quantity-1>=0)
                  //         {
                  //           item.quantity=item.quantity==0.0?0.0:item.quantity-1;
                  //         }
                  //         else{
                  //           item.quantity=0.0;
                  //         }
                  //       }
                  //       else
                  //       {
                  //         _showModalBottomSheet(context, item);
                  //       }
                  //     },
                  //     onLongPressedAdd:(){
                  //       (item.customizable.length==0)?showDialog(
                  //           context: context,
                  //           builder: (BuildContext context) {
                  //             double quantity=0;
                  //             final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
                  //             return AddQuantityDialog(
                  //               setQuantity: (double value){
                  //                 quantity=value;
                  //               },
                  //               previousValue: item.quantity,
                  //               onTap_add: (){
                  //                 setState(() {
                  //                   item.quantity =quantity;
                  //                 });
                  //                 Navigator.pop(context);
                  //               },
                  //             );
                  //           }
                  //       ):_showModalBottomSheet(context,item);
                  //     },
                  //     onLongPressedRemove: () {
                  //       if(item.customizable.length==0) {
                  //         item.quantity=0.0;
                  //       }
                  //       else _showModalBottomSheet(context, item);
                  //     },
                  //     onDoubleTap: (){
                  //       if(item.quantity!=0)showDialog(
                  //           context: context,
                  //           builder: (BuildContext context) {
                  //             String commentForKOT;
                  //             return AddCommentForKOTDialog(
                  //               ItemId:item.itemID ,
                  //               previousValue:item.commentForKOT,
                  //               setCommentForKOT: (value){
                  //                 commentForKOT=value;
                  //               },
                  //               onTap_add: (){
                  //                 setState(() {
                  //                   item.commentForKOT=commentForKOT;
                  //                   Navigator.pop(context);
                  //                 });
                  //               },
                  //             );
                  //           });
                  //       else showInSnackBar("Can't Add Remarks in the Items not added to cart.");
                  //     },
                  //   ),
                  // ),
                  Center(
                    child: SizedBox(
                      height: 200,
                      child: Image.asset("assets/img/all_filter_icon.png"),
                    ),
                  ),
                  Flexible(
                      child: Container(
                          height: MediaQuery.of(context).size.height,
                          padding: const EdgeInsets.only(top: 10),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: GlobalTheme.primaryText,
                                blurRadius: 25.0, // soften the shadow
                                spreadRadius: 5.0, //extend the shadow
                                offset: Offset(
                                  15.0, // Move to right 10  horizontally
                                  15.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ],
                          ),
                          child: ListView(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            children: [
                              Center(
                                child: Text(
                                  item.item,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const Center(
                                child: Text(
                                  "Rate The Product",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const Center(
                                child: Text(
                                  "How did you find the product based on your experience?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                              Center(
                                child: RatingBar(
                                  initialRating: 0,
                                  glowColor: Colors.white,
                                  unratedColor:
                                      GlobalTheme.primaryText.withOpacity(0.5),
                                  itemCount: 5,
                                  ratingWidget: RatingWidget(
                                      half: const Icon(
                                        Icons.sentiment_dissatisfied,
                                        color: Colors.redAccent,
                                      ),
                                      empty: const Icon(
                                        Icons.sentiment_very_dissatisfied,
                                        color: Colors.red,
                                      ),
                                      full: const Icon(
                                        Icons.sentiment_neutral,
                                        color: Colors.amber,
                                      )),
                                  // itemBuilder: (context, index) {
                                  //   switch (index) {
                                  //     case 0:
                                  //       return Icon(
                                  //         Icons.sentiment_very_dissatisfied,
                                  //         color: Colors.red,
                                  //       );
                                  //     case 1:
                                  //       return Icon(
                                  //         Icons.sentiment_dissatisfied,
                                  //         color: Colors.redAccent,
                                  //       );
                                  //     case 2:
                                  //       return Icon(
                                  //         Icons.sentiment_neutral,
                                  //         color: Colors.amber,
                                  //       );
                                  //     case 3:
                                  //       return Icon(
                                  //         Icons.sentiment_satisfied,
                                  //         color: Colors.lightGreen,
                                  //       );
                                  //     case 4:
                                  //       return Icon(
                                  //         Icons.sentiment_very_satisfied,
                                  //         color: Colors.green,
                                  //       );
                                  //   }
                                  // },
                                  onRatingUpdate: (rating) {
                                    if (kDebugMode) {
                                      print(rating);
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Review:",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 17),
                              ),
                              const TextField(
                                minLines: 5,
                                maxLines: 5,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      borderSide: BorderSide(
                                          color: GlobalTheme.primaryColor)),
                                  contentPadding:
                                      EdgeInsets.only(left: 10.0, right: 10.0),
                                ),
                              )
                            ],
                          ))),
                ])),
            bottomNavigationBar: BottomAppBar(
              color: Colors.transparent,
              elevation: 0.5,
              notchMargin: 5.0,
              clipBehavior: Clip.antiAlias,
              child: Container(
                  alignment: Alignment.center,
                  height: 70,
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  child: GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: GlobalTheme.primaryGradient),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: GlobalTheme.primaryColor,
                              width: 1.0,
                              style: BorderStyle.solid)),
                      width: MediaQuery.of(context).size.width * 0.60,
                      child: const Text('Submit',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  )),
            ),
          )
        ],
      ),
    );
  }
}
