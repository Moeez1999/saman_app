import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saman/components/rounded_input_field.dart';
import 'package:saman/util/validate_email.dart';
import 'package:saman/views/welcome/components/background.dart';
import 'package:saman/views/welcome/components/rounded_button.dart';

import '../../constants.dart';

class ForgotPasswordScreen extends StatefulWidget {

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String email = '';
  FocusNode emailNode = FocusNode();
  bool isShow = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _formKey,
      body: Background(
          index: 0,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.15),
                  isShow == false
                      ? Container()
                      : Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  stops: [0.2, 0.9],
                                  colors: [
                                    skyBlueColor,
                                    backButtonColor,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: skyBlueColor),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Center(
                                child: Text("Please Check your email!",
                                    style: TextStyle(
                                        fontSize: size.height * 0.01 * 2,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white)),
                              ),
                            ),
                          ),
                        ),
                  isShow == false ? Container() : SizedBox(
                    height: 80,
                  ),
                  Center(
                    child: Image.asset(
                      "assets/icons/logo-cropped.png",
                      width: size.width * 0.70,
                    ),
                  ),
                  SizedBox(height: size.height * 0.08),
                  Text(
                    "Forgot your Password?",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Text(
                    "Confirm your e-mail and we'll send the instructions.",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  RoundedInputField(
                    validator: (possibleEmail) => validateEmail(possibleEmail),
                    hintText: "Your Email",
                    onChanged: (possibleEmail) {
                      setState(() {
                        email = possibleEmail;
                      });
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                      Spacer(),
                      RoundedButton(
                        height: size.height * 0.06,
                        width: size.width * 0.36,
                        text: "Confirm",

                        fontSize: size.width/20 ,
                        color: yellowColor,
                        textColor: textBoxColor,
                        press: () async {
                          if (_formKey.currentState.validate()) {
                            resetPassword(email);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then((value) => {
              isShow = true,
            })
        .catchError((e) {
      isShow = false;
    });
  }
}
