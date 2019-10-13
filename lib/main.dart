import 'package:flutter/material.dart';
import 'package:giftcard_sender/home.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'applocalizations.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
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
        'Giftcard Sender',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      loadingText: Text("Loading"),
      image: Image.asset('assets/icon/giftIcon.png'),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: TextStyle(),
      photoSize: 100.0,
      loaderColor: Colors.blue,
    );
  }
}
