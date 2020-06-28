import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Container(
            child: Text("hello"),
          ),
        ),
        bottomNavigationBar: Container(
          height: 50,
          color: Colors.white,
          child: Stack(
            children: <Widget>[],
          ),
        ));
  }

  /*
BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex:
            _currentIndex, // this will be set when a new tab is tapped

        items: [
          BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text("")),
          BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text(""))
        ],
      ),
  */

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
