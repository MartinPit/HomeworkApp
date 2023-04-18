enum Role {
  teacher, student
}

extension Stringifier on Role {
  String toSlovakString() {
    if (this == Role.teacher) {
      return 'Učiteľ';
    }
    return 'Študent';
  }

  String toEnglishString() {
    if (this == Role.teacher) {
      return 'teacher';
    }
    return 'student';
  }
}