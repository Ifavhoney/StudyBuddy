import 'package:flutter/material.dart';

import 'package:study_buddy/screens/login.dart';
import 'package:study_buddy/screens/register.dart';
import 'package:study_buddy/screens/calendar.dart';
import 'package:study_buddy/theme/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Buddy',
      debugShowCheckedModeBanner: false,
      theme: theme,
      // home: Home(title: ''),
      // home: Login());

      home: Calendar(),
    );
  }
}
