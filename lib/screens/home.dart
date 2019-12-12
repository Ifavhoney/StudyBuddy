import 'package:flutter/material.dart';
import 'login.dart';
import 'package:study_buddy/reusableWidgets/actionButton.dart';

class Home extends StatelessWidget {
  final String title;
  const Home({this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.teal.shade100,
        body: Center(
            child: ActionButton(
          color: Colors.white54,
          icon: Icon(Icons.arrow_forward_ios),
          event: () {
            MaterialPageRoute route =
                MaterialPageRoute(builder: (BuildContext context) {
              return Login();
            });
            Navigator.of(context).push(route);
          },
        )));
  }
}
