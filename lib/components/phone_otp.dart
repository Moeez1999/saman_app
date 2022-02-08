import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saman/components/rounded_input_field.dart';
import 'package:saman/services/auth.dart';
import 'package:saman/views/business/businessHomePage/business_homePage.dart';
import 'package:saman/views/driver/driverHomePage/driver_homePage.dart';
import 'package:saman/views/phoneNumberSignIn/changePassword.dart';
import 'package:saman/views/welcome/components/background.dart';
import 'package:saman/views/welcome/components/rounded_button.dart';
import 'package:saman/model/secure_storage.dart';
import '../constants.dart';

class OtpScreen extends StatefulWidget {
  final String name;
  final String userId;
  final String status;

  const OtpScreen({this.name, @required this.userId, this.status});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final SharedPreference secureStorage = SharedPreference();
  TextEditingController number = TextEditingController();
  FocusNode otpNode = FocusNode();
  FocusNode numberNode = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String pin;
  String _verificationCode;
  String selectedCountryCode = '+92';

  void _onCountryChange(CountryCode countryCode) {
    selectedCountryCode = countryCode.toString();
  }

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldkey,
        body: Background(
          index: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
            child: isLoading == true
                ? Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(yellowColor)))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: size.height * 0.15),
                        Center(
                          child: Image.asset(
                            "assets/icons/logo-cropped.png",
                            width: size.width * 0.70,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Please enter your phone number",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Through SMS a verification code will be send to the number you provided",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.0425,
                        ),
                        Row(
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
                              child: Center(
                                child: RoundedInputField(
                                  type: TextInputType.phone,
                                  hintText: "Phone Number",
                                  onChanged: (possibleEmail) {
                                    setState(() {
                                      number.text = possibleEmail;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.0425,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RoundedButton(
                              height: size.height * 0.06,
                              width: size.width * 0.36,
                              text: "Back",
                              fontSize: size.width / 20,
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
                              fontSize: size.width / 20,
                              text: "Next",
                              color: yellowColor,
                              textColor: accountSelectionBackgroundColor,
                              press: () async {
                                if (number.text.isEmpty) {
                                  AuthService().displayToastMessage(
                                      "Please Provide Phone number!", context);
                                } else {
                                  if (widget.name == "forgot") {
                                    print("ifffffff");
                                    checkAvailabilityPhone();
                                  } else {
                                    print("elseee");
                                    _showMyDialog(context);
                                    _verifyPhone();
                                  }
                                }
                                numberNode.unfocus();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        ));
  }

  pinputFunction() async {
    await FirebaseAuth.instance
        .signInWithCredential(PhoneAuthProvider.getCredential(
            verificationId: _verificationCode, smsCode: pin))
        .then((value) async {
      if (value.user != null) {
        setState(() {
          if (widget.name == "Business") {
            Map<String, dynamic> data = {
              "number": selectedCountryCode + number.text,
              "isVerified": true
            };
            Firestore.instance
                .collection("users")
                .where("userId", isEqualTo: int.parse(widget.userId))
                .getDocuments()
                .then((val) => {
                      secureStorage.writeSecureData(
                          'userType', "${val.documents[0]['userType']}"),
                      secureStorage.writeSecureData('userId', widget.userId),
                      Firestore.instance
                          .collection("users")
                          .document(val.documents[0].documentID)
                          .updateData(data)
                          .then((value) => {
                                isLoading = false,
                                if (widget.status == 'true' || val.documents[0]['status'] == 'true')
                                  {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BusinessHomePage()),
                                        (route) => false)
                                  }
                                else
                                  {
                                    Get.snackbar('Warning',
                                        'Your request send to admin for approved')
                                  }
                              })
                          .catchError((e) {
                        print(e);
                      }),
                    });
          } else if (widget.name == "Driver") {
            Map<String, dynamic> data = {
              "number": selectedCountryCode + number.text,
              "isVerified": true
            };
            Firestore.instance
                .collection("users")
                .where("userId", isEqualTo: int.parse(widget.userId))
                .getDocuments()
                .then((val) => {
                      secureStorage.writeSecureData(
                          'userType', "${val.documents[0]['userType']}"),
                      secureStorage.writeSecureData('userId', widget.userId),
                      Firestore.instance
                          .collection("users")
                          .document(val.documents[0].documentID)
                          .updateData(data)
                          .then((value) => {
                                isLoading = false,
                                if (widget.status == 'true' || val.documents[0]['status'] == 'true')
                                  {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DriverHomePage()),
                                        (route) => false),
                                  }
                                else
                                  {
                                    Get.snackbar('Warning',
                                        'Your request send to admin for approved')
                                  }
                              })
                          .catchError((e) {
                        isLoading = false;
                        print(e);
                      }),
                    });
          } else if (widget.name == "forgot") {
            isLoading = false;
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => ChangePasswordScreen(
                          number: selectedCountryCode + number.text,
                        )),
                (route) => false);
          } else {
            print("error");
          }
        });
      } else {
        print("error ma aya");
        isLoading = false;
        Navigator.pop(context);
        FocusScope.of(context).unfocus();
        _scaffoldkey.currentState
            .showSnackBar(SnackBar(content: Text('invalid OTP')));
        otpNode.unfocus();
        numberNode.unfocus();
      }
    }).catchError((e) {
      isLoading = false;
      print("error ma aya");
      Navigator.pop(context);
      FocusScope.of(context).unfocus();
      _scaffoldkey.currentState
          .showSnackBar(SnackBar(content: Text('invalid OTP')));
      otpNode.unfocus();
      numberNode.unfocus();
    });
  }

  _verifyPhone() async {
    print(selectedCountryCode + number.text);
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: selectedCountryCode + number.text,
        verificationCompleted: (AuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              setState(() {
                if (widget.name == "Business") {
                  Map<String, dynamic> data = {
                    "number": selectedCountryCode + number.text,
                    "isVerified": true
                  };
                  Firestore.instance
                      .collection("users")
                      .where("userId", isEqualTo: int.parse(widget.userId))
                      .getDocuments()
                      .then((val) => {
                            secureStorage.writeSecureData(
                                'userId', widget.userId),
                            secureStorage.writeSecureData(
                                'userType', "${val.documents[0]['userType']}"),
                            Firestore.instance
                                .collection("users")
                                .document(val.documents[0].documentID)
                                .updateData(data)
                                .then((value) => {
                                      if (widget.status == "true")
                                        {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BusinessHomePage()),
                                              (route) => false),
                                        }
                                      else
                                        {
                                          Get.snackbar('Warning',
                                              'Your request send to admin for approved')
                                        }
                                    })
                                .catchError((e) {
                              print(e);
                            }),
                          });
                } else if (widget.name == "Driver") {
                  Map<String, dynamic> data = {
                    "number": selectedCountryCode + number.text,
                    "isVerified": true
                  };
                  Firestore.instance
                      .collection("users")
                      .where("userId", isEqualTo: int.parse(widget.userId))
                      .getDocuments()
                      .then((val) => {
                            secureStorage.writeSecureData(
                                'userId', widget.userId),
                            secureStorage.writeSecureData(
                                'userType', "${val.documents[0]['userType']}"),
                            Firestore.instance
                                .collection("users")
                                .document(val.documents[0].documentID)
                                .updateData(data)
                                .then((value) => {
                                      if (widget.status == "true")
                                        {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DriverHomePage()),
                                              (route) => false),
                                        }
                                      else
                                        {
                                          Get.snackbar('Warning',
                                              'Your request send to admin for approved')
                                        }
                                    })
                                .catchError((e) {
                              print(e);
                            }),
                          });
                } else if (widget.name == "forgot") {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePasswordScreen(
                                number: selectedCountryCode + number.text,
                              )),
                      (route) => false);
                } else {
                  print("error");
                }
              });
            } else {
              print("error");
            }
          });
        },
        verificationFailed: (AuthException e) async {
          print(e.message);
        },
        codeSent: (String verficationID, [int resendToken]) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 60));
  }

  checkAvailabilityPhone() {
    Firestore.instance
        .collection("phoneNumberUsers")
        .where("number", isEqualTo: selectedCountryCode + number.text)
        .getDocuments()
        .then((value) => {
              print(value.documents[0].documentID),
              _verifyPhone(),
              _showMyDialog(context),
            })
        .catchError((e) {
      AuthService().displayToastMessage("No account!", context);
    });
  }

  _showMyDialog(context) {
    Size size = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: accountSelectionBackgroundColor,
          content: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  "assets/icons/lock.png",
                  height: 100,
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                    onChanged: (code) {
                      setState(() {
                        pin = code;
                      });
                    },
                    maxLength: 6,
                    focusNode: otpNode,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(12),
                      //EdgeInsets.symmetric(vertical: 12, horizontal: 10.0),
                      focusColor: Colors.white,
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "SMS verification code",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(28.0)),
                          borderSide: BorderSide(color: Colors.white24)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundedButton(
                      height: size.height * 0.05,
                      width: size.width * 0.26,
                      text: "Back",
                      fontSize: size.width / 23,
                      color: whiteColor,
                      textColor: accountSelectionBackgroundColor,
                      press: () {
                        setState(() {
                          Navigator.pop(context);
                          isLoading = false;
                        });
                      },
                    ),
                    SizedBox(
                      width: size.width * 0.05,
                    ),
                    RoundedButton(
                      height: size.height * 0.05,
                      width: size.width * 0.30,
                      text: "Confirm",
                      fontSize: size.width / 23,
                      color: yellowColor,
                      textColor: textBoxColor,
                      press: () async {
                        otpNode.unfocus();
                        print(widget.userId);
                        Navigator.pop(context);
                        pinputFunction();
                        isLoading = true;
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
