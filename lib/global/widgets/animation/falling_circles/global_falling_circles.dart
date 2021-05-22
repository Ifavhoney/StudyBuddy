import 'package:flutter/material.dart';

import 'global_falling_circle.dart';

///@LastModifiedBy: Jason NGuessan
class GlobalFallingCircles extends StatefulWidget {
  final int durationInSeconds;
  final double heightOfDevice;
  final double widthOfDevice;

  ///Use this with a stack widget
  GlobalFallingCircles(
      {Key key,
      @required this.durationInSeconds,
      @required this.heightOfDevice,
      @required this.widthOfDevice})
      : super(key: key);
  @override
  _GlobalFallingCirclesState createState() => _GlobalFallingCirclesState();
}

class _GlobalFallingCirclesState extends State<GlobalFallingCircles> {
  @override
  Widget build(BuildContext context) => _allCircles();

  Widget _circle() {
    return GlobalFallingCircle(
      durationInSeconds: widget.durationInSeconds,
      heightOfDevice: widget.heightOfDevice,
      widthOfDevice: widget.widthOfDevice,
    );
  }

  Widget _allCircles() {
    return Stack(
      children: <Widget>[
        _circle(),
        _circle(),
        _circle(),
        _circle(),
        _circle(),
        _circle(),
        _circle(),
        _circle(),
        _circle(),
        _circle(),
        _circle(),
        _circle(),
        _circle(),
      ],
    );
  }
}
