import 'dart:async';

import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:buddy/V2/other/sizeConfig.dart';
import 'package:buddy/global/global.dart';
import 'package:buddy/global/widgets/static/global_app_bar.dart';
import 'package:buddy/global/widgets/static/global_box_container.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///PreferencesView -> 01 -> 02 -> 03...
///Shared Axis


//Get contrroller to change the index?


class PreferencesView extends StatefulWidget {
  const PreferencesView();

  @override
  _PreferencesViewState createState() {
    return _PreferencesViewState();
  }
}

class _PreferencesViewState extends State<PreferencesView>
    with TickerProviderStateMixin {
  SharedAxisTransitionType _transitionType =
      SharedAxisTransitionType.horizontal;

  Map<int, dynamic> questionaire = {
    1: {
      "title": "My Mood",
      "question": "Right now I feel ...",
      "options": ['Bored', 'Meh', 'Super happy', 'N/A']
    },
    0: {
      "title": "Intentions",
      "question": "I am mostly looking to ...",
      "options": [
        'Make new Friends',
        'Connect with Current Friends',
        'Talk to random people',
        "N/A"
      ]
    },
    2: {
      "title": "Political Interests",
      "question": "My party of choice ...",
      "options": ['Democrat', 'Republican', 'Libertarian', "N/A"]
    },
    3: {
      "title": "Hobbies",
      "question": "On a friday night, I would be ... ",
      "options": ['Alone', 'Gaming', 'Entertained', "N/A"]
    },
  };
  AnimationController controller;
  Animation<double> animation;
  int _selectedIndex = null;
  // List<String> list = new List();

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  int pageIndex = 0;
  @override
  void initState() {
    super.initState();
    //getUserInfo();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: GlobalAppBar(implyLeading: false, toolbarHeight: 0.03.sh),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: PageTransitionSwitcher(
                  duration: const Duration(milliseconds: 300),
                  reverse: false,
                  transitionBuilder: (
                    Widget child,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                  ) {
                    return SharedAxisTransition(
                      child: child,
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      transitionType: _transitionType,
                    );
                  },
                  child: _questionare(pageIndex)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _questionare(int index) {
    return Container(
      padding: EdgeInsets.only(bottom: 0.05.sh),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: ScreenUtil.defaultSize.width,
            padding: EdgeInsets.only(left: 0.03.sw),
            child: AutoSizeText(
              questionaire[index]["title"],
              maxLines: 1,
              style: Global.appTheme.fonts.segoeUi.headline3,
            ),
          ),
          SizedBox(height: 0.03.sh),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _progressSides(
                child: FadeTransition(
                    opacity: animation,
                    child: _progressSides(color: Colors.blue[200])),
              ),
              _progressMiddle(),
              _progressMiddle(),
              _progressSides(end: true)
            ],
          ),
          SizedBox(height: 0.09.sh),
          Padding(
              padding: EdgeInsets.only(left: 0.04.sw),
              child: Column(
                children: [
                  Text(questionaire[index]["question"],
                      style: Global.appTheme.fonts.nexa.headline6),
                ],
              )),
          SizedBox(height: 0.02.sh),
          new Expanded(
            child: ListView.builder(
              itemCount: questionaire[index]["options"].length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext _, int i) {
                return userCard(questionaire[index]["options"][i], i, context);
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  side: BorderSide(color: Colors.grey)),
              child: GlobalBoxContainer(
                  containerWidth: 0.65.sw,
                  borderRadius: BorderRadius.circular(40.sp),
                  boxShadow: BoxShadow(color: Colors.transparent),
                  containerColor: Color(0xFF8CB2FC),
                  child: Center(
                    child: AutoSizeText("Next",
                        style: Global.appTheme.fonts.segoeUi.headline5),
                  ),
                  padding: EdgeInsets.all(15.sp)),
              onPressed: () {
                Future.delayed(Duration(seconds: 1), () {
                  controller.reset();
                  controller.forward();
                  setState(() => pageIndex += 1);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressMiddle({Color color = Colors.white, Widget child}) {
    return Container(
      width: SizeConfig.blockSizeHorizontal * 20,
      height: SizeConfig.blockSizeVertical * 1,
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.grey, width: SizeConfig.blockSizeHorizontal * .25),
        color: color,
      ),
      child: child ?? Container(),
    );
  }

  Widget _progressSides(
      {Color color = Colors.white, bool end = false, Widget child}) {
    return Container(
      width: SizeConfig.blockSizeHorizontal * 20,
      height: SizeConfig.blockSizeVertical * 1,
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.grey, width: SizeConfig.blockSizeHorizontal * .25),
        borderRadius: end
            ? BorderRadius.only(
                topRight: Radius.circular(SizeConfig.blockSizeHorizontal * 2),
                bottomRight:
                    Radius.circular(SizeConfig.blockSizeHorizontal * 2))
            : new BorderRadius.only(
                topLeft: Radius.circular(SizeConfig.blockSizeHorizontal * 2),
                bottomLeft:
                    Radius.circular(SizeConfig.blockSizeHorizontal * 2)),
        color: color,
      ),
      child: child ?? Container(),
    );
  }

  Color _selectedIndexColor(int index) {
    return _selectedIndex != null && _selectedIndex == index
        ? Color(0xFFB9D1FF)
        : Color(0xFFF8FAFF);
  }

  Widget userCard(var obj, int index, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.008.sh, horizontal: 0.05.sw),
      child: InkWell(
        child: Card(
          color: _selectedIndexColor(index),
          shadowColor: _selectedIndexColor(index),
          elevation: 1.5,
          child: GlobalBoxContainer(
            containerHeight: 0.08.sh,
            containerColor: _selectedIndexColor(index),
            borderRadius: BorderRadius.circular(10.sp),
            boxShadow: BoxShadow(
                color: Color(0xFFB9D1FF),
                blurRadius: 0.01.sh,
                spreadRadius: -3),
            child: Center(
                child: Row(
              children: [
                SizedBox(width: 0.05.sw),
                Expanded(
                  child: new AutoSizeText(obj,
                      maxLines: 2,
                      style: Global.appTheme.fonts.segoeUi.headline6.copyWith(
                          color: Colors.black, fontWeight: FontWeight.w600)),
                ),
              ],
            )),
          ),
        ),
        onTap: () {
          setState(() => _onSelected(index));
          print(obj);
          // getAnswer01(obj);
        },
      ),
    );
  }
}
