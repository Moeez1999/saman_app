import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:saman/constants.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final String assetIcon;
  final Function press;
  final Color color, textColor, iconColor;
  final double height;
  final double width;
  final double fontSize;

  const RoundedButton(
      {
       this.text,
       this.assetIcon,
       this.press,
      this.color = primaryColor,
      this.textColor = Colors.white,
      this.iconColor = Colors.white,
       this.height,
       this.width,
      this.fontSize = 12,
   })
      ;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TextButton(
      onPressed: press,
      child: Container(
        alignment: Alignment.center,
        height: height,
        width: width,
        //height: size.height*0.05,
        //width: size.width*0.75,
        decoration: BoxDecoration(
          boxShadow: [
            new BoxShadow(
                color: Colors.black54,
                offset: Offset(0, 3),
                spreadRadius: 1,
                blurRadius: 8)
          ],
          borderRadius: BorderRadius.all(Radius.circular(28)),
          color: color,
        ),

        child: Row(
          mainAxisAlignment: assetIcon == null
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: assetIcon == null
              ? <Widget>[
                  Text(text,
                      style: TextStyle(color: textColor, fontSize: fontSize,fontWeight: FontWeight.w500))
                ]
              : <Widget>[
                  Image.asset(assetIcon,
                      height: size.height * 0.059, fit: BoxFit.cover),
                  SizedBox(width: 0.11 * size.width),
                  Text(text, style: TextStyle(color: textColor)),
                ],
        ),
      ),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        shadowColor: Colors.grey,
      ),
    );
  }
}
