import 'package:buddy/global/widgets/animation/global_falling_circles.dart';
import 'package:buddy/global/widgets/static/global_box_container.dart';
import 'package:buddy/global/widgets/static/global_navigation_bar.dart';
import 'package:buddy/theme/theme.dart';
import 'package:flutter/material.dart';

///@LastModifiedBy: Jason NGuessan
class WaitingScreen extends StatefulWidget {
  @override
  _WaitingScreenState createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
          _searchBackround(),
          _search(),
          GlobalFallingCircles(
            durationInSeconds: 10,
            heightOfDevice: MediaQuery.of(context).size.height,
            widthOfDevice: MediaQuery.of(context).size.width,
          )
        ]),
        backgroundColor: Colors.white,
        bottomNavigationBar: GlobalNavigationBar());
  }

  Widget _search() => Center(
        child: GlobalBoxContainer(
          boxShape: BoxShape.circle,
          boxShadow: BoxShadow(
              color: Color(0xFF737BCE), blurRadius: 8, spreadRadius: -2),
          child: Padding(
            padding: const EdgeInsets.all(23.0),
            child: Icon(
              Icons.search,
              size: 45,
              color: AppTheme.searchingScreenIcons["search"].withOpacity(0.8),
            ),
          ),
        ),
      );

  Widget _searchBackround() => Positioned.fill(
        right: 2,
        top: 2,
        child: Center(
          child: Transform.rotate(
            angle: 205,
            child: Container(
              padding: EdgeInsets.all(75),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(colors: [
                    Color(0xFFDDC3EC),
                    Color(0xFFB9D1FF),
                  ])),
              child: Text("  "),
            ),
          ),
        ),
      );
}
