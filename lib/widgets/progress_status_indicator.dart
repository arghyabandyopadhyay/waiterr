import 'package:waiterr/Model/kot_model.dart';
import 'package:waiterr/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProgressStatusIndicator extends StatefulWidget {
  final KOTModel currentKot;
  ProgressStatusIndicator(this.currentKot) : super();
  @override
  ProgressStatusIndicatorState createState() =>
      ProgressStatusIndicatorState(currentKot);
}

class ProgressStatusIndicatorState extends State<ProgressStatusIndicator> {
  final KOTModel currentKot;
  ProgressStatusIndicatorState(this.currentKot) {
    getCurrentStep(currentKot);
  }
  int current_step = 0;
  void getCurrentStep(KOTModel currentKot) {
    if (currentKot.orderPlaced!) {
      if (currentKot.orderApproved!) {
        if (currentKot.orderPrepared!) {
          if (currentKot.orderProcessed!)
            current_step = 3;
          else
            current_step = 2;
        } else
          current_step = 1;
      } else
        current_step = 0;
    } else
      current_step = -1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.fastfood,
                size: 35,
                color: current_step >= 0
                    ? GlobalTheme.primaryColor
                    : GlobalTheme.primaryText),
            Container(
              width: MediaQuery.of(context).size.width / 6.5,
              alignment: Alignment.center,
              child: Text(
                'Order Placed',
                textAlign: TextAlign.center,
                textScaleFactor: 1,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12,
                    color: current_step >= 0
                        ? GlobalTheme.primaryColor
                        : GlobalTheme.primaryText),
              ),
            ),
          ],
        ),
        Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Container(
              height: 2,
              width: MediaQuery.of(context).size.width / 12.25,
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.all(0),
              color: current_step >= 0
                  ? GlobalTheme.primaryColor
                  : GlobalTheme.primaryText,
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.assignment,
                size: 35,
                color: current_step >= 1
                    ? GlobalTheme.primaryColor
                    : GlobalTheme.primaryText),
            Container(
              width: MediaQuery.of(context).size.width / 6.5,
              alignment: Alignment.center,
              child: Text(
                'Order Approved',
                textAlign: TextAlign.center,
                textScaleFactor: 1,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12,
                    color: current_step >= 1
                        ? GlobalTheme.primaryColor
                        : GlobalTheme.primaryText),
              ),
            ),
          ],
        ),
        Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Container(
              height: 2,
              width: MediaQuery.of(context).size.width / 12.25,
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.all(0),
              color: current_step >= 1
                  ? GlobalTheme.primaryColor
                  : GlobalTheme.primaryText,
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.restaurant,
                size: 35,
                color: current_step >= 2
                    ? GlobalTheme.primaryColor
                    : GlobalTheme.primaryText),
            Container(
              width: MediaQuery.of(context).size.width / 6.5,
              alignment: Alignment.center,
              child: Text(
                'Order Prepared',
                textAlign: TextAlign.center,
                textScaleFactor: 1,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12,
                    color: current_step >= 2
                        ? GlobalTheme.primaryColor
                        : GlobalTheme.primaryText),
              ),
            ),
          ],
        ),
        Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Container(
              height: 2,
              width: MediaQuery.of(context).size.width / 12.25,
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.all(0),
              color: current_step >= 2
                  ? GlobalTheme.primaryColor
                  : GlobalTheme.primaryText,
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.done_all,
                size: 35,
                color: current_step >= 3
                    ? GlobalTheme.primaryColor
                    : GlobalTheme.primaryText),
            Container(
              width: MediaQuery.of(context).size.width / 6.5,
              alignment: Alignment.center,
              child: Text(
                'Order Delivered',
                textAlign: TextAlign.center,
                textScaleFactor: 1,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12,
                    color: current_step >= 3
                        ? GlobalTheme.primaryColor
                        : GlobalTheme.primaryText),
              ),
            ),
          ],
        )
      ],
    ));
  }
}
/*
Stepper(
              type: StepperType.horizontal,
              currentStep: current_step,
              physics: AlwaysScrollableScrollPhysics(),
              steps:[
                Step(
                  title: Icon(Icons.fastfood,color:current_step>=0?GlobalTheme.primaryColor:GlobalTheme.primaryText),
                    content:Center(child:Text('The Order has been placed.',textScaleFactor: 1,style: TextStyle(fontSize: 17,color: Colors.black45),),),
                    state: current_step>=0?StepState.complete:StepState.indexed,
                    isActive: current_step>=0
                ),
                Step(
                    title: Icon(Icons.restaurant_menu,color:current_step>=1?GlobalTheme.primaryColor:GlobalTheme.primaryText),
                    content: Center(child:Text('The Order has been approved.',textScaleFactor: 1,style: TextStyle(fontSize: 17,color: Colors.black45),),),
                    state: StepState.disabled,
                    isActive: current_step>=1
                ),
                Step(
                    title: Icon(Icons.restaurant,color:current_step>=2?GlobalTheme.primaryColor:GlobalTheme.primaryText),
                    content:  Center(child:Text('The Order would be coming to you in some minutes.',textScaleFactor: 1,style: TextStyle(fontSize: 17,color: Colors.black45))),
                    state: current_step>=2?StepState.complete:StepState.indexed,
                    isActive: current_step>=2
                ),
                Step(
                    title: Icon(Icons.done_all,color:current_step>=3?GlobalTheme.primaryColor:GlobalTheme.primaryText),
                    content:  Center(child:Text('The Order has been Delivered.',textScaleFactor: 1,style: TextStyle(fontSize: 17,color: Colors.black45),)),
                    state: current_step==3?StepState.complete:StepState.indexed,
                    isActive: current_step==3
                ),
              ],
              controlsBuilder: (BuildContext context,
                  {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                return Row();
              },
            )
 */