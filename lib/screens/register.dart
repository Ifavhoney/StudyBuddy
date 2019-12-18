import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:study_buddy/data/data.dart';
import 'dart:async';
import 'login.dart';
import 'package:study_buddy/model/BaseAuth.dart';

import 'package:study_buddy/reusableWidgets/ListTileIconField.dart';
import 'package:study_buddy/reusableWidgets/fullScreenSnackBar.dart';

import 'package:study_buddy/model/user.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController email;
  TextEditingController password;
  TextEditingController firstName;
  TextEditingController lastName;

  final databaseReference = Firestore.instance;

/*Consider implementing google sign in later */

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void createUser() async {
    final status = await Auth().checkUserExists(User.email);
    /*If new user does not exists in the system */
    if (status == false) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(days: 1),
        content: FullScreenSnackBar(
          icon: Icons.thumb_up,
          genericText: "Hi ${User.fName}, Please Verify Your Email",
          inkButtonText: "<- To Login",
          function: () {
            MaterialPageRoute route =
                MaterialPageRoute(builder: (context) => Login());
            Navigator.of(context).push(route);
          },
        ),
      ));

      Auth()
          .signUp(User.email, User.password)
          .catchError((onError) => print("invalid"));

      databaseReference.collection("Users").document(User.email).setData({
        'First Name': User.fName,
        'Last Name': User.lName,
        'Reason For Joining': User.reason,
      });
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(days: 1),
        backgroundColor: Theme.of(context).errorColor,
        content: FullScreenSnackBar(
            icon: Icons.thumb_down,
            genericText:
                "Hi ${User.fName}, we are unable to register you because...\n" +
                    "\n-Pre-existing account\n-An unverified account\n-Poor Connection",
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Register"),
      ),
      backgroundColor: Colors.brown.shade100,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                    fit: FlexFit.loose,
                    child: TextFormField(
                      controller: firstName,
                      /*Throws weird error when focused, then goes away */
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: "First Name",
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Cannot be empty";
                        } else {
                          setState(() {
                            User.fName = value;
                          });
                          return null;
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: lastName,
                      decoration: InputDecoration(hintText: "Last Name"),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Cannot be empty";
                        } else {
                          setState(() {
                            User.lName = value;
                          });
                          return null;
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 15,
              ),
              ListTileIconField(
                controller: email,
                leadingIcon: Icon(Icons.email),
                hintText: "Email",
                keyboardType: TextInputType.emailAddress,
                function: (String value) {
                  if (!isValidEmail(value)) {
                    return "Invalid Email";
                  } else {
                    setState(() {
                      User.email = value;
                    });

                    return null;
                  }
                },
              ),
              ListTileIconField(
                controller: password,
                isPassword: true,
                leadingIcon: Icon(Icons.error),
                hintText: "Password",
                keyboardType: TextInputType.visiblePassword,
                function: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  if (value.length <= 6) {
                    return 'Password must be greater than 6 characters';
                  }
                  setState(() {
                    User.password = value;
                  });

                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                color: AppBarTheme.of(context).color,
                child: DropdownButton(
                  items: Data.items,
                  onChanged: (value) {
                    if (value != "") {
                      setState(() {
                        User.reason = value;
                      });
                    } else {
                      return null;
                    }
                  },
                  isExpanded: true,
                  hint: Text(
                    User.reason != null
                        ? "\t\t" + User.reason
                        : "\t\tSelect a reason for Joining",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (this._formKey.currentState.validate() &&
                      User.reason != null) {
                    createUser();
                  } else {
                    print("NOT VALID ${User.reason}");
                  }
                },
              ),
            ],
          ),
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
