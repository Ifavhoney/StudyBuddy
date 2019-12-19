/*Finds wether logged in,logged out, or Unknown 
Calls back (Sign in, Signout) & updates root screen when a login action or signout is made
*/

import 'package:flutter/material.dart';
import 'package:study_buddy/model/BaseAuth.dart';
import 'package:study_buddy/screens/calendar.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootScreen extends StatefulWidget {
  final BaseAuth auth;
  RootScreen({this.auth});
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  @override
  void initState() {
    super.initState();
    //Get current User returns a FirebaseUser
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        } else {
          authStatus = user?.uid == null
              ? AuthStatus.NOT_LOGGED_IN
              : AuthStatus.LOGGED_IN;
        }
      });
    });
  }

  void loginCallBack() {
    widget.auth.getCurrentUser().then((user) {
      //Next time we run this, the status will be logged in
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  //
  void logoutCallBack() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    /*
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        print("loading screen");
        return Container();
    case AuthStatus.NOT_LOGGED_IN:
      //I require something
      return LoginSignUpScreen();
    case AuthStatus.LOGGED_IN:
      return Calendar();
    }

  }
  */
    return Container();
  }
}
