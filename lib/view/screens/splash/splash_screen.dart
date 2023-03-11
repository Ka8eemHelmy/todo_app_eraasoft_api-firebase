import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:todo_shared/view/screens/auth/login_screen.dart';
import 'package:todo_shared/view/screens/home/news_screen.dart';
import 'package:todo_shared/view_model/servises/local/shared_keys.dart';
import 'package:todo_shared/view_model/servises/local/shared_preference.dart';

import '../Task_screen/tasks_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'assets/logo.png',
      nextScreen: (SharedPreference.get(SharedKeys.isLogin) ?? false) ? NewsScreen() : LoginScreen(),
      splashTransition: SplashTransition.rotationTransition,
      // pageTransitionType: PageTransitionType.scale,
    );
  }
}
