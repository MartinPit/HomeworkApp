enum Grade {
  A,
  B,
  C,
  D,
  E,
  FX,
  none,
}

extension Stringifier on Grade {
  String toEnglishString() {
    String result = toString().split('.').last;
    return result == 'none' ? '' : result;
  }
}