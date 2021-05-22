import 'dart:math';

import 'package:buddy/global/widgets/static/global_trademark_text.dart';
import 'package:buddy/layout/orrin/sharedWidgets/mascotImage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///Fade through, no relatonsh
class GlobalSpinner extends StatelessWidget {
  static const routeName = '/spinner';

  final Widget child;
  const GlobalSpinner({this.child});

  @override
  Widget build(BuildContext context) {
    return child != null
        ? Stack(
            children: [AbsorbPointer(child: child), _spinner()],
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
        color: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1),
        size: 0.1.sh,
        duration: Duration(milliseconds: 900),
        lineWidth: 0.02.sw,
      ),
    );
  }
}
