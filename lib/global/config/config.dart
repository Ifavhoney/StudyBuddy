import 'package:buddy/layout/auth/controller/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Config {
  static User user;

  static String deviceInformation;
  static bool autoLogin;
  static String typeOfLogin;

  //function that need to be ran before running the app
  //e.g analytics, e.g auto login, type of login, phone device,inapp notifications etc

  static init() async {
    autoLogin = false;
    deviceInformation = "";
    typeOfLogin = "";
    user = await AuthController().getCurrentUser();
    if (user == null) {
      autoLogin = false;
    }
  }
}
