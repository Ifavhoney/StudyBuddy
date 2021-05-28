import 'package:buddy/global/config/device_config.dart';
import 'package:buddy/global/widgets/static/global_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:buddy/layout/auth/controller/auth_controller.dart';

class UserConfig extends GetxController {
  User user;
  bool completedProfile;
  bool isReady;

  init() async {
    isReady = false;
    user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      GlobalSnackBar.main("Hi Buddy! Please sign in",
          snackPosition: SnackPosition.TOP);
    }
    bool isRegistered = await AuthController().checkUserExists(user.email);
    if (isRegistered) {
      GlobalSnackBar.main("Welcome back Buddy!",
          snackPosition: SnackPosition.TOP);
    }

    int s = kDebugMode == true ? 0 : 3;
    await Future.delayed(Duration(seconds: s));
    isReady = true;
    update();
  }
}
