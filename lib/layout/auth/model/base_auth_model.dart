import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuthModel {
  /*Docs say it returns a string */
  Future<String> signInWithEmail(String email, String password);
  Future<String> signUpWithPassword(String email, String password);
  Future<User> getCurrentUser();
  Future<void> sendEmailVerification();
  Future<void> signOut();
  Future<void> signInWithGoogle();

  /*Firestore W/out email veritification */
  Future<bool> checkUserExists(String email);
}
