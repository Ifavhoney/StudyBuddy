import 'package:buddy/theme/colors/icon_colors.dart';
import 'package:buddy/theme/fonts/fonts.dart';
import 'package:flutter/material.dart';

///@LastModifiedBy: Jason NGuessan
/*
Fonts are bigger on this app
https://api.flutter.dev/flutter/material/TextTheme-class.html
*/

class AppTheme {
  ///<summary>
  ///backgroundColor: Colors.white
  ///
  ///accentColor: Color(0xFFF8FAFF)
  ///
  ///cardColor: Color(0xFFB9D1FF)
  ///</summary>
  static ThemeData mainTheme = ThemeData(
    backgroundColor: Colors.white,
    accentColor: Color(0xFFF8FAFF),
    cardColor: Color(0xFFB9D1FF),
  );

  ///<summary>
  ///Headline1: 80px, bold
  ///
  ///headline2: 40px, bold
  ///
  ///headline3: 26px, bold
  ///
  ///headline4: 24px, bold
  ///
  ///headline5: 20px, bold
  ///
  ///headline6: 18px
  ///
  ///subtitle1: 16px
  ///
  ///subtitle2: 12px
  ///
  ///</summary>
  static TextTheme segoeUi = Fonts.segoeUi;

  ///<summary>
  ///headline4: 24px, bold
  ///
  ///headline5: 22px, bold
  ///
  ///headline6: 18px
  ///
  ///subtitle1: 16px
  ///
  ///bodyText1: 14px
  ///
  ///subtitle2: 12px
  ///</summary>
  static TextTheme sfProText = Fonts.sfProText;

  ///<summary>
  ///
  ///headline3: 26px, bold
  ///
  ///bodyText1: 14px, bold
  ///
  ///subtitle2: 10px
  ///</summary>
  static TextTheme nexa = Fonts.nexa;

  ///<summary>
  ///{}
  ///</summary>
  static Map<String, Color> homeScreenIcons = IconColors.homeScreen;

  ///<summary>
  ///"arrowBack": Color(0xFFE1C2EB)
  ///</summary>
  static Map<String, Color> loginScreenIcons = IconColors.loginScreen;

  ///<summary>
  ///
  ///"arrowBack": Color(0xFFFFFFFF)
  ///
  ///"add": Color(0xFF707070)
  ///</summary>
  static Map<String, Color> signupScreenIcons = IconColors.signupScreen;

  ///<summary>
  ///
  ///"arrowBack": Color(0xFFFFFFFF)
  ///
  ///"add": Color(0xFF707070)
  ///</summary>
  static Map<String, Color> preferenceScreenIcons =
      IconColors.preferencesScreen;

  ///<summary>
  ///
  ///"timer": Color(0xFFC5D3E0)
  ///
  ///"cam": Color(0xFFC5D3E0)
  ///
  ///"mic": Color(0xFFC5D3E0)
  ///
  ///"person": Color(0xFFC5D3E0)
  ///
  ///"switch": Color(0xFFC5D3E0)
  ///
  ///end": Color(0xFFD0021B)
  ///</summary>
  static Map<String, Color> camScreenIcons = IconColors.camScreen;

  ///<summary>
  ///
  ///"checkmark": Color(0xFF7C79FF)
  ///
  ///"timer": Color(0xFF7C79FF)
  ///
  ///"location": Color(0xFF272727)
  ///
  ///"add": Color(0xFF504DE5)
  ///</summary>
  static Map<String, Color> audioScreenIcons = IconColors.audioScreen;

  ///<summary>
  ///
  ///"call": Color(0xFFB3B2FF)
  ///
  ///"cam": Color(0xFFB3B2FF)
  ///
  ///"notification": Color(0xFF504DE5)
  ///
  ///inactive": Color(0xFFB5B5B5)
  ///
  ///"search": Color(0xFFC6C6C6)
  ///</summary>
  static Map<String, Color> friendScreenIcons = IconColors.friendScreen;

  ///<summary>
  ///
  ///"logout": Color(0xFF504DE5)
  ///
  ///</summary>
  static Map<String, Color> settingsScreenIcons = IconColors.settingsScreen;

  ///<summary>
  ///
  ///"search": Color(0xFF737BCE)
  ///</summary>
  static Map<String, Color> searchingScreenIcons = IconColors.searchingScreen;

  ///<summary>
  ///
  ///"active": Color(0xFF7C79FF)
  ///
  ///"inactive": Color(0xFF6F8BA4)
  ///
  ///"search": Color(0xFF8BB1FB)
  ///</summary>
  static Map<String, Color> bottomNavigationBarIcons =
      IconColors.bottomNavigationBar;
}
