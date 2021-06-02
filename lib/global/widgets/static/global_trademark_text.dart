import 'package:buddy/global/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlobalTrademarkText extends StatelessWidget {
  final Color color;
  final bool isStackWidget;

  const GlobalTrademarkText({Key key, this.color, this.isStackWidget = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: isStackWidget ? null : 0.05.sh,
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.05.sw, vertical: 0.01.sh),
          child: Text("Buddy",
              style: Global.appTheme.fonts.nexa.bodyText1
                  .apply(color: color == null ? Color(0xFFB9D1FF) : color)),
        ),
      ),
    );
  }
}
