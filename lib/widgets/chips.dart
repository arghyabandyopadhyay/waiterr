import 'package:flutter/material.dart';

import '../theme.dart';

class Chips extends StatelessWidget {
  const Chips(
      {Key? key,
      this.item,
      this.indexSelected,
      required this.onSelected,
      this.index})
      : super(key: key);

  final String? item;
  final int? indexSelected;
  final int? index;
  final Function(bool) onSelected;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        children: [
          ChoiceChip(
              selectedColor: GlobalTheme.waiterrPrimaryColor,
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(4),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
              elevation: 2,
              label: Text(
                item!,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              selected: indexSelected == index,
              onSelected: onSelected),
          const SizedBox(width: 8)
        ],
      ),
    );
  }
}
