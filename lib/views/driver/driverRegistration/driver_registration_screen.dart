import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:saman/components/language_button.dart';
import 'package:saman/components/phone_otp.dart';
import 'package:saman/model/secure_storage.dart';
import 'package:saman/services/auth.dart';
import 'package:saman/views/welcome/components/rounded_button.dart';
import 'package:saman/views/welcome/welcome_screen.dart';
import '../../../constants.dart';
import 'package:saman/localization/localization_constants.dart';
import 'package:saman/main.dart';
import 'dart:async';

class DriverRegistrationScreen extends StatefulWidget {
  final String userId;

  DriverRegistrationScreen({@required this.userId});
  @override
  _DriverRegistrationScreenState createState() =>
      _DriverRegistrationScreenState();
}

class _DriverRegistrationScreenState extends State<DriverRegistrationScreen> {
  TextEditingController cnic = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController driverLicenseNumber = TextEditingController();
  TextEditingController vehicleRegistrationNumber = TextEditingController();
  final SharedPreference secureStorage = SharedPreference();
  String selectedCountryCode = '+92';
  String _value = 'en';
  bool isLoading = false;
  String index = "openPickup";

  void _changeLanguage(language) async {
    Locale _locale = await setLocale(language);
    Saman.setLocale(context, _locale);
    Timer(Duration(seconds: 1), () => Navigator.of(context).pop());
  }

  @override
  void initState() {
    getLocale().then((locale) {
      setState(() {
        print(locale.languageCode);
        _value = locale.languageCode;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: yellowColor),
        actions: [
          LanguageButton(
          )
        ],
        title: Text(
          "Driver Registration",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: accountSelectionBackgroundColor,
      ),
      body: Container(
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Positioned(
              child: Image.asset(
                'assets/icons/sp-screen.png',
                width: size.width,
                color: Color(0xff007A4D),
                height: size.height,
                fit: BoxFit.cover,
              ),
            ),
            isLoading == true
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(yellowColor))
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 24),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          buildTextField(
                              getTranslated(context, 'firstName'),
                              firstName,
                              "assets/icons/person.png",
                              1,
                              TextInputType.name,
                              TextCapitalization.words),
                          buildTextField(
                              getTranslated(context, 'lastName'),
                              lastName,
                              "assets/icons/id-card.png",
                              1,
                              TextInputType.name,TextCapitalization.words),
                          // Row(
                          //   children: [
                          //     Padding(
                          //       padding: const EdgeInsets.only(left: 8),
                          //       child: Theme(
                          //         data: ThemeData(
                          //           primaryColor: toastColor,
                          //           primaryColorDark: toastColor,
                          //           textSelectionTheme: TextSelectionThemeData(
                          //               cursorColor: toastColor),
                          //         ),
                          //         child: CountryCodePicker(
                          //           textStyle: TextStyle(color: Colors.white),
                          //           initialSelection: selectedCountryCode,
                          //           onChanged: _onCountryChange,
                          //           showCountryOnly: false,
                          //           showOnlyCountryWhenClosed: false,
                          //           searchDecoration: InputDecoration(
                          //             border: OutlineInputBorder(),
                          //           ),
                          //           boxDecoration: BoxDecoration(
                          //               borderRadius: BorderRadius.circular(7),
                          //               color: Colors.white),
                          //         ),
                          //       ),
                          //     ),
                          //     Expanded(
                          //       child: buildTextField(
                          //           getTranslated(context, 'number'),
                          //           number,
                          //           "assets/icons/yellow-call-icon.png",
                          //           1,
                          //           TextInputType.phone,TextCapitalization.none),
                          //     ),
                          //   ],
                          // ),
                          buildTextField1(
                              getTranslated(context, 'cnic'),
                              cnic,
                              "assets/icons/building2-icon.png",
                              1,
                              TextInputType.number),
                          buildTextField(
                              getTranslated(context, 'driverLicenseNumber'),
                              driverLicenseNumber,
                              "assets/icons/driving-license.png",
                              1,
                              TextInputType.number,TextCapitalization.none),
                          buildTextField(
                              getTranslated(context, 'vehicleRegistrationNumber'),
                              vehicleRegistrationNumber,
                              "assets/icons/open-pickup.png",
                              1,
                              TextInputType.text,TextCapitalization.sentences),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Text(
                                  getTranslated(context, 'selectVehicleType'),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    index = "openPickup";
                                  });
                                },
                                child: Container(
                                  width: size.width / 2.5,
                                  decoration: BoxDecoration(
                                      color: index == "openPickup"
                                          ? selectedColorVehicle
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                          color: yellowColor,
                                          width: 2,
                                          style: BorderStyle.solid)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          "assets/icons/open-pickup.png",
                                          height: 40,
                                        ),
                                        Text(getTranslated(context, 'openPickup'),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: yellowColor)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    index = "closePickup";
                                  });
                                },
                                child: Container(
                                  width: size.width / 2.4,
                                  decoration: BoxDecoration(
                                      color: index == "closePickup"
                                          ? selectedColorVehicle
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                          color: yellowColor,
                                          width: 2,
                                          style: BorderStyle.solid)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(getTranslated(context, 'closePickup'),
                                            style: TextStyle(
                                                color: yellowColor,
                                                fontWeight: FontWeight.bold)),
                                        Image.asset(
                                          "assets/icons/closed-pickup.png",
                                          height: 40,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    index = "loaderRicksha";
                                  });
                                },
                                child: Container(
                                  width: size.width / 2.3,
                                  decoration: BoxDecoration(
                                      color: index == "loaderRicksha"
                                          ? selectedColorVehicle
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                          color: yellowColor,
                                          width: 2,
                                          style: BorderStyle.solid)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          "assets/icons/ricksha.png",
                                          height: 40,
                                        ),
                                        Text(getTranslated(context, 'loaderRicksha'),
                                            style: TextStyle(
                                                color: yellowColor,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    index = "deliveryTruck";
                                  });
                                },
                                child: Container(
                                  width: size.width / 2.4,
                                  decoration: BoxDecoration(
                                      color: index == "deliveryTruck"
                                          ? selectedColorVehicle
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                          color: yellowColor,
                                          width: 2,
                                          style: BorderStyle.solid)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(getTranslated(context, 'deliveryTruck'),
                                            style: TextStyle(
                                                color: yellowColor,
                                                fontWeight: FontWeight.bold)),
                                        Image.asset(
                                          "assets/icons/truck.png",
                                          height: 40,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RoundedButton(
                                height: size.height * 0.06,
                                width: size.width * 0.36,
                                text: getTranslated(context, 'back'),
                                color: whiteColor,
                                textColor: accountSelectionBackgroundColor,
                                fontSize: size.width/20 ,
                                press: () {
                                  // Navigator.pushAndRemoveUntil(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => WelcomeScreen()),
                                  //     (route) => false);
                                  Navigator.pop(context);
                                },
                              ),
                              Spacer(),
                              RoundedButton(
                                height: size.height * 0.06,
                                width: size.width * 0.36,
                                text: getTranslated(context, 'save'),
                                color: yellowColor,
                                fontSize: size.width/20 ,
                                textColor: textBoxColor,
                                press: () async {
                                  if (firstName.text.isEmpty) {
                                    AuthService().displayToastMessage(
                                        getTranslated(context, 'enterFirstName'),
                                        context);
                                  } else if (lastName.text.isEmpty) {
                                    AuthService().displayToastMessage(
                                        getTranslated(context, 'enterLastName'),
                                        context);
                                  } else if (cnic.text.isEmpty) {
                                    AuthService().displayToastMessage(
                                        getTranslated(context, 'enterCnic'),
                                        context);
                                  } else if (driverLicenseNumber.text.isEmpty) {
                                    AuthService().displayToastMessage(
                                        getTranslated(
                                            context, 'enterDrivingLicense'),
                                        context);
                                  } else if (vehicleRegistrationNumber
                                      .text.isEmpty) {
                                    AuthService().displayToastMessage(
                                        getTranslated(
                                            context, 'enterRegistrationNumber'),
                                        context);
                                  } else {
                                    isLoading = true;
                                    driverRegistrationFunction();
                                  }
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  driverRegistrationFunction() {
    Map<String, dynamic> data = {
      "CNIC": cnic.text,
      "firstName": firstName.text,
      "lastName": lastName.text,
      // "number": selectedCountryCode + number.text,
      "driverLicenseNumber": driverLicenseNumber.text,
      "vehicleRegistrationNumber": vehicleRegistrationNumber.text,
      "vehicleType":index,
      "profilePic":""
    };
    Firestore.instance
        .collection("users")
        .where("userId", isEqualTo: int.parse(widget.userId))
        .getDocuments()
        .then((val) => {
      Firestore.instance
          .collection("users")
          .document(val.documents[0].documentID)
          .updateData(data)
          .then((value) => {
        isLoading = false,
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OtpScreen(
                userId: widget.userId,
                name: 'Driver',
              )),
        ),
      })
          .catchError((e) {
        isLoading = false;
      }),
    }).catchError((e){
      isLoading = false;
    });
  }

  void _onCountryChange(CountryCode countryCode) {
    selectedCountryCode = countryCode.toString();
  }

  Widget buildTextField(
      text, dynamic controller, icon, int lines, dynamic type,dynamic textCapitalization) {
    return Column(
      children: [
        TextField(
          keyboardType: type,
          textCapitalization: textCapitalization,
          controller: controller,
          maxLines: lines,
          decoration: InputDecoration(
              contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  icon,
                  height: 10,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(28.0),
              ),
              filled: true,
              hintStyle: TextStyle(color: Colors.white),
              hintText: text,
              fillColor: Color(0xff338F6D)),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  Widget buildTextField1(
      text, dynamic controller, icon, int lines, dynamic type) {
    return Column(
      children: [
        TextField(
          keyboardType: type,

          maxLength: 13,
          controller: controller,
          maxLines: lines,
          decoration: InputDecoration(
              contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  icon,
                  height: 10,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(28.0),
              ),
              filled: true,
              hintStyle: TextStyle(color: Colors.white),
              hintText: text,
              fillColor: Color(0xff338F6D)),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
