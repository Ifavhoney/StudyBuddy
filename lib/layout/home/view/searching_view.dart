import 'package:buddy/V2/RTC/controller/cam_controller.dart';
import 'package:buddy/V2/RTC/model/cam_model.dart';
import 'package:buddy/global/config/config.dart';
import 'package:buddy/global/theme/theme.dart';
import 'package:buddy/global/widgets/animation/global_flashing_circle.dart';
import 'package:buddy/global/widgets/static/global_trademark_text.dart';
import 'package:buddy/layout/home/controller/search_controller.dart';
import 'package:buddy/layout/home/model/awaiting_model.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

///@LastModifiedBy: Jason NGuessan
class SearchingView extends StatefulWidget {
  static const routeName = '/searching_view';
  @override
  _SearchingViewState createState() => _SearchingViewState();
}

class _SearchingViewState extends State<SearchingView> {
  SearchController _searchController = new SearchController();

  @override
  void initState() {
    _asyncInitState();
    super.initState();
  }

  _asyncInitState() async {
    await _searchController.initState(context);
    await _searchController.addUserToAwaiting(
      AwaitingModel(hasMatched: false, timer: 15, user: Config.user.email),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        GlobalFlashingCircle(),
        _mascot(),
        GlobalTrademarkText(),
        _backArrow(),
        /*
        GlobalFallingCircles(
          durationInSeconds: 10,
          heightOfDevice: MediaQuery.of(context).size.height,
          widthOfDevice: MediaQuery.of(context).size.width,
        )
        */
      ]),
      backgroundColor: Colors.white,
    );
  }

  Widget _mascot() => GestureDetector(
        onTap: () => CamController.toWebcam(
            CamModel(channelName: "1", endTime: "09:15"), context),
        child: Center(
          child: Image.asset(
            "assets/images/mascot.png",
            fit: BoxFit.scaleDown,
            height: MediaQuery.of(context).size.height / 14,
          ),
        ),
      );
  Widget _backArrow() => Positioned.fill(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Align(
            alignment: Alignment.bottomLeft,
            child: Icon(
              Icons.arrow_back_ios,
              color: AppTheme.searchingViewIcons["arrowBack"],
            )),
      ));
}
