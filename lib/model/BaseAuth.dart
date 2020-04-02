import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/*For a C# based person, this may look like a confusing approach (no interface call on dart)
For an Android dev, documentation is scrace, but implenetation is easy
https://pub.dev/documentation/firebase_auth/latest/firebase_auth/firebase_auth-library.html
*/

abstract class BaseAuth {
  /*Docs say it returns a string */
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password);
  Future<FirebaseUser> getCurrentUser();
  Future<void> sendEmailVerification();
  Future<void> signOut();
  /*Firestore W/out email veritification */
  Future<bool> checkUserExists(String email);
}

class Auth implements BaseAuth {
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
  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  @override
  Future<String> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    //Current User part of firebase android documentation
    FirebaseUser user = result.user;
    return user.uid;
  }
}
