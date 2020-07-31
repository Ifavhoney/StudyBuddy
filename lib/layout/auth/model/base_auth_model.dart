import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuthModel {
  /*Docs say it returns a string */
  Future<String> signInWithEmail(String email, String password);
  Future<String> signUpWithPassword(String email, String password);
  Future<FirebaseUser> getCurrentUser();
  Future<void> sendEmailVerification();
  Future<void> signOut();
  Future<void> googleSignIn();

  /*Firestore W/out email veritification */
  Future<bool> checkUserExists(String email);
}

class Auth implements BaseAuthModel {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _firebaseStore = Firestore.instance;

  Future<bool> checkUserExists(String email) async {
    final snapshot =
        await _firebaseStore.collection("Users").document(email).get();
    if (snapshot.exists) {
      /*How to get primitive value of a future */
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  @override
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  @override
  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.sendEmailVerification();
  }

  @override
  Future<String> signInWithEmail(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  @override
  Future<void> signOut() async {
    GoogleSignIn googleSignIn = GoogleSignIn();

    if ((await googleSignIn.isSignedIn()) == true) {
      return googleSignIn.signOut();
    }
    return _firebaseAuth.signOut();
  }

  @override
  Future<String> signUpWithPassword(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    //Current User part of firebase android documentation
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<void> googleSignIn() async {
    GoogleSignIn googleSignIn = GoogleSignIn();

    if (await googleSignIn.isSignedIn() == true) {
      print("already signed in" + (await _firebaseAuth.currentUser()).uid);
    } else {
      await googleSignIn.signIn().then((account) async {
        //Get info from google
        GoogleSignInAuthentication googleAuth = await account.authentication;

        //Get user's credentials (get access to more information)
        AuthCredential credential = GoogleAuthProvider.getCredential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

        await _firebaseAuth.signInWithCredential(credential);
      });
    }
  }
}
