//Adds all the configs together including the Themes & Keys

import 'package:buddy/global/config/analytics_config.dart';
import 'package:buddy/global/config/app_config.dart';
import 'package:buddy/global/config/device_config.dart';
import 'package:buddy/global/config/user_config.dart';
import 'package:buddy/global/keys/keys.dart';
import 'package:buddy/global/theme/theme.dart';
import 'package:get/get.dart';

class Global {
  ///Information regarding our Keys
  static Keys keys;

  //Information regarding Our AppTheme
  static AppTheme appTheme;

  ///Information regarding The App
  static AppConfig appConfig;

  ///Information regarding ScreenSize, Platform, Netwok, Permission
  static DeviceConfig deviceConfig = Get.find<DeviceConfig>();

  ///Information regarding the Ueer
  static UserConfig userConfig = Get.find<UserConfig>();

  ///Information regarding Analytics
  static AnalyticsConfig analyticsConfig;

  ///Information regarding the user's email
  static String get email => userConfig.user.email;
}
