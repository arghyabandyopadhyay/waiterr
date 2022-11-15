import 'package:waiterr/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectionCard extends StatelessWidget {
  SelectionCard({Key? key, this.item, this.active, this.onTap})
      : super(key: key);

  final String? item;
  final bool? active;
  final onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 65,
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(
            color: GlobalTheme.selectionCardBorderColor,
            width: 0.5,
            style: BorderStyle.solid),
      ),
      child: Card(
        elevation: 0,
        // This ensures that the Card's children (including the ink splash) are clipped correctly.
        clipBehavior: Clip.antiAlias,
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: GlobalTheme.selectionCardSplashColor,
          // Generally, material cards do not have a highlight overlay.
          highlightColor: Colors.transparent,
          child: Stack(
            children: [
              Center(
                child: Text(
                  item!,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    Icons.check_circle,
                    size: 12,
                    color: active!
                        ? GlobalTheme.selectionCardCheckIconColor
                        : Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
