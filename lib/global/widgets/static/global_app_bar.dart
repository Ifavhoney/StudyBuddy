import 'package:buddy/global/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color iconColor;
  final List<Widget> actions;
  final bool implyLeading;
  final double toolbarHeight;
  const GlobalAppBar(
      {Key key,
      this.iconColor,
      this.implyLeading = true,
      this.toolbarHeight,
      this.actions})
      : super(key: key);
  @override
  Widget build(BuildContext context) => _widget();

  @override
  Size get preferredSize =>
      Size.fromHeight(toolbarHeight == null ? (0.05.sh) : toolbarHeight);

  Widget _widget() => _appBar();

  _appBar() => PreferredSize(
        preferredSize: Size.fromHeight(1.sw),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          toolbarHeight: toolbarHeight == null ? 0.05.sh : toolbarHeight,
          leadingWidth: 0.2.sw,
          leading: !implyLeading
              ? Container()
              : IconButton(
                  icon: Icon(Icons.arrow_back_ios, size: 0.045.sh),
                  color: iconColor ??
                      Global.appTheme.iconColors.signupView["arrowBack"],
                  onPressed: () => Get.back(),
                ),
          actions: actions ?? [],
        ),
      );
}
