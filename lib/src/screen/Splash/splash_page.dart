import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:english_madhyam/src/screen/Splash/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';
import '../../utils/colors/colors.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({Key? key}) : super(key: key);
  static const routeName = "/";

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: SplashController(),
        builder: (controller) {
          return Scaffold(
              backgroundColor: AdaptiveTheme.of(context).mode.isDark
                  ? Colors.transparent
                  : whiteColor,
              body: Center(
                  child: Image.asset(
                'assets/animations/englishmahdya,.gif',
                fit: BoxFit.cover,
              )));
        });
  }
}
