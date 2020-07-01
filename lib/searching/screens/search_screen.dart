import 'package:buddy/theme/theme.dart';
import 'package:flutter/material.dart';

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
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.mic,
            size: 100,
          ),
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
                        color: Colors.grey.shade400,
                        blurRadius: 10,
                        spreadRadius: 2)
                  ]),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.settings,
                              color: Color(0xFF6F8BA4),
                              size: 40,
                            ),
                            onPressed: () {
                              setState(() {
                                _currentIndex = 0;
                              });
                            },
                          ),
                          Container(),
                          Container(),
                          Container(),
                          Container(),
                          IconButton(
                            icon: Icon(
                              Icons.people,
                              color: Color(0xFF6F8BA4),
                              size: 40,
                            ),
                            onPressed: () {
                              setState(() {
                                _currentIndex = 2;
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.today,
                              color: Color(0xFF6F8BA4),
                              size: 40,
                            ),
                            onPressed: () {
                              setState(() {
                                _currentIndex = 3;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 40),
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(AppTheme.),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black,
                                blurRadius: 8,
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
                ),
              ),
            ),
            Positioned(
                child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Text("Buddy",
                    style: TextStyle(
                        fontFamily: "Nexa",
                        fontSize: 14,
                        color: Color(0xFFB9D1FF))),
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
