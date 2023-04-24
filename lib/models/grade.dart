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
    return toString().split('.').last;
  }
}