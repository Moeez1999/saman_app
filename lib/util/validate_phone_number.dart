dynamic validatePhoneNumber(String phoneNumberCandidate) {
  return phoneNumberCandidate.isEmpty ||
          phoneNumberCandidate == '' ||
          !RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$')
              .hasMatch(phoneNumberCandidate)
      ? 'Enter a valid phone number'
      : null;
}
