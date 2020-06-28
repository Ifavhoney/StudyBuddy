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
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        height: 120,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 90,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Color(0xff6F8BA4),
                        blurRadius: 10,
                        spreadRadius: -2)
                  ]),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Material(
                            color: Colors.white,
                            child: Icon(
                              Icons.settings,
                              color: Color(0xFF6F8BA4),
                              size: 40,
                            ),
                          ),
                          Container(),
                          Container(),
                          Container(),
                          Container(),
                          Icon(
                            Icons.people,
                            color: Color(0xFF6F8BA4),
                            size: 40,
                          ),
                          Icon(
                            Icons.today,
                            color: Color(0xFF6F8BA4),
                            size: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
                child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(right: 40),
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF8BB1FB),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xff6F8BA4),
                            blurRadius: 10,
                            spreadRadius: -2)
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Icon(
                      Icons.search,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )),
            Positioned(
                child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Bud"),
              ),
            )),

            /*
                Icon(
                  Icons.search,
                  color: Color(0xFF6F8BA4),
                  size: 35,
                )
                */
          ],
        ),
      ),
    );
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
