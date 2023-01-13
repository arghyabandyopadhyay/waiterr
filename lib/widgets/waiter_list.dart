import 'package:waiterr/Model/menu_item_model.dart';
import 'package:expandable_group/expandable_group_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:waiterr/Model/waiter_details_model.dart';
import 'package:waiterr/theme.dart';

class WaiterList extends StatefulWidget {
  final List<List<WaiterDetailsModel>>? waiterList;
  final Function? header;
  final Function? buildItems;
  const WaiterList({Key? key, this.waiterList, this.buildItems, this.header})
      : super(key: key);
  @override
  State<WaiterList> createState() => _WaiterListState();
}

class _WaiterListState extends State<WaiterList> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: widget.waiterList!.map((group) {
      int index = widget.waiterList!.indexOf(group);
      return ExpandableGroup(
        expandedIcon: const Icon(
          Icons.arrow_drop_down,
          size: 40,
          color: GlobalTheme.waiterrPrimaryColor,
        ),
        collapsedIcon: const Icon(
          Icons.arrow_right,
          size: 40,
          color: GlobalTheme.waiterrPrimaryColor,
        ),
        isExpanded: true,
        header: widget.header!(widget.waiterList![index][0].outletName),
        items: widget.buildItems!(context, group),
        headerEdgeInsets: const EdgeInsets.only(left: 16.0, right: 16.0),
      );
    }).toList());
  }
}
