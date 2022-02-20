import 'package:flutter/material.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final String prefixIcon;
  final Color fillColor;
  final Color textColor;
  final FocusNode node;
  final dynamic type;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String> validator;
  const RoundedInputField({
     this.hintText,
    this.type,
     this.onChanged,
     this.node,
    this.validator,
     this.prefixIcon,
     this.fillColor,
     this.textColor
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  TextFormField(
      keyboardType:type == null ? null : type,
      focusNode: node == null ? null : node,
        style: TextStyle(color: textColor),
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding:
          EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          prefixIcon: prefixIcon == null ? null :
          Padding(
            padding: EdgeInsets.all(size.height * 0.012),
            child: Image.asset(
              prefixIcon,
              width: size.width * 0.02,
              height: size.height * 0.02,
            ),
          ),
          isDense: true,
          //EdgeInsets.symmetric(vertical: 12, horizontal: 10.0),
          focusColor: Colors.white,
          fillColor: fillColor == null? Colors.white : fillColor,
          filled: true,
          labelText: hintText,
          labelStyle: TextStyle(
              color: textColor ?? Colors.black
          ),
          // hintText: hintText,
          // hintStyle: TextStyle(
          //     color: textColor
          // ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(28.0)),
            borderSide: BorderSide(color: Colors.white24)
            ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(28.0)),
              borderSide: BorderSide(color: Colors.black)
          )
        ),
    );
  }
}
