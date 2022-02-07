import 'package:flutter/material.dart';
import 'package:saman/components/rounded_input_field.dart';
import 'package:saman/components/rounded_password_field.dart';
import 'package:saman/model/secure_storage.dart';
import 'package:saman/services/auth.dart';
import 'package:saman/util/validate_email.dart';
import 'package:saman/util/validate_password.dart';
import 'package:saman/constants.dart';
import 'package:saman/views/forgotPassword/forgot_password_screen.dart';
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
  FocusNode emailNode =FocusNode();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      index: 0,
      child: isLoading ==true ? Container(child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(yellowColor)),),): SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 24),
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
                          style: TextStyle(color: Colors.white,
                            decoration: TextDecoration.underline,),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPasswordScreen()));
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
                      text: "Back",
                      fontSize: size.width/19 ,
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
                      text: "Log in",
                      color: yellowColor,
                      fontSize: size.width/19 ,
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
      setState(() => isLoading = true);
      AuthService().signInWithEmailAndPassword(email.text.trim(), password.text,isLoading,context).catchError((onError){
        setState(() {
          isLoading = false;
        });
      });

    }
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
