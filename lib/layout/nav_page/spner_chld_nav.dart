import 'package:animations/animations.dart';
import 'package:buddy/global/widgets/animation/spinner/global_spinner.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

///Transition from Spinner To Child
///Fade Through
class SpnerChldNav extends StatefulWidget {
  final bool isReady;
  final Widget child;
  SpnerChldNav({@required this.isReady, @required this.child});
  @override
  _SpnerChldNavState createState() => _SpnerChldNavState();
}

class _SpnerChldNavState extends State<SpnerChldNav> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    Map<bool, Widget> pageList = {false: GlobalSpinner(), true: widget.child};
    int ms = kDebugMode == true ? 1 : 500;
    return Scaffold(
      body: PageTransitionSwitcher(
        duration: Duration(milliseconds: ms),
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: pageList[widget.isReady],
      ),
    );
  }
}
