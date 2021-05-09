import 'package:buddy/V2/RTC/controller/cam_controller.dart';
import 'package:buddy/V2/RTC/model/cam_model.dart';
import 'package:buddy/global/config/config.dart';
import 'package:buddy/global/theme/theme.dart';
import 'package:buddy/global/widgets/animation/global_flashing_circle.dart';
import 'package:buddy/global/widgets/static/global_trademark_text.dart';
import 'package:buddy/layout/home/controller/search_controller2.dart';
//import 'package:buddy/layout/home/controller/search_controller.dart';
import 'package:buddy/layout/home/view/waiting_view.dart';
import 'package:get/get.dart';
import 'package:route_observer_mixin/route_observer_mixin.dart';

import 'package:flutter/material.dart';

///@LastModifiedBy: Jason NGuessan
class SearchingView extends StatefulWidget {
  static const routeName = '/searching_view';

  @override
  _SearchingViewState createState() => _SearchingViewState();
}

class _SearchingViewState extends State<SearchingView>
    with WidgetsBindingObserver, RouteAware, RouteObserverMixin {
  SearchController _searchController = new SearchController();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _asyncInitState();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didPop() {
    super.didPop();
    _searchController.removeFromAwaiting(Config.user.email);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.inactive:
        _toWaitingView();
        break;
      case AppLifecycleState.paused:
        _toWaitingView();
        break;

      default:
        print("i am back");
    }
  }

  _asyncInitState() async {
    //If it gets to this point, then the user is not in the awaiting list
    await _searchController.initState(context);
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
        // onTap: () => CamController.toWebcam(
        //     CamModel(channelName: "1", endTime: "09:15"), context),
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
            child: IconButton(
                onPressed: _toWaitingView,
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: AppTheme.searchingViewIcons["arrowBack"],
                ))),
      ));
  void _toWaitingView() {
    _searchController.removeFromAwaiting(Config.user.email).whenComplete(() {
      Get.back();
    });
  }
}
