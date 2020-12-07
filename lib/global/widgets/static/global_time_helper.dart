import 'package:buddy/global/helper/time_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlobalTimeHelper extends StatefulWidget {
  final EdgeInsets margin;
  final Color color;
  final TextStyle textStyle;

  ///Timer in milliseconds
  final int timerInMs;

  GlobalTimeHelper(
      {@required this.margin,
      @required this.color,
      @required this.textStyle,
      @required this.timerInMs});

  @override
  _GlobalTimeHelperState createState() => _GlobalTimeHelperState();
}

class _GlobalTimeHelperState extends State<GlobalTimeHelper> {
  TimeHelper _timeHelper;
  @override
  void initState() {
    super.initState();

    _timeHelper = Get.find<TimeHelper>();
    _timeHelper.init(widget.timerInMs, context);
  }

  @override
  void dispose() {
    _timeHelper.reset(context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: widget.margin,
        child: GetBuilder<TimeHelper>(
          builder: (_) => Text(
              (_timeHelper.primaryTimer?.isActive == true
                  ? "${_timeHelper.min}\m"
                  : "${_timeHelper.second}\s"),
              style: widget.textStyle.copyWith(
                  fontWeight: FontWeight.w900,
                  color: widget.color,
                  letterSpacing: 0.2)),
        ));
  }
}
