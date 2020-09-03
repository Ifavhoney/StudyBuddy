import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class GenericBody extends StatefulWidget {
  final String title;
  final Color titleBackgroundColor;
  final bool implyLeading;
  final Widget body;
  final Widget chatPeople;

  GenericBody(
      {this.title,
      this.titleBackgroundColor,
      this.implyLeading = true,
      @required this.body,
      @required this.chatPeople});
  @override
  _GenericBodyState createState() => _GenericBodyState();
}

class _GenericBodyState extends State<GenericBody> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: widget.titleBackgroundColor == null
              ? Color(0XFF504DE5)
              : widget.titleBackgroundColor,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height / 1.1,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(50.h)),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              height: MediaQuery.of(context).size.height / 1.1,
              child: widget.body),
        ),

        //increase clickable area
        widget.implyLeading
            ? Positioned(
                top: 40.h,
                left: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(10.h, 40.h, 10.h, 40.h),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 55.w,
                          ),
                          onPressed: () => Navigator.pop(context),
                        )),
                  ),
                ))
            : Container(),
        Positioned.fill(top: 0, right: 40.w, child: widget.chatPeople),

        /*
 
        */
      ],
    );
  }
}
