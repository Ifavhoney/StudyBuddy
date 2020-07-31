import 'package:flutter/material.dart';
import "package:google_sign_in/google_sign_in.dart";
import "package:firebase_auth/firebase_auth.dart";

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello"),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RaisedButton(
            child: Text("Sign in with google"),
            onPressed: () => _googleSignIn(),
          ),
          RaisedButton(
              child: Text("Sign out with google"),
              onPressed: () => FirebaseAuth.instance.signOut())
        ],
      )),
    );
  }
}
