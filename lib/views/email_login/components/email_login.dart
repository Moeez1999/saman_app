import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:saman/components/phone_otp.dart';
import 'package:saman/components/rounded_input_field.dart';
import 'package:saman/components/rounded_password_field.dart';
import 'package:saman/model/secure_storage.dart';
import 'package:saman/services/auth.dart';
import 'package:saman/util/validate_email.dart';
import 'package:saman/util/validate_password.dart';
import 'package:saman/constants.dart';
import 'package:saman/views/business/businessHomePage/business_homePage.dart';
import 'package:saman/views/business/businessRegistration/business_registration_screen.dart';
import 'package:saman/views/driver/driverHomePage/driver_homePage.dart';
import 'package:saman/views/driver/driverRegistration/driver_registration_screen.dart';
import 'package:saman/views/forgotPassword/forgot_password_screen.dart';
import 'package:saman/views/role/role_selection.dart';
import 'package:saman/views/welcome/components/background.dart';
import 'package:saman/views/welcome/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailLogin extends StatefulWidget {
  @override
  EmailLoginState createState() => EmailLoginState();
}

class EmailLoginState extends State<EmailLogin> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController phone = TextEditingController();
  String error = '';
  bool isLoading = false;
  final SharedPreference secureStorage = SharedPreference();
  FocusNode emailNode = FocusNode();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
                      RoundedInputField(
                        validator: (possibleEmail) =>
                            validateEmail(possibleEmail),
                        hintText: "Your Email",
                        onChanged: (possibleEmail) {
                          setState(() {
                            email.text = possibleEmail;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      RoundedPasswordField(
                        validator: (possiblePassword) =>
                            validatePassword(possiblePassword),
                        onChanged: (possiblePassword) {
                          setState(() {
                            password.text = possiblePassword;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ForgotPasswordScreen()));
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RoundedButton(
                            height: size.height * 0.06,
                            width: size.width * 0.36,
                            text: "BACK",
                            fontSize: size.width / 19,
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
                            color: yellowColor,
                            fontSize: size.width / 19,
                            textColor: Colors.green,
                            press: () {
                              signInWithEmail();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  signInWithEmail() async {
    if (_formKey.currentState.validate()) {
      // setState(() => isLoading = true);
      signInWithEmailAndPassword(
              email.text.trim(), password.text, isLoading, context)
          .catchError((onError) {
        AuthService().displayToastMessage(onError.toString(), context);
        // setState(() {
        //   // isLoading = false;
        // });
      });
    }
  }

  Future signInWithEmailAndPassword(
      String email, String password, bool isLoading, context) async {
    setState(() {
      isLoading = true;
      print('All Loading Value $isLoading');
    });
    try {
      final FirebaseUser firebaseUser = (await _auth
              .signInWithEmailAndPassword(email: email, password: password)
              .catchError((errMsg) {
        print(errMsg);
        setState(() {
          isLoading = false;
        });
        // AuthService()
        //     .displayToastMessage("Email or Password is Invalid!", context);
      }))
          .user;
      if (firebaseUser != null) {
        Firestore.instance
            .collection("users")
            .where("email", isEqualTo: email.trim())
            .getDocuments()
            .then((value) => {
                  if (!value.documents[0].data.containsKey('userType'))
                    {
                      setState(() {
                        isLoading = false;
                      }),
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RoleSelection(
                                    userId:
                                        value.documents[0]['userId'].toString(),
                                    status:
                                        value.documents[0]['status'].toString(),
                                  )),
                          (route) => false),
                    }
                  else if (!value.documents[0].data.containsKey('firstName'))
                    {
                      setState(() {
                        isLoading = false;
                      }),
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  value.documents[0]['userType'] == "Business"
                                      ? BusinessRegistrationScreen(
                                          userId: value.documents[0]['userId']
                                              .toString(),
                                          status: value.documents[0]['status']
                                              .toString(),
                                        )
                                      : DriverRegistrationScreen(
                                          userId: value.documents[0]['userId']
                                              .toString(),
                                          status: value.documents[0]['status']
                                              .toString(),
                                        )),
                          (route) => false),
                    }
                  else if (!value.documents[0].data.containsKey('isVerified'))
                    {
                      isLoading = false,
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OtpScreen(
                                    name: value.documents[0]['userType'],
                                    userId:
                                        value.documents[0]['userId'].toString(),
                                    status:
                                        value.documents[0]['status'].toString(),
                                  )),
                          (route) => false),
                    }
                  else
                    {
                      setState(() {
                        isLoading = false;
                      }),
                      if (value.documents[0]['status'] == 'true')
                        {
                          fcmToken1(value.documents[0]['userId'].toString()),
                          secureStorage.writeSecureData(
                              'userId', "${value.documents[0]['userId']}"),
                          secureStorage.writeSecureData(
                              'userType', "${value.documents[0]['userType']}"),
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => value.documents[0]
                                              ['userType'] ==
                                          "Business"
                                      ? BusinessHomePage()
                                      : DriverHomePage()),
                              (route) => false),
                        }
                      else
                        {
                          AuthService().displayToastMessage(
                              "Your request is send to admin for approved",
                              context)
                        }
                    }
                })
            .catchError((onError) {
          AuthService().displayToastMessage("No record found!", context);
          setState(() {
            isLoading = false;
          });
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print("error");
      }
    } on AuthException catch (e) {
      AuthService().displayToastMessage(e.message.toString(), context);
    }
  }

  fcmToken1(id) async {
    final FirebaseMessaging _fcm = FirebaseMessaging();
    String fcmToken = await _fcm.getToken();
    Map<String, dynamic> receiverData = {
      'token': fcmToken,
      'createdAt': FieldValue.serverTimestamp(),
      'userId': id
    };
    final tokenRef = Firestore.instance.collection('tokens').document(id);
    await tokenRef.setData(receiverData);
  }

  Widget buildTextField(
    dynamic controller,
  ) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: controller,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.all(12),
        //EdgeInsets.symmetric(vertical: 12, horizontal: 10.0),
        focusColor: Colors.white,
        fillColor: Colors.white,
        filled: true,
        hintText: "Your Number",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(28.0)),
            borderSide: BorderSide(color: Colors.white24)),
      ),
    );
  }
}
