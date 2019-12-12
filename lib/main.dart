import 'package:flutter/material.dart';

import 'package:study_buddy/screens/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Buddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(backgroundColor: Colors.teal.shade100),
      home: Home(title: ''),
    );
  }
}
