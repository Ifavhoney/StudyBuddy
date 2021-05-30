import 'dart:async';

import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:buddy/V2/other/sizeConfig.dart';
import 'package:buddy/global/global.dart';
import 'package:buddy/global/widgets/static/global_app_bar.dart';
import 'package:buddy/global/widgets/static/global_box_container.dart';
import 'package:buddy/layout/auth/widget/questionaire.dart';
import 'package:buddy/layout/auth/widget/questionaire01.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

///PreferencesView -> 01 -> 02 -> 03...
///Shared Axis

class PrevNav extends GetxController {
  RxInt _page = 0.obs;
  int get page => _page.value;
  int nextPage() => _page.value += 1;
}

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

  @override
  Widget build(BuildContext context) {
    return GetX<PrevNav>(builder: (_) {
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
                    child: Questionaire(_.page)),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _CoursePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        const Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
        Text(
          'Streamling your courses',
          style: Theme.of(context).textTheme.headline5,
          textAlign: TextAlign.center,
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            'Bundled categories appear as groups in your feed. '
            'You can always change this later.',
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const _CourseSwitch(course: 'Arts & Crafts'),
        const _CourseSwitch(course: 'Business'),
        const _CourseSwitch(course: 'Illustration'),
        const _CourseSwitch(course: 'Design'),
        const _CourseSwitch(course: 'Culinary'),
      ],
    );
  }
}

class _CourseSwitch extends StatefulWidget {
  const _CourseSwitch({
    this.course,
  });

  final String course;

  @override
  _CourseSwitchState createState() => _CourseSwitchState();
}

class _CourseSwitchState extends State<_CourseSwitch> {
  bool _value = true;

  @override
  Widget build(BuildContext context) {
    final String subtitle = _value ? 'Bundled' : 'Shown Individually';
    return SwitchListTile(
      title: Text(widget.course),
      subtitle: Text(subtitle),
      value: _value,
      onChanged: (bool newValue) {
        setState(() {
          _value = newValue;
        });
      },
    );
  }
}
