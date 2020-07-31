import 'package:buddy/global/widgets/animation/global_flashing_circle.dart';

import 'package:flutter/material.dart';

///@LastModifiedBy: Jason NGuessan
class SearchingScreen extends StatefulWidget {
  @override
  _SearchingScreenState createState() => _SearchingScreenState();
}

class _SearchingScreenState extends State<SearchingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        GlobalFlashingCircle(),
        _mascot(),
        /*
        GlobalFallingCircles(
          durationInSeconds: 10,
          heightOfDevice: MediaQuery.of(context).size.height,
          widthOfDevice: MediaQuery.of(context).size.width,
        )
        */
      ]),
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
}
