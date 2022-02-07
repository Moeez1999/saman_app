dynamic validatePassword(String passwordCandidate) {
  return passwordCandidate.isEmpty ||
          !RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[.!@#\$&*~-]).{8,}$")
              .hasMatch(passwordCandidate)
      ? 'Password must contain minimum:'
          '\n8 characters, 1 upper case, 1 lowercase,'
          '\n1 number and 1 special character'
      : null;
}
