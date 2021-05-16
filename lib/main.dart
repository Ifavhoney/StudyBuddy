import 'package:buddy/global/config/app_config.dart';
import 'package:buddy/global/config/device_config.dart';
import 'package:buddy/global/config/user_config.dart';
import 'package:buddy/global/global.dart';
import 'package:buddy/global/helper/time_helper.dart';
import 'package:buddy/global/theme/theme.dart';
import 'package:buddy/layout/auth/view/login_view.dart';
import 'package:buddy/layout/chat/screens/chat_view.dart';
import 'package:buddy/layout/home/view/searching_view.dart';
import 'package:buddy/layout/home/view/waiting_view.dart';
import 'package:buddy/layout/home/view/welcome_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:route_observer_mixin/route_observer_mixin.dart';

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
    return GetMaterialApp(
      theme: AppTheme().mainTheme,
      onReady: () => Global.deviceConfig.init(),
      home: GetBuilder<UserConfig>(
        builder: (bloc) {
          return WelcomeView();

          /*
           !bloc.isReady
              ? Container()
              : bloc.user == null
                  ? LoginView()
                  : WaitingView();
                  */
        },
      ),
      title: AppConfig.appName,
      getPages: [
        GetPage(name: LoginView.routeName, page: () => LoginView()),
        GetPage(name: WaitingView.routeName, page: () => WaitingView()),
        GetPage(name: SearchingView.routeName, page: () => SearchingView()),
        GetPage(name: ChatView.routeName, page: () => ChatView()),
      ],
    );
  }
}
