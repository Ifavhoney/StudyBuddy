import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserConfig extends GetxController {
  User user;
  bool completedProfile;
  bool isReady;

  init() {
    isReady = false;
    user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar("Sign in", "Hi Buddy! Please sign in",
          snackPosition: SnackPosition.TOP);
    }
    isReady = true;
    update();
  }
}
