import 'package:auto_size_text/auto_size_text.dart';
import 'package:buddy/global/global.dart';
import 'package:buddy/layout/orrin/sharedWidgets/mascotImage.dart';
import 'package:buddy/layout/orrin/sharedWidgets/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        height: ScreenUtil.defaultSize.height,
        width: ScreenUtil.defaultSize.width,
        padding: EdgeInsets.fromLTRB(0, 0.1.sw, 0, 0.05.sw),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              AutoSizeText(
                "Hello Buddy!",
                style: Global.appTheme.segoeUi.headline2,
              ),
              MascotImage(size: 0.5.sh),
              SizedBox(height: SizeConfig.blockSizeVertical * 10)
            ],
          ),
        ),
      ),
    );
  }
}
