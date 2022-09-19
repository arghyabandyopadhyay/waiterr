import 'package:flutter/cupertino.dart';

class DrawerActionModel {
  final IconData? iconData;
  final String? title;
  final Function() onTap;
  DrawerActionModel({this.iconData, this.title, required this.onTap});
}
