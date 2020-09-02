import 'package:buddy/layout/auth/controller/auth_controller.dart';
import 'package:buddy/layout/home/view/searching_view.dart';
import 'package:buddy/layout/home/view/waiting_view.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  static const routeName = '/login_view';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Auth"),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RaisedButton(
            child: Text("Sign in with google"),
            onPressed: () =>
                AuthController().signInWithGoogle().whenComplete(() {
              Navigator.of(context).pushNamed(WaitingView.routeName);
            }),
          ),
          RaisedButton(
              child: Text("Sign out with google"),
              onPressed: () => AuthController().signOut())
        ],
      )),
    );
  }
}
