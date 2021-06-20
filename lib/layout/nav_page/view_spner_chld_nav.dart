import 'package:animations/animations.dart';
import 'package:buddy/global/widgets/animation/spinner/global_spinner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///Transition from Spinner To Child
///Fade Through

class ViewSpnerChldNav extends StatefulWidget {
  final Widget child;
  final int ms;
  final bool isReady;
  ViewSpnerChldNav({this.isReady, this.ms = 400, @required this.child});

  @override
  _ViewSpnerChldNavState createState() => _ViewSpnerChldNavState();
}

class _ViewSpnerChldNavState extends State<ViewSpnerChldNav> {
  int pageIndex = 0;

  Map<bool, Widget> pageList;
  bool isReady;

  @override
  void initState() {
    super.initState();
    pageList = {false: GlobalSpinner(child: Container()), true: widget.child};
  }

  @override
  Widget build(BuildContext context) {
    widget.isReady == null
        ? Future.delayed(Duration.zero, () {
            setState(() {
              isReady = true;
            });
          })
        : Future.delayed(Duration.zero, () {
            setState(() {
              isReady = widget.isReady;
            });
          });

    return Scaffold(
      body: PageTransitionSwitcher(
          duration: Duration(milliseconds: widget.ms),
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
          child: pageList[isReady]),
    );
  }
}
