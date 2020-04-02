import 'package:flutter/material.dart';
import 'package:study_buddy/screens/calendarPortal.dart';

import 'package:study_buddy/screens/login.dart';
import 'package:study_buddy/screens/register.dart';
import 'package:study_buddy/screens/calendarStatus.dart';
import 'package:study_buddy/screens/webcam/camPortal.dart';
import 'package:study_buddy/theme/theme.dart';
import 'package:study_buddy/screens/calendar.dart';

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
      home: Login(),
      //home: CamPortal("A@gmail.com"),
      // home: CalendarStatus("Blob@gmail.com"),
      // home: CalendarStatus("Blob@gmail.com"),
    );
  }
}
