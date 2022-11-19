import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:waiterr/Pages/Login/splash_page.dart';
import 'package:waiterr/theme.dart';
import 'global_class.dart';
import '../stores/login_store.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;
  void preloadAssets(BuildContext context) {
    precacheImage(const AssetImage('assets/img/veg.png'), context);
    precacheImage(const AssetImage('assets/img/nonveg.png'), context);
    precacheImage(const AssetImage('assets/img/background.jpg'), context);
    precacheImage(const AssetImage('assets/img/all_filter_icon.png'), context);
    precacheImage(const AssetImage('assets/img/profile.png'), context);
    // precacheImage(
    //     const AssetImage('assets/img/ays_splashscreen_portrait.png'), context);
  }

  @override
  Widget build(BuildContext context) {
    preloadAssets(context);
    UserDetail.currentUrl = "http://10.0.2.2:3000/api/";
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container(
              color: Colors.white,
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MultiProvider(
                providers: [
                  Provider<LoginStore>(
                    create: (_) => LoginStore(),
                  )
                ],
                child: AnimatedBuilder(
                    animation: settingsController,
                    builder: (BuildContext context, Widget? child) {
                      return MaterialApp(
                        // Providing a restorationScopeId allows the Navigator built by the
                        // MaterialApp to restore the navigation stack when a user leaves and
                        // returns to the app after it has been killed while running in the
                        // background.
                        restorationScopeId: 'app',

                        // Provide the generated AppLocalizations to the MaterialApp. This
                        // allows descendant Widgets to display the correct translations
                        // depending on the user's locale.
                        localizationsDelegates: const [
                          AppLocalizations.delegate,
                          GlobalMaterialLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate,
                          GlobalCupertinoLocalizations.delegate,
                        ],
                        supportedLocales: const [
                          Locale('en', ''), // English, no country code
                        ],

                        // Use AppLocalizations to configure the correct application title
                        // depending on the user's locale.
                        //
                        // The appTitle is defined in .arb files found in the localization
                        // directory.
                        onGenerateTitle: (BuildContext context) =>
                            AppLocalizations.of(context)!.appTitle,

                        // Define a light and dark color theme. Then, read the user's
                        // preferred ThemeMode (light, dark, or system default) from the
                        // SettingsController to display the correct theme.
                        theme: WaiterrThemeDatas.theme,
                        darkTheme: WaiterrThemeDatas.darkTheme,
                        themeMode: settingsController.themeMode,

                        // Define a function to handle named routes in order to support
                        // Flutter web url navigation and deep linking.
                        onGenerateRoute: (RouteSettings routeSettings) {
                          return MaterialPageRoute<void>(
                            settings: routeSettings,
                            builder: (BuildContext context) {
                              switch (routeSettings.name) {
                                case SettingsView.routeName:
                                  return SettingsView(
                                      controller: settingsController);
                                case SplashPage.routeName:
                                  return const SplashPage();
                                default:
                                  return const SplashPage();
                              }
                            },
                          );
                        },
                      );
                    }));
          }
          return Container(
            color: Colors.white,
          );
        });
  }
}
