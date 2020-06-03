import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_buddy/helpers/debug_helper.dart';
import 'package:study_buddy/model/BaseAuth.dart';
import 'package:study_buddy/model/rootScreen.dart';

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
        home: RootScreen(
          auth: Auth(),
        )
        //home: CamPortal("A@gmail.com"),
        // home: CalendarStatus("Blob@gmail.com"),
        // home: CalendarStatus("Blob@gmail.com"),
        );
  }
}
