import 'dart:io';
import 'dart:math';
import 'package:buddy/global/widgets/static/global_box_container.dart';
import 'package:flutter/material.dart';

///@LastModifiedBy: Jason NGuessan
class GlobalFallingCircle extends StatefulWidget {
  final int durationInSeconds;
  final double heightOfDevice;
  final double widthOfDevice;

  ///Use this with a stack widget or with GlobalFallingCircles
  GlobalFallingCircle(
      {Key key,
      @required this.durationInSeconds,
      @required this.heightOfDevice,
      @required this.widthOfDevice})
      : super(key: key);

  @override
  _GlobalFallingCircleState createState() => _GlobalFallingCircleState();
}

class _GlobalFallingCircleState extends State<GlobalFallingCircle>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  static Color _colorPicker =
      Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  Color _color = _colorPicker;
  int _rightPosition;

  @override
  Widget build(BuildContext context) => _dots();

  Widget _dots() {
    return Positioned(
      top: _animation.value,
      right: _rightPosition.toDouble(),
      child: GlobalBoxContainer(
        boxShape: BoxShape.circle,
        containerColor: _color,
        containerHeight: 20,
        containerWidth: 10,
        boxShadow: BoxShadow(
            color: Color(0xFF0029F5), blurRadius: 8, spreadRadius: -2),
        child: Text(" "),
      ),
    );
  }

  @override
  void initState() {
    int seconds = Platform.isAndroid == true ? 20 : 1;
    super.initState();

    _controller = AnimationController(
        duration: Duration(
            seconds: Random().nextInt(widget.durationInSeconds) + seconds),
        vsync: this);
    _animation =
        Tween<double>(begin: 0, end: widget.heightOfDevice).animate(_controller)
          ..addListener(() {
            //  print(animation.value);
            setState(() {});
            if (_animation.isCompleted) {
              _controller.reset();
              Future.delayed(Duration(seconds: Random().nextInt(2)), () {
                _controller.forward();
              });
              _controller.duration = Duration(
                  seconds:
                      Random().nextInt(widget.durationInSeconds) + seconds);

              _rightPosition = Random().nextInt(widget.widthOfDevice.floor());
              _color = Color((Random().nextDouble() * 0xFFFFFF).toInt())
                  .withOpacity(1.0);
            }
          });

    _controller.forward();

    _rightPosition = Random().nextInt(widget.widthOfDevice.floor());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
