import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_buddy/data/data.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int status = -1;
/*Consider implementing google sign in later */
  @override
  void initState() {
    super.initState();
    /*
    Firestore.instance
        .collection('books')
        .document()
        .setData({'title': 'title', 'author': 'IOS??'});
        */
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SnackBar snackBarError = SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text("Fill all Fields Accordingly")],
        ),
        backgroundColor: Theme.of(context).errorColor);

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
                    return "not valid";
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
                    try {
                      createUser();
                    } catch (e) {
                      print(e.toString());
                    }
                    if (status >= 0) {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        duration: Duration(seconds: 10),
                        content: FullScreenSnackBar(
                          icon: Icons.thumb_up,
                          genericText:
                              "Hi ${User.fName}, Please Verify Your Email",
                          flatButtonText: "To Login",
                          function: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ));
                    } else {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        backgroundColor: Theme.of(context).errorColor,
                        content: FullScreenSnackBar(
                          icon: Icons.thumb_down,
                          genericText:
                              "Hi ${User.fName}, you may have a pre-existing account or an unverified account",
                        ),
                      ));
                    }
                  } else {
                    print("NOT VALID ${User.reason}");
                  }
                },
              ),

              /*
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 5,
                  ),
                  Text("Male"),
                  SizedBox(
                    width: 15,
                  ),
                  Text("Female"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Radio(
                    value: 0,
                    groupValue: _groupValue,
                    onChanged: this.onChanged,
                  ),
                  Radio(
                    value: 1,
                    groupValue: _groupValue,
                    onChanged: this.onChanged,
                  ),
                ],
                
              ),
              */
            ],
          ),
        ),
      ),
    );
  }

  void createUser() async {
    try {
      if (await _auth.createUserWithEmailAndPassword(
              email: User.email, password: User.password) ==
          null) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("User Already exists"),
        ));
      } else {
        await _auth
            .createUserWithEmailAndPassword(
                email: User.email, password: User.password)
            .then((AuthResult result) {
          result.user.sendEmailVerification();
        }).catchError((error) {
          print("Failed to create user");
        });

        await databaseReference
            .collection("Users")
            .document(User.email)
            .setData({
          'First Name': User.fName,
          'Last Name': User.lName,
          'Reason For Joining': User.reason,
        });
        status = 0;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  bool isValidEmail(String input) {
    final RegExp regex = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input);
  }
}
