import 'package:animations/animations.dart';
import 'package:buddy/global/widgets/animation/spinner/global_spinner.dart';
import 'package:buddy/global/widgets/static/global_trademark_text.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

///Transition from Spinner To Child
///Fade Through

class ViewSpnerChldNav extends StatefulWidget {
  final bool isReady;
  final Widget child;
  final bool unRelatedView;
  final int ms;

  ViewSpnerChldNav(
      {@required this.isReady,
      this.unRelatedView = false,
      this.ms = 400,
      @required this.child});

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
    isReady = widget.unRelatedView ? false : widget.isReady;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.unRelatedView == true && isReady == false) {
      Future.delayed(Duration.zero, () {
        print("comes here");
        setState(() {
          isReady = true;
        });
      });
    }
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
