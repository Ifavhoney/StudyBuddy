import 'package:buddy/global/config/device_config.dart';
import 'package:buddy/global/config/user_config.dart';
import 'package:buddy/global/global.dart';
import 'package:buddy/global/helper/time_helper.dart';
import 'package:buddy/global/theme/theme.dart';
import 'package:buddy/layout/auth/controller/auth_controller.dart';
import 'package:buddy/layout/auth/controller/questionaire_bloc.dart';
import 'package:buddy/layout/auth/view/preferences_view.dart';
import 'package:buddy/layout/auth/view/signup_view.dart';
import 'package:buddy/layout/chat/controller/chat_controller.dart';
import 'package:buddy/layout/chat/screens/chat_view.dart';
import 'package:buddy/layout/home/view/searching_view.dart';
import 'package:buddy/layout/home/view/waiting_view.dart';
import 'package:buddy/layout/nav_page/view_spner_chld_nav.dart';
import 'package:buddy/layout/nav_page/wait_searc_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:route_observer_mixin/route_observer_mixin.dart';

import 'layout/auth/view/welcome_view.dart';

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

    Get.put(AuthController());
    Get.put(ChatController());

    Get.put(UserConfig());
    Get.put(DeviceConfig());
    Get.put(QuestionaireBloc());
    Get.put(PrevNav());
    Get.put(WaitSearNavBloc());
    Global.userConfig.init();
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
              home: GetBuilder<UserConfig>(
                builder: (bloc) {
                  return ViewSpnerChldNav(
                    isReady: bloc.isReady,
                    child:
                        bloc.user.email == null ? WelcomeView() : WaitSearNav(),
                    //Preferencesiews
                    //  bloc.user.email == null ? WelcomeView() : WaitingView(),
                  );
                },
              ),
              title: Global.appConfig.appName,
              transitionDuration: Duration.zero,
              getPages: [
                // GetPage(name: LoginView.routeName, page: () => LoginView()),
                GetPage(name: WaitingView.routeName, page: () => WaitingView()),
                GetPage(name: SignupView.routeName, page: () => SignupView()),

                GetPage(
                    name: SearchingView.routeName, page: () => SearchingView()),
                GetPage(name: ChatView.routeName, page: () => ChatView()),
              ],
            ));
  }
}
