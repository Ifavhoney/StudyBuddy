import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:study_buddy/reusableWidgets/actionButton.dart';
import 'package:study_buddy/reusableWidgets/fullScreenSnackBar.dart';
import 'register.dart';
import 'calendar.dart';

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
    int lastIndex = email.indexOf("@");
    String compressedEmail = email.substring(0, lastIndex);

    //Sign in
    try {
      await Auth().signIn(email, password);
    } on PlatformException catch (e) {
      switch (e.code) {
        case "ERROR_WRONG_PASSWORD":
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            duration: Duration(days: 1),
            backgroundColor: Theme.of(context).errorColor,
            content: FullScreenSnackBar(
              icon: Icons.thumb_down,
              isExpanded: true,
              genericText:
                  "Hi $compressedEmail, we are unable to log you in because...\n" +
                      "\n-Wrong Password",
              inkButtonText: "<- Back To Login",
              function: () {
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (context) => Login());
                Navigator.of(context).push(route);
              },
            ),
          ));
          return print("ERROR_WRONG_PASSWORD");
          break;

        case "ERROR_USER_NOT_FOUND":
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            duration: Duration(days: 1),
            backgroundColor: Theme.of(context).errorColor,
            content: FullScreenSnackBar(
              icon: Icons.thumb_down,
              isExpanded: true,
              genericText:
                  "Hi $compressedEmail, we are unable to log you in because...\n" +
                      "\n-User does not exist",
              inkButtonText: "<- Back To Login",
              function: () {
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (context) => Login());
                Navigator.of(context).push(route);
              },
              inkButtonText2: "<- To Register",
              function2: () {
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (context) => Register());
                Navigator.of(context).push(route);
              },
            ),
          ));
          return print("ERROR_USER_NOT_FOUND");
          break;

        case "ERROR_NETWORK_REQUEST":
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            duration: Duration(days: 1),
            backgroundColor: Theme.of(context).errorColor,
            content: FullScreenSnackBar(
              icon: Icons.signal_wifi_off,
              isExpanded: true,
              genericText:
                  "Hi $compressedEmail, we are unable to log you in because...\n" +
                      "\n-Poor Connection",
              inkButtonText: "<- Back To Login",
              function: () {
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (context) => Login());
                Navigator.of(context).push(route);
              },
            ),
          ));
          return print("ERROR_NETWORK_REQUEST");
          break;
        default:
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            duration: Duration(days: 1),
            backgroundColor: Theme.of(context).errorColor,
            content: FullScreenSnackBar(
                icon: Icons.do_not_disturb,
                genericText:
                    "Hi $compressedEmail, we are unable to Log you in for unknown reasons...\n" +
                        "\n-Please contact an Admin @ jnguessa@uoguelph.ca",
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

          return print("Unknwon reason");
          break;
      }
    }
    Auth().getCurrentUser().then((firebaseUser) {
      switch (firebaseUser.isEmailVerified) {
        case true:
          /*Go to calendar screen */
          MaterialPageRoute route =
              MaterialPageRoute(builder: (context) => Calendar());
          Navigator.of(context).push(route);

          break;
        case false:
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            duration: Duration(days: 1),
            content: FullScreenSnackBar(
              icon: Icons.thumb_up,
              genericText: "Hi $compressedEmail, Please Verify Your Email ",
              inkButtonText: "<- To Login",
              function: () {
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (context) => Login());
                Navigator.of(context).push(route);
              },
            ),
          ));
          break;
      }
    });
  }

  User user = new User();

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
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
                  } else {
                    setState(() {
                      User.email = value;
                    });
                    return null;
                  }
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
                  } else {
                    setState(() {
                      User.password = value;
                    });
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
        ),
      ),
    );
  }

  bool isValidEmail(String input) {
    final RegExp regex = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input);
  }
}
