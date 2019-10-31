import 'package:flutter/material.dart';
import 'package:giftcard_sender/home.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:splashscreen/splashscreen.dart';
import 'applocalizations.dart';

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(fontFamily: 'Cairo'),
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ar', 'IQ'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      home: CustomeSplashScreen(),
    ));
  });
}

class CustomeSplashScreen extends StatefulWidget {
  @override
  _CustomeSplashScreenState createState() => _CustomeSplashScreenState();
}

class _CustomeSplashScreenState extends State<CustomeSplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds: Home(),
      title: Text(
        AppLocalizations.of(context).translate('app_header'),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      loadingText: Text(
        AppLocalizations.of(context).translate('loading'),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      image: Image.asset('assets/icon/icon.png'),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: TextStyle(),
      photoSize: 100.0,
      loaderColor: Colors.blue,
    );
  }
}
