import 'package:buddy/debug/debug_helper.dart';
import 'package:buddy/layout/auth/model/base_auth_model.dart';
import 'package:buddy/layout/auth/view/signup_view.dart';
import 'package:buddy/layout/nav_page/view_spner_chld_nav.dart';
import 'package:buddy/layout/nav_page/wait_searc_cht_nav.dart';
import 'package:buddy/layout/orrin/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthType { Google, Apple }

class AuthController implements BaseAuthModel {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseStore = FirebaseFirestore.instance;

  Future<bool> checkUserExists(String email) async {
    final snapshot = await _firebaseStore.collection("Users").doc(email).get();
    if (snapshot.exists) {
      /*How to get primitive value of a future */
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  @override
  Future<User> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  @override
  Future<void> sendEmailVerification() async {
    return _firebaseAuth.currentUser.sendEmailVerification();
  }

  @override
  Future<String> signInWithEmail(String email, String password) async {
    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return result.user.uid;
  }

  @override
  Future<void> signOut() async {
    GoogleSignIn googleSignIn = GoogleSignIn();

    if ((await googleSignIn.isSignedIn()) == true) {
      print("??");
      return googleSignIn.signOut();
    }
    return _firebaseAuth.signOut();
  }

  @override
  Future<String> signUpWithPassword(String email, String password) async {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    //Current User part of firebase android documentation
    User user = result.user;
    return user.uid;
  }

  Future<void> signInWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();

    if (await googleSignIn.isSignedIn() == true) {
      print("already signed in" + (_firebaseAuth.currentUser).uid);
      redirectUser(AuthType.Google);
    } else {
      await googleSignIn.signIn().then((account) async {
        //Get info from google
        GoogleSignInAuthentication googleAuth = await account.authentication;

        //Get user's credentials (get access to more information)
        AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

        await _firebaseAuth.signInWithCredential(credential);
        DebugHelper.green("user: " + account.email.toString());

        getCurrentUser();
        redirectUser(AuthType.Google);
      });
    }
  }

  void redirectUser(AuthType authType) async {
    await AuthController()
        .checkUserExists(_firebaseAuth.currentUser.email)
        .then((exists) {
      if (exists) {
        getProfile(_firebaseAuth.currentUser.email);
        Get.off(ViewSpnerChldNav(
            isReady: true, unRelatedView: true, child: WaitSearChtNav()));
      } else
        Get.offNamed(SignupView.routeName,
            parameters: {"authType": authType.toString().split(".").last});
    });
  }

  Future<UserModel> getProfile(String email) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("Users").doc(email).get();
    Map<String, dynamic> snapData = snapshot.data();
    if (snapData == null) return UserModel();

    return UserModel.fromJson(email, snapshot.data());
  }

  Future<String> signUp(String email, String password) async {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    //Current User part of firebase android documentation
    return result.user.uid;
  }
}
