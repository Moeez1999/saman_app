import 'package:flutter/material.dart';
import 'package:saman/localization/localization_constants.dart';
import 'package:saman/main.dart';
import 'dart:async';
import 'package:saman/constants.dart';

class LanguageButton extends StatefulWidget {

  @override
  _LanguageButtonState createState() => _LanguageButtonState();
}

class _LanguageButtonState extends State<LanguageButton> {
  String _value = 'en';
  bool isLoading = false;

  void _changeLanguage(language) async {
    Locale _locale = await setLocale(language);
    Saman.setLocale(context, _locale);
    Timer(Duration(milliseconds: 400), () => Navigator.pop(context,_value));
  }

  @override
  void initState() {
    getLocale().then((locale) {
      setState(() {
        print(locale.languageCode);
        _value = locale.languageCode;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.centerRight,
      child: MaterialButton(
        onPressed: (){
          _showSettingsPanel(context);
        },
        textColor: primaryColor,
        // child: Image.asset('assets/icons/language-icon.png', height: 50),
        child: Icon(
          Icons.language,
          color: yellowColor,
          size: size.height * 0.04,
        ),
        padding: EdgeInsets.all(size.height * 0.01),
        shape: CircleBorder(),
      ),
    );
  }
  void _showSettingsPanel(context) {
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
        backgroundColor: accountSelectionBackgroundColor,
        context: context,
        builder: (context) {
          return Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Select you preferred language",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  SizedBox(
                    height: 40,
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
                                  color: Colors.white),
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
                                color: Colors.white),
                          ),)
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          );
        });
  }
}
