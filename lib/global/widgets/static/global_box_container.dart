import 'package:flutter/material.dart';

///@LastModifiedBy: Jason NGuessan
///Container with boxShape and BoxShadow
class GlobalBoxContainer extends StatelessWidget {
  @required
  final BoxShadow boxShadow;
  @required
  final Widget child;
  final double containerHeight;
  final double containerWidth;
  final Color containerColor;
  final BoxShape boxShape;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry padding;

  const GlobalBoxContainer(
      {Key key,
      this.containerHeight,
      this.containerWidth,
      this.containerColor = Colors.white,
      this.boxShape = BoxShape.rectangle,
      this.boxShadow,
      this.borderRadius,
      this.padding = EdgeInsets.zero,
      this.child})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        height: containerHeight,
        width: containerWidth,
        padding: padding,
        decoration: BoxDecoration(
            borderRadius: borderRadius,
            shape: boxShape,
            color: containerColor,
            boxShadow: [boxShadow]),
        child: child);
  }
}
