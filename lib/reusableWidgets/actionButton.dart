import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final Icon icon;
  /*If needed to pass data */
  final Function event;
  final Color color;

  const ActionButton({this.icon, this.color, this.event});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: icon, backgroundColor: Colors.white70, onPressed: event);
  }
}
