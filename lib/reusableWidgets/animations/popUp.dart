import 'package:flutter/material.dart';

class PopUp extends StatefulWidget {
  final Widget widget;
  PopUp({this.widget});

  @override
  _PopUpState createState() => _PopUpState();
}

class _PopUpState extends State<PopUp> with SingleTickerProviderStateMixin {
  //neccessary to set the duration of our animation
  AnimationController controller;
  //0-1 indicates wether running or completed
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    //CurvedAnimation makes Animations smoother (think curve graph as oppose to linear)
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);
    //Calls the animation whenever an animation changes - Set state rebuilds
    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ScaleTransition(
        scale: scaleAnimation,
        child: this.widget,
      ),
    );
  }
}
