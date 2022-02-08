import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saman/views/role/role_selection.dart';
import 'package:saman/views/welcome/components/background.dart';
import 'package:saman/views/welcome/components/rounded_button.dart';
import '../../constants.dart';
import '../../main.dart';
import 'package:saman/localization/localization_constants.dart';

class LanguageScreen extends StatefulWidget {
  final String userId;
  final String status;

  LanguageScreen({@required this.userId , this.status});
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {

  String _value  ='en';
  void _changeLanguage(language) async {
    Locale _locale = await setLocale(language);
    Saman.setLocale(context, _locale);
  }
  @override
  void initState() {
    getLocale().then((locale) {
      setState(() {
         print(locale.languageCode);
         _value =  locale.languageCode;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        index: 0,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
              ),
              Image.asset(
                "assets/icons/logo-cropped.png",
                width: size.width * 0.70,
              ),
              SizedBox(
                height: 40,
              ),
              // Text(
              //   getTranslated(context, 'selectPreferredLanguage'),
              //   style:
              //       TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              // ),
              SizedBox(
                height: 60,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _value = "en";
                    _changeLanguage(_value);
                  });
                },
                child: Container(
                  width: size.width / 2,
                  height: 50,
                  decoration: BoxDecoration(
                      color: _value == "en"
                          ? yellowColor
                          : Color(0xff80BE2D),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: yellowColor,
                          width: 2,
                          style: BorderStyle.solid)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Center(
                      child: Text(
                        'ENGLISH',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _value == "en"
                                ? accountSelectionBackgroundColor : Colors.white),
                      ),
                    )
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _value = "ur";
                    _changeLanguage(_value);
                  });
                },
                child: Container(
                  width: size.width / 2,
                  height: 50,
                  decoration: BoxDecoration(
                      color: _value == "ur"
                          ? yellowColor
                          : Color(0xff80BE2D),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: yellowColor,
                          width: 2,
                          style: BorderStyle.solid)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Center(child: Text(
                      'اردو',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color:_value == "ur"
                              ? accountSelectionBackgroundColor : Colors.white),
                    ),)
                  ),
                ),
              ),

              SizedBox(height: 40),
              RoundedButton(
                height: size.height * 0.06,
                width: size.width * 0.36,
                text: "Next",
                fontSize: size.width/20 ,
                color: whiteColor,
                textColor: accountSelectionBackgroundColor,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return RoleSelection(userId: widget.userId,status: widget.status,);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
