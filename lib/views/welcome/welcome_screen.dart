import 'package:flutter/material.dart';
import 'package:saman/services/auth.dart';
import 'package:saman/views/email_login/components/email_login.dart';
import 'package:saman/views/email_signup/signup_with_email_screen.dart';
import 'package:saman/views/phoneNumberSignIn/phone_signIn.dart';
import '../../constants.dart';
import 'components/background.dart';
import 'components/have_no_account_acheck.dart';
import 'components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _formKey = GlobalKey<FormState>();

  String error = '';
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return  Background(
      index: 0,
      child: isLoading ==true ? Container(child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(yellowColor)),),): SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: size.height * 0.15),
              Image.asset(
                "assets/icons/logo-cropped.png",
                width: size.width*0.70,
              ),
              SizedBox(
                width: size.width * 0.65,
                child: Text(
                  error,
                  style: TextStyle(
                      color: Color.fromRGBO(211, 51, 48, 1),
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: size.height*0.07,),
              RoundedButton(
                height: size.height*0.05,
                width: size.width*0.75,
                text: "Sign in with phone",
                assetIcon: 'assets/icons/green-call-icon.png',
                color: yellowColor,
                textColor: textBoxColor,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return PhoneSignIn();
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: size.height*0.05,),
              RoundedButton(
                height: size.height*0.05,
                width: size.width*0.75,
                text: "Sign in with Facebook",
                assetIcon: 'assets/icons/facebook-icon.png',
                color: blueColor,
                textColor: Colors.white,
                press: () async {
                  setState(() {
                    isLoading = true;
                  });
                  AuthService().signInWithFB(context,isLoading);
                },
              ),
              SizedBox(height: size.height*0.05,),
              RoundedButton(
                height: size.height*0.05,
                width: size.width*0.75,
                text: "Sign in with Google",
                assetIcon: 'assets/icons/google-icon.png',
                color: primaryLightColor,
                textColor: Colors.black,
                iconColor: Colors.black,
                press: () async {
                  setState(() {
                    isLoading = true;
                  });
                  AuthService().signInWithGoogle(context, isLoading);
                },
              ),
              SizedBox(height: size.height*0.05,),
              RoundedButton(
                height: size.height*0.05,
                width: size.width*0.75,
                text: "Sign in with email",
                assetIcon: 'assets/icons/email-icon.png',
                color: yellowColor,
                textColor: textBoxColor,
                press: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>EmailLogin()));
                },
              ),
              SizedBox(height: size.height * 0.027),
              HaveNoAccountCheck(
                login: true,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return EmailSignUpScreen();
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: size.height * 0.027)
            ],
          ),
        ),
      ),
    );
  }
}
