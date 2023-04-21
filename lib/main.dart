import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homework_app/screens/auth_screen.dart';
import 'package:homework_app/screens/teacher_screen.dart';
import 'package:homework_app/screens/student_screen.dart';
import 'package:homework_app/screens/profile_screen.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'models/homeworks.dart';
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final TextTheme textTheme = const TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 57,
      fontWeight: FontWeight.w400,
      height: 64 / 57,
    ),
    displayMedium: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 45,
      fontWeight: FontWeight.w400,
      height: 52 / 45,
    ),
    displaySmall: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 36,
      fontWeight: FontWeight.w400,
      height: 44 / 36,
    ),
    headlineLarge: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 32,
      fontWeight: FontWeight.w400,
      height: 40 / 32,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 28,
      fontWeight: FontWeight.w400,
      height: 36 / 28,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 24,
      fontWeight: FontWeight.w400,
      height: 32 / 24,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 22,
      fontWeight: FontWeight.w400,
      height: 28 / 22,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 24 / 16,
    ),
    titleSmall: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 20 / 14,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 24 / 16,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 20 / 14,
    ),
    bodySmall: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 16 / 12,
    ),
    labelLarge: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 20 / 14,
    ),
    labelMedium: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 16 / 12,
    ),
    labelSmall: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 11,
      fontWeight: FontWeight.w500,
      height: 16 / 11,
    ),
  );
  final ColorScheme colorScheme = const ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromRGBO(100, 97, 0, 1),
    onPrimary: Colors.white,
    primaryContainer: Color.fromRGBO(237, 232, 98, 1),
    onPrimaryContainer: Color.fromRGBO(30, 29, 0, 1),
    secondary: Color.fromRGBO(97, 96, 66, 1),
    onSecondary: Colors.white,
    secondaryContainer: Color.fromRGBO(232, 228, 191, 1),
    onSecondaryContainer: Color.fromRGBO(29, 28, 6, 1),
    tertiary: Color.fromRGBO(62, 102, 85, 1),
    onTertiary: Colors.white,
    tertiaryContainer: Color.fromRGBO(192, 236, 215, 1),
    onTertiaryContainer: Color.fromRGBO(0, 33, 22, 1),
    error: Color.fromRGBO(186, 26, 26, 1),
    onError: Colors.white,
    errorContainer: Color.fromRGBO(255, 218, 214, 1),
    onErrorContainer: Color.fromRGBO(65, 0, 2, 1),
    background: Colors.white,
    onBackground: Color.fromRGBO(28, 28, 22, 1),
    surface: Color.fromRGBO(253, 249, 240, 1),
    onSurface: Color.fromRGBO(28, 28, 22, 1),
  );
  final ColorScheme darkColorScheme = const ColorScheme(
    brightness: Brightness.dark,
    primary: Color.fromRGBO(208, 203, 73, 1),
    onPrimary: Color.fromRGBO(52, 50, 0, 1),
    primaryContainer: Color.fromRGBO(75, 73, 0, 1),
    onPrimaryContainer: Color.fromRGBO(237, 232, 98, 1),
    secondary: Color.fromRGBO(203, 200, 164, 1),
    onSecondary: Color.fromRGBO(51, 49, 24, 1),
    secondaryContainer: Color.fromRGBO(73, 72, 44, 1),
    onSecondaryContainer: Color.fromRGBO(232, 228, 191, 1),
    tertiary: Color.fromRGBO(165, 208, 187, 1),
    onTertiary: Color.fromRGBO(12, 55, 41, 1),
    tertiaryContainer: Color.fromRGBO(38, 78, 62, 1),
    onTertiaryContainer: Color.fromRGBO(192, 236, 215, 1),
    error: Color.fromRGBO(255, 180, 171, 1),
    onError: Color.fromRGBO(105, 0, 5, 1),
    errorContainer: Color.fromRGBO(147, 0, 10, 1),
    onErrorContainer: Color.fromRGBO(255, 218, 214, 1),
    background: Color.fromRGBO(28, 28, 22, 1),
    onBackground: Color.fromRGBO(230, 226, 217, 1),
    surface: Color.fromRGBO(20, 20, 15, 1),
    onSurface: Color.fromRGBO(202, 198, 190, 1),
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => User()),
        ChangeNotifierProvider(create: (context) => Homeworks()),
      ],
      child: DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
          return MaterialApp(
            title: 'HomeworkApp',
            theme: ThemeData(
              textTheme: textTheme,
              colorScheme: colorScheme,
              brightness: Brightness.light,
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              textTheme: textTheme,
              colorScheme: darkColorScheme,
              brightness: Brightness.dark,
              useMaterial3: true,
            ),
            themeMode: ThemeMode.system,
            debugShowCheckedModeBanner: false,
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData) {
                  return const AuthScreen();
                } else {
                  final user = Provider.of<User>(context, listen: false);
                  return FutureBuilder(
                    future: user.init(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return user.isStudent()
                          ? const StudentScreen()
                          : const TeacherScreen();
                    },
                  );
                }
              },
            ),
            routes: {
              ProfileScreen.routeName: (context) => const ProfileScreen(),
            },
          );
        },
      ),
    );
  }
}
