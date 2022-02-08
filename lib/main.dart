// @dart=2.9
import 'package:flutter/material.dart';
import 'package:saman/views/splash/splash.dart';
import 'package:saman/localization/localization_constants.dart';

void main() async {
  //
  // runApp( DevicePreview(
  //   enabled: true,
  //   builder: (context) => Saman(), // Wrap your app
  // ),);
  runApp(Saman());
}

class Saman extends StatefulWidget {
  // This widget is the root of your application.
  static void setLocale(BuildContext context, Locale newLocale) {
    _SamanState state = context.findAncestorStateOfType<_SamanState>();
    state.setLocale(newLocale);
  }

  @override
  _SamanState createState() => _SamanState();
}

class _SamanState extends State<Saman> {
  Locale _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientationxc.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'saman',
      // localizationsDelegates: [
      //   AppLocalization.delegate,
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      // locale: _locale,
      // supportedLocales: [
      //   Locale('en', 'US'), // English, no country codes
      //   Locale('ur', 'PK'), // Spanish, no country code
      // ],
      // localeResolutionCallback: (locale, supportedLocales) {
      //   for (var supportedLocale in supportedLocales) {
      //     if (supportedLocale.languageCode == locale.languageCode &&
      //         supportedLocale.countryCode == locale.countryCode) {
      //       return supportedLocale;
      //     }
      //   }
      //   return supportedLocales.first;
      // },
      home: SplashScreen(),
    );
  }
}
