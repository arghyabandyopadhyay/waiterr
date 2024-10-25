import 'package:flutter/material.dart';

class GlobalTheme {
  //Static datas
  static Color tint = const Color.fromARGB(255, 180, 172, 240).withOpacity(0.7);
  static BoxDecoration waiterrAppBarBoxDecoration = const BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(30),
      topRight: Radius.circular(30),
    ),
    boxShadow: [boxShadow],
  );
  static const BoxShadow boxShadow = BoxShadow(
    color: GlobalTheme.borderColor,
    blurRadius: 25.0, // soften the shadow
    spreadRadius: 5.0, //extend the shadow
    offset: Offset(
      15.0, // Move to right 10  horizontally
      15.0, // Move to bottom 10 Vertically
    ),
  );

  static const bool internalScaffoldResizeToAvoidBottomInset = false;

  static const Color borderColor = Color(0XFF808080);
  static const Color waiterrPrimaryText = Color(0XFF808080);
  static const Color waiterrSecondaryText = Colors.black;
  // static const Color waiterrPrimaryColor = Color.fromARGB(255, 3, 63, 244);
  static const Color waiterrPrimaryColor = Color.fromARGB(255, 182, 150, 222);

  static const Color drawerDetailText = Colors.black;
  static const Color salePointNameColor = Colors.black;
  static const Color salePointTypeColor = Colors.black;
  static const Color outletNameColor = Colors.black;
  static const Color printIconColor = Color.fromARGB(255, 3, 63, 244);
  static const Color selectionCardBorderColor = Color(0XFF808080);
  static const Color borderColorHighlight = Color.fromARGB(255, 3, 63, 244);
  static const Color bottomNavBarBackgroundColor =
      Color.fromARGB(255, 224, 215, 240);
  static const Color boxDecorationColorHighlight =
      Color.fromARGB(255, 3, 63, 244);
  static const Color selectionCardCheckIconColor =
      Color.fromARGB(255, 109, 62, 166);
  static const Color commentIconColor = Color.fromARGB(255, 3, 63, 244);
  static Color selectionCardSplashColor =
      const Color.fromARGB(255, 3, 63, 244).withOpacity(0.12);
  //KOT Progress Status Indicator Global Values
  static Color orderApprovedColor = Colors.amber.shade800;
  static Color orderProcessedColor = Colors.blue.shade800;
  static Color orderDeliveredColor = Colors.green.shade800;
  static Color kotActiveColor = const Color.fromARGB(255, 3, 63, 244);
  static Color kotInActiveColor = const Color(0XFF808080);
  static var primaryGradient = [
    const Color.fromARGB(255, 249, 95, 195),
    const Color.fromARGB(255, 244, 3, 3)
  ];
  static var primaryGradientGreen = [
    const Color.fromARGB(255, 136, 249, 95),
    const Color.fromARGB(255, 21, 175, 62)
  ];
  static var primaryGradient2 = [
    const Color.fromARGB(255, 118, 106, 228),
    const Color.fromARGB(255, 72, 65, 141),
    const Color.fromARGB(255, 20, 16, 54)
  ];
  static var buttonGradient = [
    const Color.fromARGB(255, 202, 16, 165),
    const Color.fromARGB(255, 231, 35, 35)
  ];

  //Light theme datas
  Color primaryColor = const Color.fromARGB(255, 3, 63, 244);
  Color cursor = const Color.fromARGB(255, 3, 63, 244);
  Color primaryColorLight = const Color.fromARGB(255, 41, 216, 255);
  Color primaryText = const Color(0XFF808080);
  Color icon = const Color(0XFF808080);
  Color secondaryText = Colors.black;
  Color buttonColor = const Color.fromARGB(255, 20, 16, 54);
  Color buttonPressedColor = const Color.fromARGB(255, 55, 47, 124);
  Color floatingButtonText = Colors.white;
  Color floatingButtonBackground = const Color.fromARGB(255, 20, 16, 54);
  Color backgroundColorDim = const Color(0xFFf5f5f5);
  Color backgroundColor = const Color.fromARGB(255, 180, 172, 240);
  Color backgroundColorLoginPage = const Color.fromARGB(255, 255, 255, 255);
  Color progressBar = const Color.fromARGB(255, 20, 16, 54);
  Color appBarIconColor = const Color.fromARGB(255, 20, 16, 54);

  //Dark themes
  Color primaryColorDark = const Color.fromARGB(255, 3, 63, 244);
  Color primaryColorLightDark = const Color.fromARGB(255, 41, 216, 255);
  Color primaryTextDark = const Color(0XFF808080);
  Color cursorDark = const Color.fromARGB(255, 3, 63, 244);
  Color iconDark = const Color(0XFF808080);
  Color secondaryTextDark = Colors.black;
  Color buttonColorDark = const Color.fromARGB(255, 20, 16, 54);
  Color buttonPressedColorDark = const Color.fromARGB(255, 55, 47, 124);
  Color floatingButtonTextDark = Colors.white;
  Color floatingButtonBackgroundDark = const Color.fromARGB(255, 20, 16, 54);
  Color backgroundColorDimDark = const Color(0xFFf5f5f5);
  Color backgroundColorDark = const Color.fromARGB(255, 180, 172, 240);
  Color backgroundColorLoginPageDark = const Color.fromARGB(255, 255, 255, 255);
  Color progressBarDark = const Color.fromARGB(255, 20, 16, 54);
  Color appBarIconColorDark = const Color.fromARGB(255, 20, 16, 54);
}

class GlobalTextStyles {
  static TextStyle unlockYourDinelineTextStyle = TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.w600,
      color: GlobalTheme.primaryGradient2[1]);
  static TextStyle signInNowTextStyle = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: GlobalTheme.primaryGradient2[1]);
  static TextStyle loginHeaderTextStyle = TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.w700,
      color: GlobalTheme.primaryGradient2[1]);
  static TextStyle loginHeaderTextStyleMedium = TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w700,
      color: GlobalTheme.primaryGradient2[1]);

  static TextStyle otpHeaderTextStyle = TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.w700,
      color: GlobalTheme.primaryGradient2[1]);
  static TextStyle otpHeaderTextStyleMedium = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: GlobalTheme.primaryGradient2[0]);

  static TextStyle waiterrTextStyleLarge = TextStyle(
      fontSize: 40.0,
      fontWeight: FontWeight.w900,
      fontFamily: 'Dancing',
      color: GlobalTheme.primaryGradient2[1]);

  static TextStyle waiterrTextStyleAppBar = TextStyle(
      fontSize: 40.0,
      fontWeight: FontWeight.w900,
      fontFamily: 'Dancing',
      color: GlobalTheme.primaryGradient2[2]);

  static TextStyle waiterrTextStyle = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w900,
      fontFamily: 'Dancing',
      color: GlobalTheme.primaryGradient2[1]);

  static TextStyle searchTextStyle = const TextStyle(
      fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black);
}

class WaiterrThemeDatas {
  static GlobalTheme globalTheme = GlobalTheme();
  //Theme data variable [NOT TO BE EDITED]
  static ThemeData theme = ThemeData(
      scaffoldBackgroundColor: globalTheme.backgroundColor,
      primaryColorLight: globalTheme.primaryColorLight,
      elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return globalTheme.buttonPressedColor;
        } else {
          return globalTheme.buttonColor;
        }
      }))),
      appBarTheme: AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(color: globalTheme.appBarIconColor),
          backgroundColor: Colors.transparent),
      textTheme: TextTheme(
        displayLarge: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: globalTheme.secondaryText),
        displayMedium: TextStyle(fontSize: 17, color: globalTheme.primaryColor),
        displaySmall: TextStyle(color: globalTheme.primaryText),
        bodyMedium: TextStyle(color: globalTheme.primaryText),
        bodyLarge: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: globalTheme.secondaryText),
        titleMedium: TextStyle(color: globalTheme.primaryText),
      ),
      textSelectionTheme:
          TextSelectionThemeData(cursorColor: globalTheme.cursor),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(),
        hintStyle: TextStyle(color: globalTheme.primaryText),
        labelStyle: TextStyle(color: globalTheme.primaryText),
        focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: globalTheme.primaryColor)),
        contentPadding:
            const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
      ),
      iconTheme: IconThemeData(color: globalTheme.icon),
      progressIndicatorTheme:
          ProgressIndicatorThemeData(color: globalTheme.progressBar),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: globalTheme.floatingButtonBackground,
          foregroundColor: globalTheme.floatingButtonText));

  static ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: globalTheme.backgroundColorDark,
      primaryColorLight: globalTheme.primaryColorLightDark,
      elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return globalTheme.buttonPressedColorDark;
        } else {
          return globalTheme.buttonColorDark;
        }
      }))),
      appBarTheme: AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(color: globalTheme.appBarIconColorDark),
          backgroundColor: Colors.transparent),
      textTheme: TextTheme(
        displayLarge: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: globalTheme.secondaryTextDark),
        displayMedium:
            TextStyle(fontSize: 17, color: globalTheme.primaryColorDark),
        displaySmall: TextStyle(color: globalTheme.primaryTextDark),
        bodyMedium: TextStyle(color: globalTheme.primaryTextDark),
        titleMedium: TextStyle(color: globalTheme.primaryTextDark),
      ),
      textSelectionTheme:
          TextSelectionThemeData(cursorColor: globalTheme.cursorDark),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: globalTheme.primaryTextDark),
        labelStyle: TextStyle(color: globalTheme.primaryTextDark),
        focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: globalTheme.primaryColorDark)),
        contentPadding:
            const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
      ),
      iconTheme: IconThemeData(color: globalTheme.iconDark),
      progressIndicatorTheme:
          ProgressIndicatorThemeData(color: globalTheme.progressBarDark),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: globalTheme.floatingButtonBackgroundDark,
          foregroundColor: globalTheme.floatingButtonTextDark));
}
