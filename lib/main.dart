import 'package:buddy/global/config/app_config.dart';
import 'package:buddy/global/config/device_config.dart';
import 'package:buddy/global/config/user_config.dart';
import 'package:buddy/global/global.dart';
import 'package:buddy/global/helper/time_helper.dart';
import 'package:buddy/global/theme/theme.dart';
import 'package:buddy/layout/auth/controller/auth_controller.dart';
import 'package:buddy/layout/chat/screens/chat_view.dart';
import 'package:buddy/layout/home/view/searching_view.dart';
import 'package:buddy/layout/home/view/waiting_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:route_observer_mixin/route_observer_mixin.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'V2/other/navigation.dart';
import 'example/animation/spin_kit_animation.dart';
import 'global/widgets/animation/spinner/global_spinner.dart';
import 'layout/auth/view/welcome_view.dart';
import 'layout/nav_page/spner_chld_nav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Firebase.initializeApp();

  runApp(RouteObserverProvider(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(TimeHelper());
    Get.put(UserConfig());
    Get.put(DeviceConfig());

    Global.userConfig.init();
    AuthController().signOut();

    return ScreenUtilInit(
        builder: () => GetMaterialApp(
              theme: AppTheme().mainTheme,
              color: AppTheme().mainTheme.backgroundColor,
              onReady: () => Global.deviceConfig.init(),
              builder: (context, widget) {
                return MediaQuery(
                    //Setting font does not change with system font size
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: widget);
              },
              home: BottomNavigatorPage(),

              /*
               GetBuilder<UserConfig>(
                builder: (bloc) {
                  return SpnerChldNav(
                    isReady: bloc.isReady,
                    child:  bloc.user == null ? WelcomeView() : WaitingView(),
                  );
                },
              ),
              */
              title: Global.appConfig.appName,
              getPages: [
                // GetPage(name: LoginView.routeName, page: () => LoginView()),
                GetPage(name: WaitingView.routeName, page: () => WaitingView()),
                GetPage(
                    name: SearchingView.routeName, page: () => SearchingView()),
                GetPage(name: ChatView.routeName, page: () => ChatView()),
              ],
            ));
  }
}
