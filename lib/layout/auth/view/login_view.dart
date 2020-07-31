import 'package:buddy/layout/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';

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
            onPressed: () => AuthController().signInWithGoogle(),
          ),
          RaisedButton(
              child: Text("Sign out with google"),
              onPressed: () => AuthController().signOut())
        ],
      )),
    );
  }
}
