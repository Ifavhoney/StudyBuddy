import 'package:flutter/material.dart';

class FlashingCam extends StatefulWidget {
  @override
  _FlashingCamState createState() => _FlashingCamState();
}

class _FlashingCamState extends State<FlashingCam>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _fadeInFadeOut;

  @override
  void initState() {
    _animationController = new AnimationController(
      vsync: this,
      duration: Duration(seconds: 20),
    );
    _fadeInFadeOut =
        Tween<double>(begin: 0.0, end: 0.2).animate(_animationController);

    //If it's done reverse
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      }
      //If it's near the beginning, start moving fotward
      else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
    _animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: FadeTransition(
            opacity: _fadeInFadeOut,
            child: Container(
              width: MediaQuery.of(context).size.width / 1.5,
              height: MediaQuery.of(context).size.height / 1.5,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.green),
              child: Text(" "),
            ),
          ),
        ),
        Center(
          child: FadeTransition(
            opacity: _fadeInFadeOut,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.lightBlue),
              child: Text(" "),
            ),
          ),
        ),
        Center(
          child: Icon(
            Icons.videocam,
            size: MediaQuery.of(context).size.height / 2.8,
            color: Colors.teal.shade300,
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Text(
            "Buddy",
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
