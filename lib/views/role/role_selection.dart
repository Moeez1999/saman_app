import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saman/localization/localization_constants.dart';
import 'package:saman/model/secure_storage.dart';
import 'package:saman/views/business/businessRegistration/business_registration_screen.dart';
import 'package:saman/views/driver/driverRegistration/driver_registration_screen.dart';
import 'package:saman/views/welcome/components/background.dart';
import 'package:saman/views/welcome/components/rounded_button.dart';

import '../../constants.dart';

class RoleSelection extends StatefulWidget {
  final String userId;

   RoleSelection({@required this.userId});


  @override
  _RoleSelectionState createState() => _RoleSelectionState();
}

class _RoleSelectionState extends State<RoleSelection> {
  final SharedPreference secureStorage = SharedPreference();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        index: 1,
        child: isLoading == true
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(yellowColor)),
                ),
              )
            : Padding(
          padding:  EdgeInsets.symmetric(vertical: 8.0,horizontal: 24),
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * 0.15),
                      Image.asset(
                        "assets/icons/logo-cropped.png",
                        width: size.width * 0.70,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "Welcome to SAMAN Services",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Select an option to proceed",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding:  EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isLoading = true;
                                  goToBusinessRegistration();
                                });
                              },
                              child: Container(
                                width: size.width / 2,
                                height: size.height / 16,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: yellowColor,
                                ),
                                child: Padding(
                                  padding:  EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      getTranslated(context, 'business'),
                                      style: TextStyle(
                                          color: selectedColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: size.width * 0.06),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width / 16,
                            ),
                            Image.asset(
                              "assets/icons/building-icon.png",
                              width: size.width / 4,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding:  EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/icons/truck-icon.png",
                              width: size.width / 4,
                            ),
                            SizedBox(
                              width: size.width / 16,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isLoading = true;
                                  goToDriverRegistration();
                                });
                              },
                              child: Container(
                                width: size.width / 2,
                                height: size.height / 16,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: yellowColor,
                                ),
                                child: Padding(
                                  padding:  EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      getTranslated(context, 'driver'),
                                      style: TextStyle(
                                          color: selectedColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize:  size.width * 0.06),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      RoundedButton(
                        height: size.height * 0.06,
                        width: size.width * 0.36,
                        text: "Back",
                        fontSize: size.width/20 ,
                        color: whiteColor,
                        textColor: accountSelectionBackgroundColor,
                        press: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
              ),
            ),
      ),
    );
  }

  goToBusinessRegistration() {
    Firestore.instance
        .collection("users")
        .where("userId", isEqualTo: int.parse(widget.userId))
        .getDocuments()
        .then((val) => {
      Firestore.instance
          .collection("users")
          .document(val.documents[0].documentID)
          .updateData({'userType': 'Business'}).then((value) => {
        isLoading = false,
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    BusinessRegistrationScreen(userId: widget.userId,)),),
      }),
    });
  }

  goToDriverRegistration() {
    Firestore.instance
        .collection("users")
        .where("userId", isEqualTo: int.parse(widget.userId))
        .getDocuments()
        .then((val) => {
      Firestore.instance
          .collection("users")
          .document(val.documents[0].documentID)
          .updateData({'userType': 'Driver'}).then((value) => {
        isLoading = false,
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DriverRegistrationScreen(userId: widget.userId,)),),
      }),
    });
  }
}
