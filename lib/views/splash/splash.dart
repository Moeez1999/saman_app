import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:saman/views/driver/driverHomePage/driver_homePage.dart';
import 'package:flutter/material.dart';
import 'package:saman/views/business/businessHomePage/business_homePage.dart';
import 'package:saman/views/welcome/welcome_screen.dart';
import 'package:saman/model/secure_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  final SharedPreference secureStorage = SharedPreference();
  bool isShow = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _firebaseMessaging.configure(
      onMessage: (message) async {},
      onResume: (message) async {},
      onLaunch: (message) async {},
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    userPresence();
    connect();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // goToHomePages() {
  //   secureStorage.readSecureData('userType').then((value) => {
  //         print(value),
  //         if (value == "Driver")
  //           {
  //             Timer(
  //                 Duration(seconds: 5),
  //                 () => Navigator.of(context).pushReplacement(MaterialPageRoute(
  //                     builder: (BuildContext context) => DriverHomePage()))),
  //           }
  //         else if (value == "Business")
  //           {
  //             Timer(
  //                 Duration(seconds: 5),
  //                 () => Navigator.of(context).pushReplacement(MaterialPageRoute(
  //                     builder: (BuildContext context) => BusinessHomePage()))),
  //           }
  //         else
  //           {
  //             Timer(
  //                 Duration(seconds: 5),
  //                 () => Navigator.of(context).pushReplacement(MaterialPageRoute(
  //                     builder: (BuildContext context) => WelcomeScreen()))),
  //           }
  //       });
  // }

  userPresence() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => WelcomeScreen()));
      // WelcomeScreen();
      // goToHomePages();
    } else {
      setState(() {
        isShow = true;
      });
    }
  }

  connect() {
    Connectivity().onConnectivityChanged.first.then((value) => {
          if (value == ConnectivityResult.mobile ||
              value == ConnectivityResult.wifi)
            {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => WelcomeScreen()))
              // goToHomePages(),
            }
          else
            {
              setState(() {
                isShow = true;
              }),
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          child: Image.asset(
            "assets/icons/animatedSplash.gif",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
        ),
        isShow == true
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "No Internet\nPlease Check your Internet!",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              )
            : Container(),
      ],
    ));
  }
}
