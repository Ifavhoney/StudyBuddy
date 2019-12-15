import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_buddy/data/data.dart';
import 'package:study_buddy/reusableWidgets/ListTileIconField.dart';
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
  String reason = "";
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

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    /*
    SnackBar snackBarError = SnackBar(
        content: Text("Error"), backgroundColor: Theme.of(context).errorColor);
    */
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
                          User.fName = value;
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
                          User.lName = value;

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
                    User.email = value;

                    return null;
                  }
                },
              ),
              ListTileIconField(
                controller: password,
                leadingIcon: Icon(Icons.error),
                hintText: "Password",
                keyboardType: TextInputType.visiblePassword,
                function: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  User.password = value;

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
                    setState(() {
                      User.reason = value;
                    });
                    print("value: $value");
                  },
                  isExpanded: true,
                  hint: Text(
                    reason.length >= 1
                        ? "\t\t" + reason
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
                  if (this._formKey.currentState.validate() && reason != "") {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                        duration: Duration(seconds: 40),
                        content: Center(
                          child: Text(
                            "Check Your Email",
                            style: Theme.of(context).textTheme.display1,
                          ),
                        )));
                  } else {
                    print("NOT VALID");
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
}

bool isValidEmail(String input) {
  final RegExp regex = new RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  return regex.hasMatch(input);
}
