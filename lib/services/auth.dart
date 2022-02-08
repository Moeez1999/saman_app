import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:saman/model/secure_storage.dart';
import 'package:saman/views/business/businessHomePage/business_homePage.dart';
import 'package:saman/views/business/businessRegistration/business_registration_screen.dart';
import 'package:saman/views/driver/driverHomePage/driver_homePage.dart';
import 'package:saman/views/driver/driverRegistration/driver_registration_screen.dart';
import 'package:saman/components/phone_otp.dart';
import 'dart:async';
import 'package:saman/views/language_select/language_screen.dart';
import 'package:saman/views/welcome/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:saman/localization/localization_constants.dart';
import 'package:saman/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookLogin = FacebookLogin();
  final SharedPreference secureStorage = SharedPreference();
  final FirebaseMessaging _fcm = FirebaseMessaging();

  String verificationId;
  String error;

  fcmToken1(id) async {
    String fcmToken = await _fcm.getToken();
    Map<String, dynamic> receiverData = {
      'token': fcmToken,
      'createdAt': FieldValue.serverTimestamp(),
      'userId': id
    };
    final tokenRef = Firestore.instance.collection('tokens').document(id);
    await tokenRef.setData(receiverData);
  }

  // sign in with Facebook credentials
  signInWithFB(BuildContext context, bool isLoading) async {
    _facebookLogin.loginBehavior = FacebookLoginBehavior.webOnly;
    FacebookLoginResult result = await _facebookLogin.logIn(['email']);
    Future signInWithCredential(AuthCredential credential) =>
        _auth.signInWithCredential(credential);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        //get token
        final FacebookAccessToken accessToken = result.accessToken;
        // convert to auth credential
        final AuthCredential credential =
            FacebookAuthProvider.getCredential(accessToken: accessToken.token);
        //user Credential to sign in with firebase
        final res = await signInWithCredential(credential);
        FirebaseUser userDetails = res.user;
        if (userDetails.email == null) {
          isLoading = false;
          displayToastMessage(
              "This Account can't be used \n Please use a Different Account",
              context);
          signOut(context);
        } else {
          if (result != null) {
            Firestore.instance
                .collection("users")
                .where("email", isEqualTo: userDetails.email)
                .getDocuments()
                .then((value) => {
                      if (value.documents.isEmpty)
                        {
                          isLoading = false,
                          Firestore.instance
                              .collection('userList')
                              .getDocuments()
                              .then((value1) => {
                                    Firestore.instance
                                        .collection("users")
                                        .document(userDetails.uid.toString())
                                        .setData({
                                          "name": userDetails.displayName,
                                          "email": userDetails.email,
                                          "status": "false",
                                          "id": userDetails.uid.toString(),
                                          "userId":
                                              value1.documents[0]['userId'] + 1
                                        })
                                        .then((value) => {
                                              Firestore.instance
                                                  .collection("userList")
                                                  .getDocuments()
                                                  .then((value) => {
                                                        Firestore.instance
                                                            .collection(
                                                                "userList")
                                                            .document(value
                                                                .documents[0]
                                                                .documentID)
                                                            .updateData({
                                                          "userId": value
                                                                      .documents[
                                                                  0]['userId'] +
                                                              1
                                                        })
                                                      })
                                                  .then((value) => {
                                                        isLoading = false,
                                                AuthService().displayToastMessage("Your request is send to admin for approved", context)
                                                        // _showMyDialog(context),
                                                      }),
                                            })
                                        .catchError((e) {
                                          isLoading = false;
                                          print("error");
                                          print(e);
                                        }),
                                  }),
                        }
                      else
                        {
                          if (!value.documents[0].data.containsKey('userType'))
                            {
                              isLoading = false,
                              if(value.documents[0]['status'] == 'true')
                                {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LanguageScreen(
                                            userId: value.documents[0]['userId']
                                                .toString(),
                                            status: value.documents[0]['status']
                                                .toString(),
                                          )),
                                          (route) => false),
                                }
                              else
                                {
                                  AuthService().displayToastMessage("Your request is send to admin for approved", context)
                                }

                            }
                          else if (!value.documents[0].data
                              .containsKey('firstName'))
                            {
                              isLoading = false,
                              if(value.documents[0]['status'] == 'true')
                                {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => value.documents[0]
                                          ['userType'] ==
                                              "Business"
                                              ? BusinessRegistrationScreen(
                                            userId: value.documents[0]
                                            ['userId']
                                                .toString(),
                                            status: value.documents[0]
                                            ['status']
                                                .toString(),
                                          )
                                              : DriverRegistrationScreen(
                                            userId: value.documents[0]
                                            ['userId']
                                                .toString(),
                                            status: value.documents[0]
                                            ['status']
                                                .toString(),
                                          )),
                                          (route) => false),
                                }
                              else
                                {
                                  AuthService().displayToastMessage("Your request is send to admin for approved", context)
                                }

                            }
                          else if (!value.documents[0].data
                              .containsKey('isVerified'))
                            {
                              isLoading = false,
                              if(value.documents[0]['status'] == 'true')
                                {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OtpScreen(
                                            name: value.documents[0]
                                            ['userType'],
                                            userId: value.documents[0]['userId']
                                                .toString(),
                                            status: value.documents[0]
                                            ['status'],
                                          )),
                                          (route) => false),
                                }
                              else
                                {
                                  AuthService().displayToastMessage("Your request is send to admin for approved", context)
                                }

                            }
                          else
                            {
                              secureStorage.writeSecureData('userId',
                                  value.documents[0]['userId'].toString()),
                              secureStorage.writeSecureData('userType',
                                  "${value.documents[0]['userType']}"),
                              isLoading = false,

                              if(value.documents[0]['status']=="true"){
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        value.documents[0]
                                        ['userType'] ==
                                            "Business"
                                            ? BusinessHomePage(
                                        )
                                            : DriverHomePage()),
                                        (route) => false),
                              }
                              else
                                {
                                  AuthService().displayToastMessage("Your request is send to admin for approved", context)
                                }
                            }
                        }
                    });
          } else {
            isLoading = false;
            print("error in google");
          }
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => WelcomeScreen()),
            (route) => false);
        print("canceled by user ${result.errorMessage}");
        break;
      case FacebookLoginStatus.error:
        print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        isLoading = false;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => WelcomeScreen()),
            (route) => false);
        break;
    }
  }

  // sign in with google credentials
  signInWithGoogle(BuildContext context, bool isLoading) async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();

    try {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      AuthResult result = await _auth.signInWithCredential(credential);
      FirebaseUser userDetails = result.user;

      if (result != null) {
        Firestore.instance
            .collection("users")
            .where("email", isEqualTo: userDetails.email)
            .getDocuments()
            .then((value) => {
                  if (value.documents.isEmpty)
                    {
                      Firestore.instance
                          .collection('userList')
                          .getDocuments()
                          .then((value1) => {
                                Firestore.instance
                                    .collection("users")
                                    .document(userDetails.uid.toString())
                                    .setData({
                                      "name": userDetails.displayName,
                                      "email": userDetails.email,
                                      "status": "false",
                                      "id": userDetails.uid.toString(),
                                      "userId":
                                          value1.documents[0]['userId'] + 1
                                    })
                                    .then((value) => {
                                          Firestore.instance
                                              .collection("userList")
                                              .getDocuments()
                                              .then((value) => {
                                                    Firestore.instance
                                                        .collection("userList")
                                                        .document(value
                                                            .documents[0]
                                                            .documentID)
                                                        .updateData({
                                                      "userId":
                                                          value.documents[0]
                                                                  ['userId'] +
                                                              1
                                                    })
                                                  })
                                              .then((value) => {
                                                    isLoading = false,
                                            AuthService().displayToastMessage("Your request is send to admin for approved", context)
                                                    // _showMyDialog(context),
                                                  }),
                                        })
                                    .catchError((e) {
                                      isLoading = false;
                                      print("error");
                                      print(e);
                                    }),
                              }),
                    }
                  else
                    {
                      isLoading = false,
                      if (!value.documents[0].data.containsKey('userType'))
                        {
                          print(value.documents[0]['userId'].toString()),
                          isLoading = false,
                          if(value.documents[0]['status'] == 'true')
                            {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LanguageScreen(
                                        userId: value.documents[0]['userId']
                                            .toString(),
                                        status: value.documents[0]['status']
                                            .toString(),
                                      )),
                                      (route) => false),
                            }
                          else
                            {
                              AuthService().displayToastMessage("Your request is send to admin for approved", context)
                            }

                        }
                      else if (!value.documents[0].data
                          .containsKey('firstName'))
                        {
                          isLoading = false,
                          if(value.documents[0]['status'] == 'true')
                            {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => value.documents[0]
                                      ['userType'] ==
                                          "Business"
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
                          else
                            {
                              AuthService().displayToastMessage("Your request is send to admin for approved", context)
                            }

                        }
                      else if (!value.documents[0].data
                          .containsKey('isVerified'))
                        {
                          isLoading = false,
                          if(value.documents[0]['status'] == 'true')
                            {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OtpScreen(
                                        name: value.documents[0]['userType'],
                                        userId: value.documents[0]['userId']
                                            .toString(),
                                        status: value.documents[0]['status']
                                            .toString(),
                                      )),
                                      (route) => false),
                            }
                          else
                            {
                              AuthService().displayToastMessage("Your request is send to admin for approved", context)
                            }
                        }
                      else
                        {
                          secureStorage.writeSecureData('userId',
                              value.documents[0]['userId'].toString()),
                          secureStorage.writeSecureData(
                              'userType', "${value.documents[0]['userType']}"),
                          fcmToken1(value.documents[0]['userId'].toString()),
                          isLoading = false,
                          if(value.documents[0]['status'] == 'true')
                            {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => value.documents[0]
                                      ['userType'] ==
                                          "Business"
                                          ? BusinessHomePage()
                                          : DriverHomePage())),
                            }
                          else
                            {
                              AuthService().displayToastMessage("Your request is send to admin for approved", context)
                            }

                        }
                    }
                });
      } else {
        isLoading = false;
        print("error in google");
      }
    } catch (e) {
      isLoading = false;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => WelcomeScreen()),
          (route) => false);
    }
  }

  // sign in with email and password

  Future signInWithEmailAndPassword(
      String email, String password, bool isLoading, context) async {
    final FirebaseUser firebaseUser = (await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .catchError((errMsg) {
      print(errMsg);
      isLoading = false;
      displayToastMessage("Email or Password is Invalid!", context);
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
                    isLoading = false,
                    if(value.documents[0]['status'] == 'true')
                      {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LanguageScreen(
                                  userId:
                                  value.documents[0]['userId'].toString(),
                                  status: value.documents[0]['status']
                                      .toString(),
                                )),
                                (route) => false),
                      }
                    else
                      {
                        AuthService().displayToastMessage("Your request is send to admin for approved", context)
                      }

                  }
                else if (!value.documents[0].data.containsKey('firstName'))
                  {
                    isLoading = false,
                    if(value.documents[0]['status'] == 'true')
                      {
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
                    else
                      {
                        AuthService().displayToastMessage("Your request is send to admin for approved", context)
                      }

                  }
                else if (!value.documents[0].data.containsKey('isVerified'))
                  {
                    isLoading = false,
                    if(value.documents[0]['status'] == 'true')
                      {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OtpScreen(
                                  name: value.documents[0]['userType'],
                                  userId:
                                  value.documents[0]['userId'].toString(),
                                  status: value.documents[0]['status']
                                      .toString(),
                                )),
                                (route) => false),
                      }
                    else
                      {
                        AuthService().displayToastMessage("Your request is send to admin for approved", context)
                      }
                  }
                else
                  {
                    isLoading = false,
                    if(value.documents[0]['status'] == 'true')
                      {
                        fcmToken1(value.documents[0]['userId'].toString()),
                        secureStorage.writeSecureData(
                            'userId', "${value.documents[0]['userId']}"),
                        secureStorage.writeSecureData(
                            'userType', "${value.documents[0]['userType']}"),
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                value.documents[0]['userType'] == "Business"
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
        isLoading = false;
      });
    } else {
      isLoading = false;
      print("error");
    }
  }

  void _changeLanguage(language, context) async {
    Locale _locale = await setLocale(language);
    Saman.setLocale(context, _locale);
  }

  // sign out from the app
  Future signOut(BuildContext context) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    secureStorage.deletedAllSecureData();
    _prefs.clear();
    await _googleSignIn.signOut();
    await _auth.signOut();
    await _facebookLogin.logOut();
    _changeLanguage("en", context);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
        (route) => false);
  }

  displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(
        msg: message, backgroundColor: Colors.black, textColor: Colors.white);
  }
}
