import 'package:waiterr/Model/menu_item_model.dart';
import 'package:waiterr/theme.dart';
import 'package:waiterr/widgets/add_button.dart';
import 'package:flutter/material.dart';

class FavouritesCard extends StatelessWidget {
  final MenuItemModel item;
  final Function() onTapAdd;
  final Function() onTapRemove;
  final Function() onLongPressedAdd;
  final Function() onLongPressedRemove;
  final Function() onDoubleTap;
  const FavouritesCard(
      {Key? key,
      required this.item,
      required this.onTapAdd,
      required this.onLongPressedAdd,
      required this.onLongPressedRemove,
      required this.onTapRemove,
      required this.onDoubleTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7,
      /*child: Container(
          width: 300,
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(bottom: 2),
                        child: item.IsVeg? new Image.asset('assets/img/veg.png',height: 15,width: 15,):new Image.asset('assets/img/nonveg.png',height: 15,width: 15,),
                      ),
                      SizedBox(width: 5,),
                      Container(
                        width: MediaQuery.of(context).size.width/3,
                        child: Text(
                          item.item,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          
                          style: TextStyle( fontSize: 17),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Container(
                        height: (isNumeric(item.rate.toString()))?0:null,
                        padding: EdgeInsets.only(left: 1,right: 1),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.orange,width: 1.0,style: BorderStyle.solid)
                        ),
                        child: Text(" Customizable ",
                          
                          style: TextStyle(fontSize: 10,color: Colors.orange),
                        ),
                      )
                    ],
                  ),
                  Text(
                    //!isNumeric(item.rate.toString())?("₹"+item.rate[0]['Price']):("₹"+item.rate),
                    "₹"+item.rate.toString(),
                    textAlign: TextAlign.end,
                    
                    style: TextStyle( fontSize: 15),
                  ),

                ],
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width/2,
                    child:
                    Text(
                      (item.itemDescription!=null)?item.itemDescription:"Add sweet corn, and salt to the wok and mix",
                      
                      style: TextStyle( color:GlobalTheme.primaryText,fontSize: 13,),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  /*
                  Container(
                    padding: item['Quantity']=="0"?EdgeInsets.symmetric(horizontal: 13.5,vertical: 2.5):EdgeInsets.all(0),
                    alignment: Alignment.bottomRight,
                    decoration: BoxDecoration(
                      gradient: item['Quantity']=="0"?LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter,colors: GlobalTheme.primaryGradient):null,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: GlobalTheme.primaryColor,width: 1,style: BorderStyle.solid),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: item['Quantity']=="0"?GestureDetector(
                              child: Text("Add",style: TextStyle(fontSize:12,color: Colors.white),),
                              onTap: (){
                                onTapAdd();
                              },
                              onLongPress: (){
                                onLongPressedAdd();
                              }
                          ):GestureDetector(
                            child: Icon(Icons.remove,size: 17,),
                            onTap: (){
                              onTapRemove();
                            },
                            onLongPress: (){
                              onLongPressedRemove();
                            },
                          ),
                          padding: EdgeInsets.all(1),
                        ),
                        Container(
                          padding: EdgeInsets.all(0),
                          width: item['Quantity']=="0"?0:20,
                          height: item['Quantity']=="0"?0:25,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter,colors: GlobalTheme.primaryGradient),
                          ),
                          child: Center(
                            child: GestureDetector(
                              child: Text(
                                item['Quantity'],
                                
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                              onTap: (){
                                onTapAdd();
                              },
                            ),
                          ),
                        ),
                        Container(
                          child: GestureDetector(
                              child: item['Quantity']=="0"?Text("",):Icon(Icons.add,size: 17,color: GlobalTheme.primaryColor,),
                              onTap: (){
                                onTapAdd();
                              },
                              onLongPress: (){
                                onLongPressedAdd();
                              }
                          ),
                          padding: EdgeInsets.all(1),
                        ),
                      ],
                    ),
                  ),*/
                  AddButton(
                    item: item,
                    onLongPressedRemove:onLongPressedRemove ,
                    onLongPressedAdd:onLongPressedAdd ,
                    onTapRemove: onTapRemove,
                    onTapAdd: onTapAdd,
                  )
                ],
              ),


            ],
          )
      ),*/
      child: GestureDetector(
        onDoubleTap: onDoubleTap,
        child: Container(
            width: 300,
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(bottom: 2),
                          child: item.isVeg
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
                          width: (item.customizable.isNotEmpty)
                              ? MediaQuery.of(context).size.width / 3
                              : null,
                          child: Text(
                            item.item,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: (item.customizable.isNotEmpty) ? null : 0,
                      padding: const EdgeInsets.only(left: 1, right: 1),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Colors.orange,
                              width: 1.0,
                              style: BorderStyle.solid)),
                      child: (item.customizable.isNotEmpty)
                          ? const Text(
                              " Customizable ",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.orange),
                            )
                          : null,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.85,
                      child: Row(
                        children: <Widget>[
                          Text(
                            "₹${item.rate}",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(fontSize: 17),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            (item.discount != 0)
                                ? "₹${item.rateBeforeDiscount}"
                                : "",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 15,
                                color: GlobalTheme.primaryText,
                                decoration: TextDecoration.lineThrough),
                          )
                        ],
                      ),
                    ),
                    AddButton(
                      item: item,
                      onLongPressedRemove: onLongPressedRemove,
                      onLongPressedAdd: onLongPressedAdd,
                      onTapRemove: onTapRemove,
                      onTapAdd: onTapAdd,
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 22),
                  child: (item.itemDescription != null)
                      ? Text(
                          item.itemDescription!,
                          style: const TextStyle(
                            color: GlobalTheme.primaryText,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : null,
                ),
              ],
            )),
      ),
    );
  }
}
