import 'package:buddy/global/helper/time_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlobalTimeHelper extends StatefulWidget {
  final EdgeInsets margin;
  final Color color;
  final TextStyle textStyle;

  GlobalTimeHelper({
    @required this.margin,
    @required this.color,
    @required this.textStyle,
  });

  @override
  _GlobalTimeHelperState createState() => _GlobalTimeHelperState();
}

class _GlobalTimeHelperState extends State<GlobalTimeHelper> {
  TimeHelper _timeHelper = Get.find<TimeHelper>();

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: widget.margin,
        child: GetBuilder<TimeHelper>(
          builder: (_) => Text(
              (_.primaryTimer?.isActive == true
                  ? "${_timeHelper.min}\m"
                  : "${_timeHelper.second}\s"),
              style: widget.textStyle.copyWith(
                  fontWeight: FontWeight.w900,
                  color: widget.color,
                  letterSpacing: 0.2)),
        ));
  }
}
