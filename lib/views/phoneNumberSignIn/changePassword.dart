import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saman/services/auth.dart';
import 'package:saman/views/welcome/components/background.dart';
import 'package:saman/views/welcome/components/rounded_button.dart';
import 'package:saman/views/welcome/welcome_screen.dart';

import '../../constants.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String number;
  ChangePasswordScreen({this.number});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController pass = TextEditingController();
  TextEditingController confirmPass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        index: 0,
        child: Padding(
          padding:
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.15),
              Image.asset(
                "assets/icons/logo-cropped.png",
                width: size.width * 0.70,
              ),
              SizedBox(height: size.height * 0.01),
              Text("Create New Password",style: TextStyle(
                fontSize: 25,
                color: Colors.white
              ),),
              SizedBox(height: 20,),
              buildTextField(pass,"Password"),
              SizedBox(height: 10,),
              buildTextField(confirmPass,"Confirm Password"),
              SizedBox(
                height: size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundedButton(
                    height: size.height * 0.05,
                    width: size.width * 0.36,
                    text: "Back",
                    color: skyBlueColor,
                    textColor: Colors.white,
                    press: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  WelcomeScreen()),
                              (route) => false);
                    },
                  ),
                 Spacer(),
                  RoundedButton(
                    height: size.height * 0.05,
                    width: size.width * 0.36,
                    text: "Confirm",
                    color: yellowColor,
                    textColor: textBoxColor,
                    press: () async {
                      if(pass.text.isEmpty){
                        AuthService().displayToastMessage("Please fill the fields", context);
                      }else if(confirmPass.text.isEmpty){
                        AuthService().displayToastMessage("Please fill the fields", context);
                      }else if(pass.text != confirmPass.text){
                        AuthService().displayToastMessage("Both Password must same!", context);
                      }else{
                        resetPassword();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  resetPassword(){
    Firestore.instance.collection("phoneNumberUsers").where("number",isEqualTo: widget.number).getDocuments().then((value) => {
      Firestore.instance.collection("phoneNumberUsers").document(value.documents[0].documentID).updateData({
        "password":confirmPass.text,
      }).then((value) => {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    WelcomeScreen()),
                (route) => false),
      })
    });
  }
  Widget buildTextField(
      dynamic controller,
      String text
      ) {
    return Column(
      children: [
        TextFormField(
          keyboardType: TextInputType.visiblePassword,
          controller: controller,
          decoration: InputDecoration(
            isDense: true,
            contentPadding:  EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            //EdgeInsets.symmetric(vertical: 12, horizontal: 10.0),
            focusColor: Colors.white,
            fillColor: Colors.white,
            filled: true,
            hintText: text,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(28.0)),
                borderSide: BorderSide(color: Colors.white24)),
          ),
        ),
        SizedBox(height: 20,)
      ],
    );
  }
}
