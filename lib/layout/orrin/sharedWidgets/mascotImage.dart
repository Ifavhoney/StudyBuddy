import 'package:flutter/material.dart';

class MascotImage extends StatelessWidget {
  
  final double size;

  MascotImage({Key key, this.size}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Image(
      width: size,
      image: AssetImage('assets/images/mascot.png',),);
  }
}