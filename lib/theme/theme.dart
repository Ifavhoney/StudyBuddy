import 'package:buddy/theme/colors/icon_colors.dart';
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

  static TextTheme segoeUi = Fonts.segoeUi;
  static TextTheme sfProText = Fonts.sfProText;
  static TextTheme nexa = Fonts.nexa;

  static IconColors signupIcons = IconColors.;
  //cardTheme: CardTheme(color: );
  void main(){
   // AppTheme.segoeUi..
  }
}
