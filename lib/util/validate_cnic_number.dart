dynamic validateCnicNumber(String cnicNumberCandidate) {
  return cnicNumberCandidate.isEmpty ||
      cnicNumberCandidate == '' ||
          !RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$')
              .hasMatch(cnicNumberCandidate) || cnicNumberCandidate.length != 13
      ? 'Enter a valid CNIC number'
      : null;
}
