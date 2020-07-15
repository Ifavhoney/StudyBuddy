import 'package:flutter/material.dart';

///Container with boxShape and BoxShadow
class GlobalBoxContainer extends StatelessWidget {
  @required
  final BoxShadow boxShadow;
  @required
  final Widget child;
  final double containerHeight;
  final Color containerColor;
  final BoxShape boxShape;

  const GlobalBoxContainer(
      {Key key,
      this.containerHeight,
      this.containerColor = Colors.white,
      this.boxShape = BoxShape.rectangle,
      this.boxShadow,
      this.child})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        height: containerHeight,
        decoration: BoxDecoration(
            shape: boxShape, color: containerColor, boxShadow: [boxShadow]),
        child: child);
  }
}
