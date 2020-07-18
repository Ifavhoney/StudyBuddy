import 'package:flutter/material.dart';

class GlobalFlashingCircle extends StatefulWidget {
  GlobalFlashingCircle({Key key}) : super(key: key);

  @override
  _GlobalFlashingCircleState createState() => _GlobalFlashingCircleState();
}

class _GlobalFlashingCircleState extends State<GlobalFlashingCircle>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController _animationController2;

  Animation<double> _fadeInFadeOut;
  Animation<double> _fadeInFadeOut2;

  @override
  void initState() {
    _animationController2 = new AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _fadeInFadeOut2 =
        Tween<double>(begin: 1, end: 0.8).animate(_animationController2);
    _animationController2.addStatusListener((status) {});

    _animationController = new AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _fadeInFadeOut =
        Tween<double>(begin: 1, end: 0.0).animate(_animationController);
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
        _animationController2.forward();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
        _animationController2.reverse();
      }
    });

    _animationController.forward();
    _animationController2.forward();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    _animationController2.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _flashingCircle(
            mainTransition: true,
            scale: 1.2,
            boxShadowColor: Color(0xFFBCBCBC),
            boxShapeColor: Color(0xFFF5F7FB)),
        _flashingCircle(
            mainTransition: false,
            scale: 2,
            boxShadowColor: Color(0xFFD8D8D8),
            boxShapeColor: Color(0xFFF3F8FC)),

        /*
        Center(
          child: FadeTransition(
            opacity: _fadeInFadeOut,
            child: Container(
              width: MediaQuery.of(context).size.width / 3.5,
              height: MediaQuery.of(context).size.height / 3.5,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xFFE4F1FC)),
              child: Text(" "),
            ),
          ),
          
        ),
        */
      ],
    );
  }

  Widget _flashingCircle(
          {bool mainTransition = true,
          double scale,
          Color boxShapeColor,
          Color boxShadowColor}) =>
      Center(
        child: FadeTransition(
          opacity: mainTransition == true ? _fadeInFadeOut : _fadeInFadeOut2,
          child: Container(
            width: MediaQuery.of(context).size.width / scale,
            height: MediaQuery.of(context).size.height / scale,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(color: boxShadowColor, blurRadius: 1, spreadRadius: -4)
            ], shape: BoxShape.circle, color: boxShapeColor),
            child: Text(" "),
          ),
        ),
      );
}
