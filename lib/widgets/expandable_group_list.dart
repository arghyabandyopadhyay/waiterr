import 'package:flutter/material.dart';
import 'package:waiterr/theme.dart';

import 'expandable_group_widget.dart';

class ExpandableGroupList<T> extends StatefulWidget {
  final List<List<T>>? list;
  final Function? header;
  final Function? buildItems;
  const ExpandableGroupList(
      {super.key, this.list, this.buildItems, this.header});
  @override
  State<ExpandableGroupList> createState() => _ExpandableGroupListState();
}

class _ExpandableGroupListState extends State<ExpandableGroupList> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: widget.list!.map((group) {
      int index = widget.list!.indexOf(group);
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
        header: widget.header!(widget.list![index][0].outletName),
        items: widget.buildItems!(context, group),
        headerEdgeInsets: const EdgeInsets.only(left: 16.0, right: 16.0),
      );
    }).toList());
  }
}
