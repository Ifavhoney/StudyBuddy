import 'package:buddy/layout/orrin/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:buddy/layout/auth/controller/auth_controller.dart';

class UserConfig extends GetxController {
  User user;
  bool completedProfile;
  bool isReady;

  init() async {
    isReady = false;

    user = User(email: fb.FirebaseAuth.instance.currentUser?.email);

    bool isRegistered = await AuthController().checkUserExists(user?.email);
    if (!isRegistered) user = User();

    await Future.delayed(Duration(seconds: kDebugMode == true ? 0 : 3));
    isReady = true;
    update();
  }
}
