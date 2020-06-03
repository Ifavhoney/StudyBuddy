import 'package:flutter/material.dart';
import 'package:study_buddy/helpers/debug_helper.dart';
import 'package:study_buddy/model/BaseAuth.dart';
import 'package:study_buddy/screens/calendar.dart';
import 'package:study_buddy/screens/calendarPortal.dart';
import 'package:study_buddy/screens/login.dart';

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
  String _userId = " ";

  @override
  void initState() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if ((user != null) && (user.isEmailVerified == true)) {
          _userId = user.uid;
          authStatus = AuthStatus.LOGGED_IN;
        } else {
          authStatus = AuthStatus.NOT_LOGGED_IN;
        }
      });
    });
    super.initState();
  }

  void logoutCallBack() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = " ";
    });
  }

  @override
  Widget build(BuildContext context) {
    return _screen();
  }

  Widget _screen() {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        DebugHelper.red("loading screen");
        return Container();
      case AuthStatus.NOT_LOGGED_IN:
        return Login();
      case AuthStatus.LOGGED_IN:
        return Calendar();
    }
    return Container();
  }
}
