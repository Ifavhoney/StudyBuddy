import 'package:buddy/global/config/config.dart';
import 'package:buddy/global/helper/time_helper.dart';
import 'package:buddy/global/theme/theme.dart';
import 'package:buddy/layout/auth/view/login_view.dart';
import 'package:buddy/layout/chat/args/chat_args.dart';
import 'package:buddy/layout/chat/screens/chat_view.dart';
import 'package:buddy/layout/home/view/searching_view.dart';
import 'package:buddy/layout/home/view/waiting_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Config.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(TimeHelper());

    return GetMaterialApp(
      home: MaterialApp(
          theme: AppTheme.mainTheme,
          home: Config.user == null ? LoginView() : LoginView(),
          routes: {
            LoginView.routeName: (ctx) => LoginView(),
            WaitingView.routeName: (ctx) => WaitingView(),
            SearchingView.routeName: (ctx) => SearchingView(),
          },
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case ChatView.routeName:
                {
                  final ChatArgs args = settings.arguments;
                  return MaterialPageRoute(
                      builder: (context) => ChatView(
                          channel: args.channel, fromView: args.fromView));
                }
            }
            return null; // to suppress a warning
          }),
    );
  }

  initGetX() {
    Get.put(TimeHelper());
  }
}
