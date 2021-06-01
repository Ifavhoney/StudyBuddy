import 'package:flutter/material.dart';

///@LastModifiedBy: Jason NGuessan
///Container with boxShape and BoxShadow
class GlobalBoxContainer extends StatelessWidget {
  final BoxShadow boxShadow;
  final Widget child;
  final double containerHeight;
  final double containerWidth;
  final Color containerColor;
  final BoxShape boxShape;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry padding;
  final double borderWidth;
  final LinearGradient gradient;

  const GlobalBoxContainer(
      {Key key,
      this.containerHeight,
      this.containerWidth,
      this.containerColor = Colors.white,
      this.boxShape = BoxShape.rectangle,
      @required this.boxShadow,
      this.borderRadius,
      this.padding = EdgeInsets.zero,
      this.borderWidth,
      @required this.child,
      this.gradient})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        height: containerHeight,
        width: containerWidth,
        padding: padding,
        decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: gradient, //Color(0xFFDDC3EC), Color(0xFFB9D1FF),
            shape: boxShape,
            border: borderWidth == null ? null : Border.all(width: borderWidth),
            color: containerColor,
            boxShadow: [boxShadow]),
        child: child);
  }
}
