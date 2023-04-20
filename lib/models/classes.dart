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

extension on Class {
  String toLowercaseString() {
    String result = toString();
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

  Class fromString(String str) {
    switch (str) {
      case '5.A':
        return Class.fiveA;
      case '5.B':
        return Class.fiveB;
      case '5C':
        return Class.fiveC;
      case '6.A':
        return Class.sixA;
      case '6.B':
        return Class.sixB;
      case '6.C':
        return Class.sixC;
      case '7.A':
        return Class.sevenA;
      case '7.B':
        return Class.sevenB;
      case '7.C':
        return Class.sevenC;
      case '8.A':
        return Class.eightA;
      case '8.B':
        return Class.eightB;
      case '8.C':
        return Class.eightC;
      case '9.A':
        return Class.nineA;
      case '9.B':
        return Class.nineB;
      case '9.C':
        return Class.nineC;
      default:
        return Class.fiveA;
    }
  }
}