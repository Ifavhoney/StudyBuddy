import 'package:buddy/global/widgets/animation/global_falling_circle.dart';
import 'package:buddy/global/widgets/animation/global_flashing_circle.dart';
import 'package:buddy/global/widgets/static/global_box_container.dart';
import 'package:buddy/theme/theme.dart';
import 'package:flutter/material.dart';

class SearchingScreen extends StatefulWidget {
  @override
  _SearchingScreenState createState() => _SearchingScreenState();
}

class _SearchingScreenState extends State<SearchingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: <Widget>[GlobalFlashingCircle(), _mascot(), _allCircles()]),
      backgroundColor: Colors.white,
    );
  }

  Widget _mascot() => Center(
        child: Image.asset(
          "assets/images/mascot.png",
          fit: BoxFit.scaleDown,
          height: MediaQuery.of(context).size.height / 14,
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

  Widget _circles() {
    return GlobalFallingCircle(
      durationInSeconds: 10,
      heightOfDevice: MediaQuery.of(context).size.height,
      widthOfDevice: MediaQuery.of(context).size.width,
    );
  }

  Widget _allCircles() {
    return Stack(
      children: <Widget>[],
    );
  }
}
