import 'dart:math';

import 'package:buddy/global/widgets/static/global_trademark_text.dart';
import 'package:buddy/layout/orrin/sharedWidgets/mascotImage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlobalSpinner extends StatelessWidget {
  static const routeName = '/spinner';
  final double height;
  final double width;

  final Color color;
  final Widget child;
  const GlobalSpinner({this.child, this.height, this.width, this.color});

  @override
  Widget build(BuildContext context) {
    return child != null
        ? Stack(
            children: [
              Align(
                  alignment: Alignment.center,
                  child: AbsorbPointer(child: child)),
              _spinner(),
              GlobalTrademarkText()
            ],
          )
        : Stack(
            children: [
              Positioned(top: 0.03.sh, child: MascotImage(size: 0.2.sh)),
              _spinner(),
              GlobalTrademarkText()
            ],
          );
  }

  Widget _spinner([Alignment align = Alignment.center]) {
    return Align(
      alignment: align,
      child: SpinKitRing(
        color: color ??
            Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1),
        size: height ?? 0.1.sh,
        duration: Duration(milliseconds: 900),
        lineWidth: width ?? 0.02.sw,
      ),
    );
  }
}
