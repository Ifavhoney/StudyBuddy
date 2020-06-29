import 'package:buddy/searching/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:buddy/theme/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.mainTheme,
      home: SearchScreen(),
    );
  }
}
