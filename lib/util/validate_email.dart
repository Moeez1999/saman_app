import 'package:flutter/cupertino.dart';

dynamic validateEmail(String emailCandidate) {
  return emailCandidate.isEmpty ||
          !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(emailCandidate)
      ? 'Enter a valid email'
      : null;
}
