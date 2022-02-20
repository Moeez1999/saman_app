import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saman/components/rounded_input_field.dart';
import 'package:saman/components/rounded_password_field.dart';
import 'package:saman/constants.dart';
import 'package:saman/model/secure_storage.dart';
import 'package:saman/services/auth.dart';
import 'package:saman/util/validate_email.dart';
import 'package:saman/util/validate_non_empty.dart';
import 'package:saman/util/validate_password.dart';
import 'package:saman/views/language_select/language_screen.dart';
import 'package:saman/views/role/role_selection.dart';
import 'package:saman/views/welcome/components/background.dart';
import 'package:saman/views/welcome/components/rounded_button.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class EmailSignUp extends StatefulWidget {
  @override
  EmailSignUpState createState() => EmailSignUpState();
}

class EmailSignUpState extends State<EmailSignUp> {
  final _formKey = GlobalKey<FormState>();
  final SharedPreference secureStorage = SharedPreference();
  FocusNode emailNode = FocusNode();
  FocusNode nameNode = FocusNode();
  String error = '';
  bool isPhone = false;
  bool isLoading = false;
  String selectedCountryCode = '+92';

  void _onCountryChange(CountryCode countryCode) {
    selectedCountryCode = countryCode.toString();
  }

  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();

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
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: size.height * 0.15),
                      Image.asset(
                        "assets/icons/logo-cropped.png",
                        width: size.width * 0.70,
                      ),
                      SizedBox(height: size.height * 0.03),
                      Row(
                        children: [
                          Text(
                            "Create your Account",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.01),
                      RoundedInputField(
                        validator: (name) => validateNonEmpty(name),
                        hintText: "Username",
                        textColor: primaryColor,
                        // fillColor: yellowColor,
                        onChanged: (name1) {
                          setState(() {
                            name.text = name1;
                          });
                        },
                      ),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      isPhone == false
                          ? RoundedInputField(
                              validator: (possibleEmail) =>
                                  validateEmail(possibleEmail),
                              hintText: "Email",
                              textColor: primaryColor,
                              // fillColor: yellowColor,
                              onChanged: (possibleEmail) {
                                setState(() {
                                  email.text = possibleEmail;
                                });
                              },
                            )
                          : Row(
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
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                  ),
                                ),
                                Expanded(child: buildTextField(phone)),
                              ],
                            ),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      RoundedPasswordField(
                        textColor: primaryColor,
                        // fillColor: yellowColor,

                        validator: (possiblePassword) =>
                            validatePassword(possiblePassword),
                        onChanged: (possiblePassword) {
                          setState(() {
                            password.text = possiblePassword;
                          });
                        },
                      ),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      RoundedPasswordField(
                        // fillColor: yellowColor,
                        textColor: primaryColor,
                        password: "Confirm password",
                        validator: (possiblePassword) {
                          if (possiblePassword.isEmpty) {
                            return "Required field";
                          } else if (possiblePassword != password.text) {
                            return "Password must match";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (possiblePassword) {
                          setState(() {
                            confirmpassword.text = possiblePassword;
                          });
                        },
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
                            text: "BACK",
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
                            text: "SIGN UP",
                            fontSize: size.width / 20,
                            color: yellowColor,
                            textColor: Colors.green,
                            press: () async {
                              isPhone == false
                                  ? checkValid()
                                  : signInWithNumber();
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            isPhone == false
                                ? "SignUp with phone number? "
                                : "SignUp with E-mail? ",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          GestureDetector(
                            onTap: () {
                              print(isPhone);
                              setState(() {
                                if (isPhone == true) {
                                  isPhone = false;
                                } else if (isPhone == false) {
                                  setState(() {
                                    isPhone = true;
                                  });
                                }
                              });
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  checkValid() {
    if (_formKey.currentState.validate()) {
      setState(() => isLoading = true);
      signUpWithEmailAndPassword(context);
    } else {
      print("error");
    }
  }

  signInWithNumber() {
    if (_formKey.currentState.validate()) {
      setState(() => isLoading = true);
      Firestore.instance.collection('userList').getDocuments().then((value) => {
            Firestore.instance
                .collection("users")
                .document()
                .setData({
                  "name": name.text,
                  "status": "false",
                  "number": selectedCountryCode + phone.text.trim(),
                  "userId": value.documents[0]['userId'] + 1
                })
                .then((value) => {
                      Firestore.instance
                          .collection("userList")
                          .getDocuments()
                          .then(
                            (value1) => {
                              secureStorage.writeSecureData('userId',
                                  "${value1.documents[0]['userId'] + 1}"),
                              Firestore.instance
                                  .collection("userList")
                                  .document(value1.documents[0].documentID)
                                  .updateData({
                                "userId": value1.documents[0]['userId'] + 1
                              }),
                              Firestore.instance
                                  .collection("phoneNumberUsers")
                                  .document()
                                  .setData({
                                "status": "false",
                                "userId": value1.documents[0]['userId'] + 1,
                                "number":
                                    selectedCountryCode + phone.text.trim(),
                                'password': password.text
                              }).then(
                                (value) => {
                                  isLoading = false,
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(
                                    builder: (context) {
                                      return RoleSelection(
                                        userId: value1.documents[0]['userId'],
                                        status: "false",
                                      );
                                    },
                                  ), (route) => false),
                                },
                              )
                            },
                          )
                    })
                .catchError((e) {
                  isLoading = false;
                  print("error");
                  print(e);
                }),
          });
    } else {
      isLoading = false;
      print("error");
    }
  }

  Future signUpWithEmailAndPassword(BuildContext context) async {
    try {
      final FirebaseUser firebaseUser =
          (await _auth.createUserWithEmailAndPassword(
                  email: email.text.trim(), password: password.text))
              .user;
      if (firebaseUser != null) {
        Firestore.instance.collection('userList').getDocuments().then((value) =>
            {
              Firestore.instance
                  .collection("users")
                  .document(firebaseUser.uid.toString())
                  .setData({
                    "name": name.text,
                    "status": "false",
                    "email": email.text.trim(),
                    "id": firebaseUser.uid.toString(),
                    "userId": value.documents[0]['userId'] + 1
                  })
                  .then((value) => {
                        Firestore.instance
                            .collection("userList")
                            .getDocuments()
                            .then((value1) => {
                                  secureStorage.writeSecureData('userId',
                                      "${value1.documents[0]['userId'] + 1}"),
                                  Firestore.instance
                                      .collection("userList")
                                      .document(value1.documents[0].documentID)
                                      .updateData({
                                    "userId": value1.documents[0]['userId'] + 1
                                  }).then((value) => {
                                            isLoading = false,
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        RoleSelection(
                                                          userId:
                                                              "${value1.documents[0]['userId'] + 1}",
                                                          status: 'false',
                                                        )),
                                                (route) => false),
                                          },
                                  )
                                },
                        )
                      })
                  .catchError((e) {
                    isLoading = false;
                    print("error");
                    print(e);
                  }),
            });
      } else {
        setState(() {
          isLoading = false;
          AuthService()
              .displayToastMessage("Account has not been created.", context);
        });
      }
    } on PlatformException catch (err) {
      print("Exception caught => $err");
      print(err.message);
      setState(() {
        if (err.message ==
            "The email address is already in use by another account.") {
          isLoading = false;
          AuthService().displayToastMessage("User Already exists", context);
        } else {
          isLoading = false;
          AuthService().displayToastMessage(
              "Something went wrong!\nPlease try again Later", context);
        }
      });
    }
  }

  Widget buildTextField(
    dynamic controller,
  ) {
    return TextFormField(
      validator: (e) {
        if (e.isEmpty) {
          return "Required Field";
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.phone,
      controller: controller,
      style: TextStyle(color: primaryColor),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        //EdgeInsets.symmetric(vertical: 12, horizontal: 10.0),
        focusColor: Colors.white,
        fillColor: whiteColor,
        filled: true,
        hintText: "Number",
        hintStyle: TextStyle(color: primaryColor),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(28.0)),
            borderSide: BorderSide(color: Colors.white24)),
      ),
    );
  }
}
