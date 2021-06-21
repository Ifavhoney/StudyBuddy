import 'package:buddy/global/config/device_config.dart';
import 'package:buddy/global/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///@LastModifiedBy: Jason NGuessan
class Fonts {
  ///<summary>
  ///
  ///Headline1: 80sp, bold
  ///
  ///headline2: 40sp, bold
  ///
  ///headline3: 26sp, bold
  ///
  ///headline4: 24sp, bold
  ///
  ///headline5: 20sp, bold
  ///
  ///headline6: 18sp
  ///
  ///subtitle1: 16sp
  ///
  ///subtitle2: 12sp
  ///
  ///</summary>
  TextTheme segoeUi = TextTheme(
    headline1: TextStyle(
      fontSize: 80.sp - deviceSize(),
      fontFamily: "Segoe UI",
      fontWeight: FontWeight.bold,
    ),
    headline2: TextStyle(
      fontSize: 40.sp - deviceSize(),
      fontFamily: "Segoe UI",
      fontWeight: FontWeight.bold,
    ),
    headline3: TextStyle(
      fontSize: 26.sp - deviceSize(),
      fontFamily: "Segoe UI",
      fontWeight: FontWeight.bold,
    ),
    headline4: TextStyle(
      fontSize: 24.sp - deviceSize(),
      fontFamily: "Segoe UI",
      fontWeight: FontWeight.bold,
    ),
    headline5: TextStyle(
      fontSize: 20.sp - deviceSize(),
      fontFamily: "Segoe UI",
      fontWeight: FontWeight.bold,
    ),
    headline6: TextStyle(
      fontSize: 18.sp - deviceSize(),
      fontFamily: "Segoe UI",
    ),
    subtitle1: TextStyle(
      fontSize: 16.sp - deviceSize(),
      fontFamily: "Segoe UI",
    ),
    subtitle2: TextStyle(
      fontSize: 12.sp,
      fontFamily: "Segoe UI",
    ),
  );

  ///<summary>
  ///
  ///headline2: 40sp, bold
  ///
  ///headline4: 24sp, bold
  ///
  ///headline5: 22sp, bold
  ///
  ///headline6: 18sp
  ///
  ///subtitle1: 16sp
  ///
  ///bodyText1: 14sp
  ///
  ///subtitle2: 12sp
  ///</summary>
  TextTheme sfProText = TextTheme(
    headline2: TextStyle(
      fontSize: 40.sp,
      fontFamily: "SfProText",
      fontWeight: FontWeight.bold,
    ),
    headline4: TextStyle(
      fontSize: 24.sp,
      fontFamily: "SfProText",
      fontWeight: FontWeight.bold,
    ),
    headline5: TextStyle(
      fontSize: 22.sp,
      fontFamily: "SfProText",
      fontWeight: FontWeight.bold,
    ),
    headline6: TextStyle(
      fontSize: 18.sp,
      fontFamily: "SfProText",
    ),
    subtitle1: TextStyle(
      fontSize: 16.sp,
      fontFamily: "SfProText",
    ),
    bodyText1: TextStyle(
      fontSize: 14.sp,
      fontFamily: "SfProText",
    ),
    subtitle2: TextStyle(
      fontSize: 12.sp,
      fontFamily: "SfProText",
    ),
  );

  ///<summary>
  ///
  ///headline3: 26sp, bold
  ///
  ///headline6: 20sp, w700
  ///
  ///bodyText1: 14sp, bold
  ///
  ///subtitle2: 10sp
  ///</summary>

  TextTheme nexa = TextTheme(
    headline3: TextStyle(
      fontSize: 26.sp,
      fontFamily: "Nexa",
      fontWeight: FontWeight.bold,
    ),
    headline6: TextStyle(
      fontSize: 20.sp - deviceSize(),
      fontFamily: "Nexa",
      fontWeight: FontWeight.w700,
    ),
    bodyText1: TextStyle(
      fontSize: 14.sp,
      fontFamily: "Nexa",
      fontWeight: FontWeight.bold,
    ),
    subtitle2: TextStyle(
      fontSize: 10.sp,
      fontFamily: "Nexa",
    ),
  );

  static double deviceSize() {
    switch (Global.deviceConfig.screenSize) {
      case ScreenSize.Small:
        return 3.sp;
        break;
      case ScreenSize.Mid:
        return 2.sp;
        break;
      case ScreenSize.Large:
        return 1.sp;
        break;
    }

    return 0;
  }
}
