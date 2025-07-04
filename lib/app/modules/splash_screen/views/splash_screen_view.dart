import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slectiv_studio_app/app/modules/splash_screen/views/widgets/splash_display.dart';
import 'package:slectiv_studio_app/app/routes/app_pages.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashScreenController>(
      initState: (_) {
        Timer(const Duration(seconds: 300), () {
          Get.offAllNamed(Routes.ONBOARDING_SCREEN);
        });
      },
      builder: (context) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  SlectivColors.lightBlueBackground,
                  Color(0xFFE2E8F0),
                  SlectivColors.lightBlueBackground,
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: const SafeArea(child: SlectivSplashDisplay()),
          ),
        );
      },
    );
  }
}
