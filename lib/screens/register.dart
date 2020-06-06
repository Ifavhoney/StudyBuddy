import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:study_buddy/data/data.dart';
import 'login.dart';
import 'package:study_buddy/model/BaseAuth.dart';

import 'package:study_buddy/reusableWidgets/listTileIconField.dart';
import 'package:study_buddy/reusableWidgets/fullScreenSnackBar.dart';

import 'package:study_buddy/model/user.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _schoolFormKey = GlobalKey<FormState>();

  TextEditingController email;
  TextEditingController password;
  TextEditingController firstName;
  TextEditingController lastName;
  TextEditingController schoolEmail;

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
          genericText: "Hi ${User.fName}, Please Verify Your Email ",
          inkButtonText: "<- To Login",
          function: () {
            MaterialPageRoute route =
                MaterialPageRoute(builder: (context) => Login());
            Navigator.of(context).push(route).then((value) => _formKey.currentState.reset());
          },
        ),
      ));

      Auth()
          .signUp(User.email, User.password)
          .then((user) => Auth().sendEmailVerification())
          .catchError((onError) => print("invalid"));

      if (User.reason == "School") {
        databaseReference.collection("Users").document(User.email).setData({
          'First Name': User.fName,
          'Last Name': User.lName,
          'Reason For Joining': User.reason,
          "Show Get Started": User.showGetStarted.toString(),
          "School Name": User.schoolName,
          "School Email": User.schoolEmail
        });
      } else {
        databaseReference.collection("Users").document(User.email).setData({
          'First Name': User.fName,
          'Last Name': User.lName,
          'Reason For Joining': User.reason,
          "Show Get Started": User.showGetStarted.toString(),
        });
      }
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

  selectSchoolInfo(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Form(
                      key: _schoolFormKey,
                      child: new Column(
                        children: <Widget>[
                          Container(
                            color: AppBarTheme.of(context).color,
                            child: DropdownButton(
                              items: Data.schools(),
                              onChanged: (value) {
                                if (value != "") {
                                  setState(() {
                                    User.schoolName = value;
                                  });
                                } else {
                                  return null;
                                }
                              },
                              isExpanded: true,
                              hint: Text(
                                User.schoolName != null
                                    ? "\t\t" + User.schoolName
                                    : "\t\tSelect a School you're attending",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ListTileIconField(
                            controller: schoolEmail,
                            leadingIcon: Icon(Icons.email),
                            hintText: "School Email",
                            keyboardType: TextInputType.emailAddress,
                            function: (String value) {
                              if (!isValidEmail(value)) {
                                return "Invalid Email";
                              } else if (value.contains("@outlook.com") ||
                                  value.contains("@hotmail.com") ||
                                  value.contains("@hotmail.ca") ||
                                  value.contains("@gmail.com") ||
                                  value.contains("@yahoo.ca") ||
                                  value.contains("@yahoo.com")) {
                                return "School Email is only valid";
                              } else {
                                setState(() {
                                  User.schoolEmail = value;
                                });
                                return null;
                              }
                            },
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
                              if (this._schoolFormKey.currentState.validate() &&
                                  User.schoolEmail != null) {
                                MaterialPageRoute route = MaterialPageRoute(
                                    builder: (context) => Register());
                                Navigator.of(context).pop(route);
                                _schoolFormKey.currentState.reset();
                              } else {
                                print("Please put in email");
                              }
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  items: Data.items(),
                  onChanged: (value) {
                    if (value != "") {
                      setState(() {
                        User.reason = value;
                        if (User.reason == "School") {
                          selectSchoolInfo(context);
                        }
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
                    User.showGetStarted = true;
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
