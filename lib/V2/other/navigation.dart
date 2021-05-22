import 'package:buddy/V2/other/login_view_2.dart';
import 'package:buddy/V2/other/messages.dart';
import 'package:buddy/V2/other/register.dart';
import 'package:buddy/V2/other/sizeConfig.dart';
import 'package:buddy/layout/auth/view/welcome_view.dart';
import 'package:buddy/layout/orrin/screens/maintenance.dart';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class BottomNavigatorPage extends StatefulWidget {
  @override
  _BottomNavigatorPageState createState() => _BottomNavigatorPageState();
}

class _BottomNavigatorPageState extends State<BottomNavigatorPage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    WelcomeView(),
    LoginView2(),
    Register(),
    Maintenance(),
    MessageList()
  ];

  void SelectPage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.purple,
            ),
            label: 'Intro',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.cloud,
              color: Colors.purple,
            ),
            label: 'Login',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.cloud,
                color: Colors.purple,
              ),
              label: "Registration"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.cloud,
                color: Colors.purple,
              ),
              label: "Messages"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.cloud,
                color: Colors.purple,
              ),
              label: "Friends"),
        ],
        onTap: SelectPage,
        currentIndex: _currentIndex,
      ),
    );
  }
}
