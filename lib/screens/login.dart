import 'package:flutter/material.dart';
import 'package:study_buddy/reusableWidgets/actionButton.dart';
import 'register.dart';

class Login extends StatelessWidget {
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
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: "example@gmail.com",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0))),
                  controller: email,
                  validator: (String value) {
                    if (!value.endsWith(".ca") ||
                        !value.endsWith(".com") ||
                        !value.contains("@")) {
                      return 'Invalid';
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
                    color: Theme.of(context).buttonColor,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                      } else {
                        print("Not Valid");
                      }
                    }),
              ),
            ],
          )),
    );
  }
}
