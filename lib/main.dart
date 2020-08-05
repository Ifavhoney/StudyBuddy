import 'package:buddy/global/theme/theme.dart';
import 'package:buddy/layout/auth/view/login_view.dart';
import 'package:buddy/layout/home/view/searching_view.dart';
import 'package:buddy/layout/home/view/waiting_view.dart';
import 'package:buddy/signInDemo.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.mainTheme,
      home: LoginView(),
      routes: {
        LoginView.routeName: (ctx) => LoginView(),
        WaitingView.routeName: (ctx) => WaitingView(),
        SearchingView.routeName: (ctx) => SearchingView(),
      },
    );
  }
}
