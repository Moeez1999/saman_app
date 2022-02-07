dynamic validateNonEmpty(String stringCandidate) {
  return stringCandidate.isEmpty ||
      stringCandidate == ''
      ? 'Required field'
      : null;
}
