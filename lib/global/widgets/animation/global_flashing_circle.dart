import 'dart:io';

import 'package:flutter/material.dart';

///@LastModifiedBy: Jason NGuessan
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
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _flashingCircle(
            transition: _fadeInFadeOut,
            scale: 1.2,
            boxShadowColor: Color(0xFFBCBCBC),
            boxShapeColor: Color(0xFFF5F7FB)),
        _flashingCircle(
            transition: _fadeInFadeOut2,
            scale: 2,
            boxShadowColor: Color(0xFFD8D8D8),
            boxShapeColor: Color(0xFFF3F8FC)),
        _circle(
            scale: 3.5,
            boxShadowColor: Color(0xFFC5C5C5),
            boxShapeColor: Color(0xFFE4F1FC))
      ],
    );
  }

  Widget _flashingCircle(
          {Animation<double> transition,
          double scale,
          Color boxShapeColor,
          Color boxShadowColor}) =>
      Center(
        child: FadeTransition(
            opacity: transition,
            child: _circle(
                scale: scale,
                boxShadowColor: boxShadowColor,
                boxShapeColor: boxShapeColor)),
      );

  Widget _circle(
          {Animation<double> transition,
          double scale,
          Color boxShapeColor,
          Color boxShadowColor}) =>
      Center(
        child: Container(
          width: MediaQuery.of(context).size.width / scale,
          height: MediaQuery.of(context).size.height / scale,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(color: boxShadowColor, blurRadius: 1, spreadRadius: -4)
          ], shape: BoxShape.circle, color: boxShapeColor),
          child: Text(" "),
        ),
      );

  AnimationController _createAnimationController(int seconds) {
    return new AnimationController(
      vsync: this,
      duration: Duration(seconds: seconds),
    );
  }

  Animation<double> _createFadeInTransition(
      {AnimationController animationController, double begin, double end}) {
    return new Tween<double>(begin: begin, end: end)
        .animate(animationController);
  }

  @override
  void initState() {
    //bug with IOS, for some reason the seconds are not the same
    int seconds = Platform.isAndroid == true ? 20 : 1;
    _animationController2 = _createAnimationController(seconds);
    _fadeInFadeOut2 = _createFadeInTransition(
        begin: 1, end: 0.5, animationController: _animationController2);

    _animationController = _createAnimationController(seconds);
    _fadeInFadeOut = _createFadeInTransition(
        begin: 1, end: 0, animationController: _animationController);

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
    _animationController.dispose();
    _animationController2.dispose();

    super.dispose();
  }
}
