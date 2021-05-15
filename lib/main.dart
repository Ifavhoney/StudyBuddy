import 'package:buddy/global/config/config.dart';
import 'package:buddy/global/config/device_config.dart';
import 'package:buddy/global/helper/time_helper.dart';
import 'package:buddy/global/theme/theme.dart';
import 'package:buddy/layout/auth/view/login_view.dart';
import 'package:buddy/layout/chat/screens/chat_view.dart';
import 'package:buddy/layout/home/view/searching_view.dart';
import 'package:buddy/layout/home/view/waiting_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:route_observer_mixin/route_observer_mixin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  Get.put(TimeHelper());

  await Firebase.initializeApp();
  await Config.init();

  runApp(RouteObserverProvider(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.mainTheme,
      onReady: () {
        DeviceConfig().init();
      },
      home: Config.user == null ? LoginView() : WaitingView(),
      initialRoute: WaitingView.routeName,
      getPages: [
        GetPage(name: LoginView.routeName, page: () => LoginView()),
        GetPage(name: WaitingView.routeName, page: () => WaitingView()),
        GetPage(name: SearchingView.routeName, page: () => SearchingView()),
        GetPage(name: ChatView.routeName, page: () => ChatView()),
      ],
    );
  }
}
