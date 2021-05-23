import 'package:buddy/global/config/device_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class UserConfig extends GetxController {
  User user;
  bool completedProfile;
  bool isReady;

  init() async {
    isReady = false;
    user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Get.snackbar("Sign in", "Hi Buddy! Please sign in",
          snackPosition: SnackPosition.TOP);
    }

    int s = kDebugMode == true ? 0 : 3;
    await Future.delayed(Duration(seconds: s));
    isReady = true;
    update();
  }
}
