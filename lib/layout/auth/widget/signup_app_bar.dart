import 'package:buddy/global/global.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignUpAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color iconColor;
  final List<Widget> actions;

  const SignUpAppBar({Key key, this.iconColor, this.actions}) : super(key: key);
  @override
  Widget build(BuildContext context) => _widget();

  @override
  Size get preferredSize => Size.fromHeight(0.05.sh / 1); // default is 56.0

  Widget _widget() => _appBar();

  _appBar() => PreferredSize(
        preferredSize: Size.fromHeight(1.sw),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          toolbarHeight: 0.05.sh,
          leadingWidth: 0.2.sw,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 0.045.sh),
            color:
                iconColor ?? Global.appTheme.iconColors.signupView["arrowBack"],
            onPressed: () => Get.back(),
          ),
          actions: actions ?? [],
        ),
      );
}
