enum Class {
  fiveA,
  fiveB,
  fiveC,
  sixA,
  sixB,
  sixC,
  sevenA,
  sevenB,
  sevenC,
  eightA,
  eightB,
  eightC,
  nineA,
  nineB,
  nineC,
}

extension Stringifier on Class {
  String toEnglishString() {
    String result = toString().split('.').last;
    return '${_numToString(result.substring(0, result.length - 1))}.${result.substring(result.length - 1)}';
  }

  String _numToString(String num) {
    switch (num) {
      case 'five':
        return '5';
      case 'six':
        return '6';
      case 'seven':
        return '7';
      case 'eight':
        return '8';
      case 'nine':
        return '9';
      default:
        return num;
    }
  }
}