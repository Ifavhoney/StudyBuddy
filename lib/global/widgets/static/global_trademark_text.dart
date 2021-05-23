import 'package:buddy/global/global.dart';
import 'package:buddy/global/theme/theme.dart';
import 'package:flutter/material.dart';

class GlobalTrademarkText extends StatelessWidget {
  final Color color;

  const GlobalTrademarkText({Key key, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Text("Buddy",
            style: Global.appTheme.fonts.nexa.bodyText1
                .apply(color: color == null ? Color(0xFFB9D1FF) : color)),
      ),
    );
  }
}
