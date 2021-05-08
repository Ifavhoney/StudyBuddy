import 'package:buddy/global/config/config.dart';
import 'package:buddy/global/helper/time_helper.dart';
import 'package:buddy/global/theme/theme.dart';
import 'package:buddy/layout/auth/view/login_view.dart';
import 'package:buddy/layout/chat/args/chat_args.dart';
import 'package:buddy/layout/chat/screens/chat_view.dart';
import 'package:buddy/layout/chat_freellance/chat_screen.dart';
import 'package:buddy/layout/home/view/searching_view.dart';
import 'package:buddy/layout/home/view/waiting_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(TimeHelper());

  await Firebase.initializeApp();
  await Config.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("comes here");
    return GetMaterialApp(
      home: MaterialApp(
          theme: AppTheme.mainTheme,
          home: Config.user == null ? LoginView() : ChatScreen(),
          routes: {
            ChatScreen.routeName: (ctx) => ChatScreen(),
            LoginView.routeName: (ctx) => LoginView(),
            WaitingView.routeName: (ctx) => WaitingView(),
            SearchingView.routeName: (ctx) => SearchingView(),
          },
          initialRoute: ChatScreen.routeName,
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
