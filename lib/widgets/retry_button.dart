import 'package:waiterr/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RetryButton extends StatelessWidget {
  RetryButton({Key? key, this.onPressedVal}) : super(key: key);
  final onPressedVal;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
      height: 50,
      width: 200,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: GlobalTheme.floatingButtonBackground,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: GlobalTheme.floatingButtonBackground),
        onPressed: onPressedVal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              "Refresh ",
              style: TextStyle(
                  color: GlobalTheme.floatingButtonText,
                  fontSize: 20,
                  height: 2.0),
            ),
            Icon(
              Icons.refresh,
              color: GlobalTheme.floatingButtonText,
              size: 26,
            ),
          ],
        ),
      ),
    );
  }
}
