import 'package:auto_size_text/auto_size_text.dart';
import 'package:buddy/global/global.dart';
import 'package:buddy/global/helper/html_helper.dart';
import 'package:buddy/global/widgets/animation/spinner/global_spinner.dart';
import 'package:buddy/global/widgets/static/global_box_container.dart';
import 'package:buddy/layout/auth/controller/auth_controller.dart';
import 'package:buddy/layout/home/view/waiting_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

//FOR POPUP

class CopyWritingPopup extends StatefulWidget {
  CopyWritingPopup({Key key}) : super(key: key);

  @override
  _CopyWritingPopupState createState() => _CopyWritingPopupState();
}

class _CopyWritingPopupState extends State<CopyWritingPopup> {
  bool isReady = false;
  String parsedConditions;
  String parsedPolicy;
  @override
  void initState() {
    super.initState();
    asyncInitState();
  }

  void asyncInitState() async {
    parsedConditions =
        await HtmlHelper.getFileData(Global.appConfig.termsAndConditions);
    parsedPolicy = await HtmlHelper.getFileData(Global.appConfig.privacyPolicy);
    setState(() {
      isReady = true;
    });
  }

  Future<String> getFileData(String url) async {
    var response = await http.Client().get(url);
    String res = response.body;

    String r = res.replaceAll("â", 'a');
    print(res.replaceAll("â", 'a'));
    return r;
  }

  @override
  Widget build(BuildContext context) {
    return !isReady
        ? GlobalSpinner(
            child: Container(),
            color: Colors.white,
          )
        : AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            actionsPadding: EdgeInsets.zero,
            buttonPadding: EdgeInsets.zero,
            backgroundColor: Colors.grey,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0.sp))),
            content: Builder(
              builder: (context) {
                // Get available height and width of the build area of this widget. Make a choice depending on the size.

                return GlobalBoxContainer(
                    boxShape: BoxShape.rectangle,
                    containerColor: Colors.white,
                    containerHeight: 0.8.sh,
                    containerWidth: 0.9.sw,
                    padding: EdgeInsets.symmetric(
                        horizontal: 0.03.sw, vertical: 0.03.sh),
                    borderRadius: BorderRadius.circular(10.sp),
                    boxShadow: BoxShadow(
                        color: Colors.grey, blurRadius: 2, spreadRadius: -2),
                    child: ListView(
                      children: [
                        HtmlHelper(parsedConditions),
                        SizedBox(height: 0.10.h),
                        HtmlHelper(parsedPolicy)
                      ],
                    ));
              },
            ),
          );
  }
}
