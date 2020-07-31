import 'package:flutter/material.dart';
import "package:google_sign_in/google_sign_in.dart";
import "package:firebase_auth/firebase_auth.dart";

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello"),
      ),
      body: Center(
        child: Text("hello"),
      ),
    );
  }

  Future<FirebaseUser> _handleSignIn() async {
    // hold the instance of the authenticated user
    FirebaseUser user;

    final GoogleSignIn _googleSignIn = GoogleSignIn();
    //  _googleSignIn.currentUser
    final FirebaseAuth _auth = FirebaseAuth.instance;
    // flag to check whether we're signed in already
    bool isSignedIn = await _googleSignIn.isSignedIn();
    if (isSignedIn) {
      // if so, return the current user
      user = await _auth.currentUser();
    } else {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      // get the credentials to (access / id token)
      // to sign in via Firebase Authentication
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      user = (await _auth.signInWithCredential(credential)).user;
    }
    return user;
  }

/*
  void onGoogleSignIn(BuildContext context) async {
    FirebaseUser user = await _handleSignIn();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WelcomeUserWidget(user, _googleSignIn)));
  }
  */

  Widget _widget() {}
}
