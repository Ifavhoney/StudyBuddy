import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GenericBody extends StatefulWidget {
  final Color backgroundColor;
  final bool implyLeading;
  final Widget body;
  final bool isKeyboardShowing;
  final Widget chatPeople;

  GenericBody(
      {this.backgroundColor,
      this.implyLeading = true,
      @required this.body,
      @required this.chatPeople,
      @required this.isKeyboardShowing});
  @override
  _GenericBodyState createState() => _GenericBodyState();
}

class _GenericBodyState extends State<GenericBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().screenHeight,
      child: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 1.1,
            width: MediaQuery.of(context).size.width,
            color: _backgroundColor(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / _height(),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(50.h)),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                height: MediaQuery.of(context).size.height / _height(),
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
          Positioned.fill(
              top: 0,
              right: 40.w,
              child:
                  widget.isKeyboardShowing ? Container() : widget.chatPeople),

          /*
 
          */
        ],
      ),
    );
  }

  double _height() {
    if (widget.isKeyboardShowing)
      return 1;
    else
      return 1.1;
  }

  Color _backgroundColor() {
    if (widget.isKeyboardShowing)
      return Colors.white;
    else
      return widget.backgroundColor ?? Color(0XFF504DE5);
  }
}
