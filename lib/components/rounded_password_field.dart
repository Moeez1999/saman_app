import 'package:flutter/material.dart';
import 'package:saman/constants.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String> validator;
  final String password;
  final Color fillColor;
  final Color textColor;

  const RoundedPasswordField({ this.onChanged,  this.validator,this.password, this.fillColor,this.textColor})
  ;

  @override
  RoundedPasswordFieldState createState() => RoundedPasswordFieldState();
}

class RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool obscureText = true;
  // Toggles the password show status
  void _togglePasswordStatus() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color:widget.textColor==null?null:widget.textColor ),
      obscureText: obscureText,
      onChanged: widget.onChanged,
      validator: widget.validator,
      cursorColor: primaryColor,
      decoration: InputDecoration(
        suffixIconConstraints: BoxConstraints.tightForFinite(),
        contentPadding:
        EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
        focusColor: Colors.white,
        fillColor: widget.fillColor == null ? Colors.white : widget.fillColor,
        filled: true,
        isDense: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(28.0)),
            borderSide: BorderSide(color: Colors.white24)
        ),
        hintText: widget.password == null ? "Password" : "Confirm Password",
        hintStyle: TextStyle(
            color: widget.textColor
        ),
        suffixIcon: IconButton(
          padding: EdgeInsets.all(12.0),
          constraints: BoxConstraints(),
          iconSize: 14,
          icon:Icon(obscureText ? Icons.visibility:Icons.visibility_off,),
          onPressed: _togglePasswordStatus,
          color: primaryColor,
        ),
      ),
    );
  }
}