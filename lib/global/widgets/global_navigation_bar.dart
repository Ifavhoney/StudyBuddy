import 'package:buddy/global/widgets/global_box_container.dart';
import 'package:buddy/theme/theme.dart';
import 'package:flutter/material.dart';

class GlobalNavigationBar extends StatefulWidget {
  GlobalNavigationBar({Key key}) : super(key: key);

  @override
  _GlobalNavigationBarState createState() => _GlobalNavigationBarState();
}

class _GlobalNavigationBarState extends State<GlobalNavigationBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(height: 120, color: Colors.white, child: _navigationBar());
  }

//Widgets
  Widget _navigationBar() => Stack(
        children: <Widget>[
          Positioned(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GlobalBoxContainer(
                containerHeight: 100,
                boxShadow: BoxShadow(
                    color: Colors.grey.shade400,
                    blurRadius: 10,
                    spreadRadius: 2),
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20, top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _icon(Icons.settings, 0),
                        Container(),
                        Container(),
                        Container(),
                        Container(),
                        _icon(Icons.people, 2),
                        _icon(Icons.today, 3)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          _search(),
          _buddy()
        ],
      );

  Widget _icon(IconData icon, int index) => Column(
        children: <Widget>[
          IconButton(
            icon: Icon(
              icon,
              color: _currentIndex == index
                  ? AppTheme.bottomNavigationBarIcons["active"]
                  : AppTheme.bottomNavigationBarIcons["inactive"],
              size: 35,
            ),
            onPressed: () {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          _dot(index),
        ],
      );

  Widget _search() => Positioned(
        child: GestureDetector(
            onTap: () {
              setState(() {
                _currentIndex = 1;
              });
            },
            child: Column(
              children: <Widget>[
                Align(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 40),
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == 1
                              ? AppTheme.bottomNavigationBarIcons["active"]
                              : AppTheme.bottomNavigationBarIcons["search"],
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
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      );

  Widget _buddy() => Positioned(
          child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Text("Buddy",
              style: AppTheme.nexa.bodyText1.apply(color: Color(0xFFB9D1FF))),
        ),
      ));

  Widget _dot(int index) => _currentIndex == index
      ? Transform(
          transform: Matrix4.translationValues(3, -8.5, 0.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.bottomNavigationBarIcons["active"],
            ),
            child: Text("  "),
          ),
        )
      : Container();
}
