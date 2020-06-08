import 'package:flutter/material.dart';
import 'package:study_buddy/model/BaseAuth.dart';
import 'package:study_buddy/screens/AddFriends/FriendandRequest/friendList.dart';
import 'package:study_buddy/screens/AddFriends/FriendandRequest/friendRequest.dart';
import 'package:study_buddy/screens/AddFriends/NavigationFF.dart';

class NavigationPage extends StatefulWidget {
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  
  String currentUser;

  @override
  void initState() {
    super.initState();
    Auth().getCurrentUser().then((firebaseUser) {
      this.currentUser = firebaseUser.email.toString();
    }).catchError((error) {
      this.currentUser = "dummy@gmail.com";
      //Re login
    });
  }

  int _currentIndex = 0;
  final List<Widget> _children = [
    FriendList(),
    FriendRequest()
    // DevicesFromCloud()
  ];

  void SelectPage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () {
              MaterialPageRoute route =
                  MaterialPageRoute(builder: (context) => NavigationPageFF());
              Navigator.of(context).push(route);
            },
          ),
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Friends'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            title: Text('Requests'),
          ),
        ],
        onTap: SelectPage,
        currentIndex: _currentIndex,
      ),
    );
  }
}
