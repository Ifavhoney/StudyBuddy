import 'package:buddy/global/global.dart';
import 'package:buddy/global/theme/theme.dart';
import 'package:buddy/global/widgets/static/global_box_container.dart';
import 'package:buddy/global/widgets/static/global_trademark_text.dart';
import 'package:flutter/material.dart';

///@LastModifiedBy: Jason NGuessan
class GlobalBottomNavigationBar extends StatefulWidget {
  GlobalBottomNavigationBar({Key key}) : super(key: key);

  @override
  _GlobalBottomNavigationBarState createState() =>
      _GlobalBottomNavigationBarState();
}

class _GlobalBottomNavigationBarState extends State<GlobalBottomNavigationBar> {
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

                        //   _icon(Icons.power_settings_new, 0),

                        Container(),
                        Container(),
                        Container(),
                        Container(),
                        _icon(Icons.people, 2),
                        // _icon(Icons.today, 3)
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
                  ? Global.appTheme.iconColors.bottomNavigationBar["active"]
                  : Global.appTheme.iconColors.bottomNavigationBar["inactive"],
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
                              ? Global.appTheme.iconColors
                                  .bottomNavigationBar["active"]
                              : Global.appTheme.iconColors
                                  .bottomNavigationBar["search"],
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

  Widget _buddy() => Positioned(child: GlobalTrademarkText());

  Widget _dot(int index) => _currentIndex == index
      ? Transform(
          transform: Matrix4.translationValues(3, -8.5, 0.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Global.appTheme.iconColors.bottomNavigationBar["active"],
            ),
            child: Text("  "),
          ),
        )
      : Container();
}
