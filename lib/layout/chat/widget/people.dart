import 'package:buddy/global/widgets/static/global_box_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class People extends StatelessWidget {
  final child;
  final Color containerColor;

  People({this.child, this.containerColor});
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(10.h, 40.h, 40.w, 40.h),
      child: GlobalBoxContainer(
        boxShape: BoxShape.circle,
        containerColor: containerColor ?? Colors.grey,
        containerHeight: 80.h,
        containerWidth: 80.w,
        boxShadow: BoxShadow(
            color: Color(0xFF0029F5), blurRadius: 8, spreadRadius: -2),
        child: child ?? Icon(Icons.person),
      ),
    );
  }
}
