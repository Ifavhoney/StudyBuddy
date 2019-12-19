import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:study_buddy/reusableWidgets/actionButton.dart';
import 'package:study_buddy/reusableWidgets/fullScreenSnackBar.dart';
import 'register.dart';

import 'package:study_buddy/model/BaseAuth.dart';
import 'package:study_buddy/model/user.dart';

import 'dart:async';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void signInUser(String email, String password) async {
    //Sign in
    try {
      await Auth().signIn(email, password);
    } on PlatformException {
      print("invalid");
    }

    final status = await Auth().checkUserExists(email);

    final emailVerified =
        await Auth().getCurrentUser().then((user) => user.isEmailVerified);

/*
    if (user == false) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(days: 1),
        backgroundColor: Theme.of(context).errorColor,
        content: FullScreenSnackBar(
            icon: Icons.thumb_down,
            genericText: "Hi $email, we are unable to log you in because...\n" +
                "\n-Wrong Password\n-An un-verified/Non-existant account\n-Poor Connection",
            inkButtonText: "<- Back To Login",
            function: () {
              MaterialPageRoute route =
                  MaterialPageRoute(builder: (context) => Login());
              Navigator.of(context).push(route);
            },
            inkButtonText2: "<- Back to Register",
            function2: () {
              MaterialPageRoute route =
                  MaterialPageRoute(builder: (context) => Register());
              Navigator.of(context).push(route);
            }),
      ));
    } else {
      print("Success");
    }
    */
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    SnackBar snackBar = SnackBar(
        content: Text("Processing Data"),
        backgroundColor: Theme.of(context).snackBarTheme.backgroundColor);
    TextEditingController email;
    TextEditingController password;

    return Form(
      key: _formKey,
      child: Scaffold(
          bottomNavigationBar: Container(
            color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 32),
                  child: Text("Sign Up",
                      style: TextStyle(fontSize: 30, color: Colors.white)),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 40, 40),
                  child: ActionButton(
                    color: Colors.white54,
                    icon: Icon(Icons.arrow_forward_ios),
                    event: () {
                      MaterialPageRoute route = MaterialPageRoute(
                          builder: (BuildContext context) => Register());
                      Navigator.of(context).push(route);
                    },
                  ),
                )
              ],
            ),
          ),
          key: _scaffoldKey,
          backgroundColor: Theme.of(context).backgroundColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.email),
                title: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: "example@gmail.com",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0))),
                  controller: email,
                  validator: (String value) {
                    if (!isValidEmail(value)) {
                      return 'Invalid Email';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ListTile(
                leading: Icon(Icons.error),
                title: TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: "******",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0))),
                  controller: password,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                child: RaisedButton(
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: AppBarTheme.of(context).color,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        signInUser(User.email, User.password);
                      } else {
                        print("Not Valid");
                      }
                    }),
              ),
            ],
          )),
    );
  }

  bool isValidEmail(String input) {
    final RegExp regex = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input);
  }
}
