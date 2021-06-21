import 'package:buddy/layout/auth/controller/auth_controller.dart';
import 'package:buddy/layout/orrin/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class UserConfig extends GetxController {
  UserModel user;
  bool isReady = false;

  //Cached login

  init() async {
    isReady = false;

    user = UserModel(email: fb.FirebaseAuth.instance.currentUser?.email);

    if (user?.email != null)
      user = await AuthController().getProfile(user?.email);

    await Future.delayed(Duration(seconds: kDebugMode == true ? 0 : 3));
    isReady = true;
    update();
  }
}
