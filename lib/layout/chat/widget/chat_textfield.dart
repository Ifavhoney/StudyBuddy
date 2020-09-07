import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatTextField extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController editingController;
  final Function onSubmitted;
  final Function onTap;
  const ChatTextField(
      {@required this.focusNode,
      @required this.editingController,
      @required this.onSubmitted,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Container(
      padding: EdgeInsets.all(30.w),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: editingController,
              focusNode: focusNode,
              minLines: 1,
              maxLines: 5,
              maxLength: 150,
              textInputAction: TextInputAction.go,
              onSubmitted: onSubmitted,
              onTap: onTap,
              decoration: InputDecoration(
                  fillColor: Color(0xFFd3d3d3).withOpacity(0.2),
                  filled: true,
                  contentPadding: EdgeInsets.fromLTRB(50.w, 25.h, 50.w, 25.h),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(100.0),
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
