import 'package:buddy/global/theme/theme.dart';
import 'package:buddy/layout/auth/screens/login.dart';
import 'package:flutter/material.dart';
import 'layout/searching/screens/searching_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.mainTheme,
      home: Login(),
    );
  }
}
