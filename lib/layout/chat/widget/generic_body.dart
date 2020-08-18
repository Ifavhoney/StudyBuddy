import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GenericBody extends StatelessWidget {
  final String title;
  final Color titleBackgroundColor;
  final bool onPop;
  const GenericBody({this.title, this.titleBackgroundColor, this.onPop});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: titleBackgroundColor == null
              ? Color(0XFF504DE5)
              : titleBackgroundColor,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height / 1.3,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50.h)),
                gradient: LinearGradient(
                    colors: [Color(0xFFF6F7FB), Color(0xfff6f7fb)])),
          ),
        ),

        //increase clickable area
        Positioned(
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
            )),
        Positioned(
            top: 75.h,
            left: MediaQuery.of(context).size.width / 3.7,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(80.h, 40.h, 10.h, 40.h),
                  child: Display(
                    color: Colors.white,
                    display: 1,
                    text: title,
                  )),
            )),
      ],
    );
  }
}

class Display extends StatelessWidget {
  final String text;
  final int display;
  final Color color;
  final bool isBold;
  final double incrementSize;

  const Display(
      {this.text,
      this.display,
      this.color,
      this.isBold,
      this.incrementSize = 0});
  @override
  Widget build(BuildContext context) {
    switch (display) {
      case 1:
        return Text(text,
            style: TextStyle(
                fontSize: 60.w,
                fontWeight: FontWeight.bold,
                color: color == null ? Colors.black : color));

        break;

      case 2:
        return Text(text,
            style: TextStyle(
              fontSize: 55.w + incrementSize,
              fontWeight: isBold == null ? FontWeight.w500 : FontWeight.bold,
              color: color == null ? Colors.black : color,
            ));
        break;

      case 3:
        return Text(text,
            style: TextStyle(
                fontSize: 40.w + incrementSize,
                fontWeight: isBold == null ? FontWeight.w500 : FontWeight.bold,
                color: color == null ? Colors.black : color));
        break;

      case 4:
        return Text(text,
            style: TextStyle(
                fontSize: 30.w + incrementSize,
                fontWeight: isBold == null ? FontWeight.w500 : FontWeight.bold,
                letterSpacing: 2.w,
                color: color == null ? Colors.black : color));
        break;

      default:
        return Text(text);
    }
  }
}
