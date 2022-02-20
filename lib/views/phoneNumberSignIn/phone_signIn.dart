import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:saman/services/auth.dart';
import 'package:saman/views/business/businessHomePage/business_homePage.dart';
import 'package:saman/views/driver/driverHomePage/driver_homePage.dart';
import 'package:saman/views/role/role_selection.dart';
import 'package:saman/views/welcome/components/background.dart';
import 'package:saman/views/welcome/components/rounded_button.dart';
import 'package:saman/components/phone_otp.dart';
import 'package:saman/components/rounded_password_field.dart';
import 'package:saman/model/secure_storage.dart';
import 'package:saman/util/validate_password.dart';
import 'package:saman/constants.dart';
import 'package:saman/views/business/businessRegistration/business_registration_screen.dart';
import 'package:saman/views/driver/driverRegistration/driver_registration_screen.dart';
import 'package:saman/views/language_select/language_screen.dart';
import 'package:saman/util/validate_phone_number.dart';

class PhoneSignIn extends StatefulWidget {
  @override
  PhoneSignInState createState() => PhoneSignInState();
}

class PhoneSignInState extends State<PhoneSignIn> {
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool isLoading = false;
  final SharedPreference secureStorage = SharedPreference();
  String selectedCountryCode = '+92';

  void _onCountryChange(CountryCode countryCode) {
    selectedCountryCode = countryCode.toString();
  }

  String phone = "";
  String password = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      index: 0,
      child: isLoading == true
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(yellowColor)),
              ),
            )
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: size.height * 0.15),
                    Image.asset(
                      "assets/icons/logo-cropped.png",
                      width: size.width * 0.70,
                    ),
                    SizedBox(height: size.height * 0.01),
                    SizedBox(
                      width: size.width * 0.7,
                      child: Text(
                        error,
                        style: TextStyle(
                            color: Color.fromRGBO(211, 51, 48, 1),
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 24),
                      child: Row(
                        children: [
                          Theme(
                            data: ThemeData(
                              primaryColor: toastColor,
                              primaryColorDark: toastColor,
                              textSelectionTheme: TextSelectionThemeData(
                                  cursorColor: toastColor),
                            ),
                            child: CountryCodePicker(
                              textStyle: TextStyle(color: Colors.white),
                              initialSelection: selectedCountryCode,
                              onChanged: _onCountryChange,
                              showCountryOnly: false,
                              showOnlyCountryWhenClosed: false,
                              searchDecoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              boxDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: Colors.white),
                            ),
                          ),
                          Expanded(
                            child: buildTextField(phone),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 24),
                      child: RoundedPasswordField(
                        validator: (possiblePassword) =>
                            validatePassword(possiblePassword),
                        onChanged: (possiblePassword) {
                          setState(() {
                            password = possiblePassword;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.white),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OtpScreen(
                                            name: "forgot",
                                            userId: "0",
                                          )));
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RoundedButton(
                            height: size.height * 0.06,
                            width: size.width * 0.36,
                            fontSize: size.width/20 ,
                            text: "BACK",
                            color: whiteColor,

                            textColor: accountSelectionBackgroundColor,
                            press: () {
                              Navigator.pop(context);
                            },
                          ),
                          Spacer(),
                          RoundedButton(
                            height: size.height * 0.06,
                            width: size.width * 0.36,
                            text: "LOGIN",
                            fontSize: size.width/20 ,
                            color: yellowColor,
                            textColor: accountSelectionBackgroundColor,
                            press: () {
                              if (_formKey.currentState.validate()) {
                                setState(() => isLoading = true);
                                isLoading = true;
                                signInWithNumber();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  signInWithNumber() {
    Firestore.instance
        .collection("phoneNumberUsers")
        .where("number", isEqualTo: selectedCountryCode + phone.trim())
        .where("password", isEqualTo: password)
        .getDocuments()
        .then((value) => {
              setState(() {
                Firestore.instance
                    .collection("users")
                    .where("userId", isEqualTo: value.documents[0]['userId'])
                    .getDocuments()
                    .then((val) => {
                          if (!val.documents[0].data.containsKey('userType'))
                            {
                              isLoading = false,
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RoleSelection(
                                          userId: value.documents[0]
                                          ['userType']
                                              .toString(),
                                          status: value.documents[0]
                                          ['status']
                                      )),
                                      (route) => false),
                            }
                          else if (!val.documents[0].data
                              .containsKey('firstName'))
                            {
                              isLoading = false,
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => val.documents[0]
                                      ['userType'] ==
                                          "Business"
                                          ? BusinessRegistrationScreen(
                                          userId: value.documents[0]
                                          ['userType'],
                                          status: value.documents[0]
                                          ['status']
                                      )
                                          : DriverRegistrationScreen(
                                          userId: value.documents[0]
                                          ['userType'],
                                          status: value.documents[0]
                                          ['status']
                                      )),
                                      (route) => false),

                            }
                          else if (!value.documents[0].data
                              .containsKey('isVerified'))
                            {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OtpScreen(
                                        name: value.documents[0]
                                        ['userType'],
                                        userId: value.documents[0]
                                        ['userType'],
                                        status: value.documents[0]
                                        ['status'],
                                      )),
                                      (route) => false),

                            }
                          else
                            {
                              isLoading = false,
                              secureStorage.writeSecureData(
                                  'userId', "${val.documents[0]['userId']}"),
                              secureStorage.writeSecureData('userType',
                                  "${value.documents[0]['userType']}"),
                              if(value.documents[0]['status'] == 'true')
                                {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => val.documents[0]
                                          ['userType'] ==
                                              "Business"
                                              ? BusinessHomePage()
                                              : DriverHomePage()),
                                          (route) => false),
                                }
                              else
                                {
                                  AuthService().displayToastMessage("Your request is send to admin for approved", context)
                                }

                            }
                        });
              }),
            })
        .catchError((onError) {
     setState(() {
       AuthService()
           .displayToastMessage("Invalid phone number or password!", context);
       isLoading = false;
     });
    });
  }

  Widget buildTextField(
    dynamic controller,
  ) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      validator: (possibleNumber) => validatePhoneNumber(possibleNumber),
      onChanged: (possibleNumber) {
        setState(() {
          phone = possibleNumber;
        });
      },
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        //EdgeInsets.symmetric(vertical: 12, horizontal: 10.0),
        focusColor: Colors.white,
        fillColor: Colors.white,
        filled: true,
        hintText: "Number",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(28.0)),
            borderSide: BorderSide(color: Colors.white24)),
      ),
    );
  }
}
