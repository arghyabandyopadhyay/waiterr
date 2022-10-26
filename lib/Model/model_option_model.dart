import 'package:flutter/cupertino.dart';

class ModalOptionModel {
  final String particulars;
  final Function() onTap;
  final IconData icon;
  final Color? iconColor;
  ModalOptionModel(
      {required this.particulars,
      required this.onTap,
      required this.icon,
      this.iconColor});
}
