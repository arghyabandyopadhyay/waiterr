import 'package:waiterr/Model/menu_item_model.dart';
import 'expandable_group_widget.dart';
import 'package:flutter/material.dart';
import 'package:waiterr/theme.dart';

class MenuManagerList extends StatefulWidget {
  final List<List<MenuItemModel>>? productList;
  final Function? header;
  final Function? buildItems;
  const MenuManagerList(
      {Key? key, this.productList, this.buildItems, this.header})
      : super(key: key);
  @override
  State<MenuManagerList> createState() => _MenuManagerListState();
}

class _MenuManagerListState extends State<MenuManagerList> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: widget.productList!.map((group) {
      int index = widget.productList!.indexOf(group);
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
        header: widget.header!(widget.productList![index][0].outletName),
        items: widget.buildItems!(context, group),
        headerEdgeInsets: const EdgeInsets.only(left: 16.0, right: 16.0),
      );
    }).toList());
  }
}
