import 'package:flutter/material.dart';
import '../theme.dart';

class WelcomeToWaiterr extends StatelessWidget {
  const WelcomeToWaiterr({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: [
        TextSpan(
          text: 'Welcome to ',
          style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.w600,
              color: GlobalTheme.primaryGradient2[1]),
        ),
        TextSpan(
            text: 'Waiterr', style: GlobalTextStyles.waiterrTextStyleLarge),
      ]),
    );
  }
}
