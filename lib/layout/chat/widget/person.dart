import 'package:buddy/global/widgets/static/global_box_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Person extends StatelessWidget {
  final child;
  final Color containerColor;

  Person({this.child, this.containerColor});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.030.sw, 0.000.sh, 0.030.sw, 0.000.sh),
      child: GlobalBoxContainer(
        boxShape: BoxShape.circle,
        containerColor: containerColor ?? Colors.grey.shade300,
        containerHeight: 0.1.sh,
        containerWidth: 0.1.sw,
        boxShadow: BoxShadow(
            color: Color(0xFF0029F5), blurRadius: 8, spreadRadius: -4),
        child: child ?? Icon(Icons.person),
      ),
    );
  }
}
