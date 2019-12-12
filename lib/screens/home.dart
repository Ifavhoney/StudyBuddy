import 'package:flutter/material.dart';
import 'login.dart';

class Home extends StatelessWidget {
  final String title;
  const Home({this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.teal.shade100,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FloatingActionButton(
                child: Icon(Icons.arrow_forward_ios),
                backgroundColor: Colors.white54,
                onPressed: () {
                  MaterialPageRoute mr =
                      MaterialPageRoute(builder: (BuildContext context) {
                    return Login();
                  });
                  Navigator.of(context).push(mr);
                },
              )
            ],
          ),
        ));
  }
}
