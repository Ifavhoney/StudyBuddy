import 'package:flutter/material.dart';
import 'package:study_buddy/screens/AddFriends/FindFriends/randomUsers.dart';
import 'package:study_buddy/screens/AddFriends/FindFriends/schoolUser.dart';

class NavigationPageFF extends StatefulWidget {
  _NavigationPageFFState createState() => _NavigationPageFFState();
}

class _NavigationPageFFState extends State<NavigationPageFF> {
  int _currentIndex = 0;
  final List<Widget> _children = [RandomUsers(), SchoolUsers()];

  void SelectPage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add as a Friend"),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Strangers'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            title: Text('School Users'),
          ),
        ],
        onTap: SelectPage,
        currentIndex: _currentIndex,
      ),
    );
  }
}
