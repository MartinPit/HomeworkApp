# Flutter Homeworks App

A homework app build using Flutter together with Firebase with support of two user groups, students and teachers.
Currently, the only supported platform is Android.

## Build

Building process is quite straighforward, the only necessary command is `flutter build apk`.
The newly built apk will be saved in `/build/app/outputs/apk/relase` subfolder in the project folder.

## Dynamic Colors

Android 13 and higher, supports apps generating their colorway dynamically from the user's wallpaper.
This feature is disabled by default. To enable it, you will need to change 2 lines in the `main.dart` file.

To enable dynamic colors for the light theme, you need to change line 189 from:
```dart
colorScheme: colorScheme,
```

to:
```dart
colorScheme: lightDynamic ?? colorScheme,
```

Similarly, to activate dynamic color for dark theme, change line 195 accordingly:
```dart
colorScheme: darkColorScheme,
```

to:
```dart
colorScheme: darkDynamic ?? darkColorScheme,
```

## Design

To see the preview of the app, check out the following link, showcasing the app in [Figma](https://www.figma.com/file/4oGEI0jDoZSSp4guCd4uaa/Material-3-Design-Kit-(Community)?type=design&node-id=53795-27385).
