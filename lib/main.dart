import 'package:buddy/example/mycustomform.dart';
import 'package:buddy/example/user_dashboard.dart';
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
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
                            channel: args.channel,
                            fromView: args.fromView,
                            timerInMs: args.timerInMs,
                            users: args.users,
                            fbKey: args.fbKey,
                          ));
                }
            }
            return null; // to suppress a warning
          }),
    );
  }
}
