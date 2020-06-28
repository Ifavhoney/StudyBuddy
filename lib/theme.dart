import 'package:flutter/material.dart';

/*
Fonts are bigger on this app
https://api.flutter.dev/flutter/material/TextTheme-class.html
*/

class Theme {
  ThemeData main = ThemeData(
      backgroundColor: Colors.white,
      accentColor: Color(0xFFF8FAFF),
      textTheme: TextTheme(
        headline1: TextStyle(
          fontSize: 80,
          fontFamily: "Segoe UI",
          fontWeight: FontWeight.bold,
        ),
        headline2: TextStyle(
          fontSize: 60,
          fontFamily: "Segoe UI",
          fontWeight: FontWeight.bold,
        ),
        headline3: TextStyle(
          fontSize: 40,
          fontFamily: "Segoe UI",
          fontWeight: FontWeight.bold,
        ),
        headline4: TextStyle(
          fontSize: 24,
          fontFamily: "Segoe UI",
          fontWeight: FontWeight.bold,
        ),
        headline5: TextStyle(
          fontSize: 20,
          fontFamily: "Segoe UI",
          fontWeight: FontWeight.bold,
        ),
        headline6: TextStyle(
          fontSize: 18,
          fontFamily: "Segoe UI",
        ),
        subtitle1: TextStyle(
          fontSize: 16,
          fontFamily: "Segoe UI",
        ),
      ));

  //cardTheme: CardTheme(color: );
}
