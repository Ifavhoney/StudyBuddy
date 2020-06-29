import 'package:buddy/theme/fonts/fonts.dart';
import 'package:flutter/material.dart';

/*
Fonts are bigger on this app
https://api.flutter.dev/flutter/material/TextTheme-class.html
*/

class AppTheme {
  static ThemeData mainTheme = ThemeData(
    backgroundColor: Colors.white,
    accentColor: Color(0xFFF8FAFF),
    cardColor: Color(0xFFB9D1FF),
  );

  static Map<String, Color> camIconColors = {
    "cam": Color(0xFFC5D3E0),
    "mic": Color(0xFFC5D3E0),
    "person": Color(0xFFC5D3E0),
    "switch": Color(0xFFC5D3E0),
    "end": Color(0xFFD0021B),
  };
  static Map<String, Color> friendIconColors = {
    "cam": Color(0xFFC5D3E0),
    "mic": Color(0xFFC5D3E0),
    "person": Color(0xFFC5D3E0),
    "switch": Color(0xFFC5D3E0),
    "end": Color(0xFFD0021B),
  };
  static TextTheme segoeUi = Fonts.segoeUi;
  static TextTheme sfProText = Fonts.sfProText;
  static TextTheme nexa = Fonts.nexa;

  //cardTheme: CardTheme(color: );
}
