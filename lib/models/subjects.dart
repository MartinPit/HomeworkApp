enum Subject {
  English,
  Maths,
  Science,
  SocialStudies,
  Language,
  Art,
  Music,
  PE,
  Chemistry,
  Assembly,
  Low_Level_Programming,
}

extension Stringifier on Subject {
  String toEnglishString() {
    return toString().split('.').last;
  }

  Subject fromString(String str) {
    switch (str) {
      case 'English':
        return Subject.English;
      case 'Math':
        return Subject.Maths;
      case 'Science':
        return Subject.Science;
      case 'SocialStudies':
        return Subject.SocialStudies;
      case 'Language':
        return Subject.Language;
      case 'Art':
        return Subject.Art;
      case 'Music':
        return Subject.Music;
      case 'PE':
        return Subject.PE;
      case 'Chemistry':
        return Subject.Chemistry;
      case 'Assembly':
        return Subject.Assembly;
      case 'Low_Level_Programming':
        return Subject.Low_Level_Programming;
      default:
        return Subject.English;
    }
  }
}
