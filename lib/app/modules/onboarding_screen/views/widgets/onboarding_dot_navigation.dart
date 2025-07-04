import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slectiv_studio_app/app/modules/onboarding_screen/controllers/onboarding_screen_controller.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SlectivonBoardingDotNavigation extends StatelessWidget {
  const SlectivonBoardingDotNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final onBoardingcontroller = Get.put(OnboardingScreenController());
    return Positioned(
      bottom: kBottomNavigationBarHeight + 25,
      left: 24,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: SlectivColors.primaryBlue.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SmoothPageIndicator(
          onDotClicked: onBoardingcontroller.dotNavigationClick,
          controller: onBoardingcontroller.pageController,
          count: 3,
          effect: ExpandingDotsEffect(
            activeDotColor: SlectivColors.primaryBlue,
            dotColor: SlectivColors.textGray.withOpacity(0.3),
            dotHeight: 8,
            dotWidth: 8,
            expansionFactor: 3,
            spacing: 6,
          ),
        ),
      ),
    );
  }
}
