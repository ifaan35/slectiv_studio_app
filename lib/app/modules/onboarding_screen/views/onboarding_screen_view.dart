import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slectiv_studio_app/app/modules/onboarding_screen/views/widgets/horizontal_scrollable_pages.dart';
import 'package:slectiv_studio_app/app/modules/onboarding_screen/views/widgets/onboarding_dot_navigation.dart';
import 'package:slectiv_studio_app/app/modules/onboarding_screen/views/widgets/onboarding_next_button.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import '../controllers/onboarding_screen_controller.dart';

class OnboardingScreenView extends GetView<OnboardingScreenController> {
  const OnboardingScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    final onBoardingcontroller = Get.put(OnboardingScreenController());
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              SlectivColors.lightBlueBackground,
              Color(0xFFE2E8F0),
              SlectivColors.lightBlueBackground,
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Background decorative elements
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        SlectivColors.primaryBlue.withOpacity(0.1),
                        SlectivColors.secondaryBlue.withOpacity(0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -100,
                left: -100,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        SlectivColors.secondaryBlue.withOpacity(0.08),
                        SlectivColors.primaryBlue.withOpacity(0.03),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Main content
              Column(
                children: [
                  // Header with logo
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Scrollable pages
                  Expanded(
                    child: SlectivScrollablePages(
                      onBoardingcontroller: onBoardingcontroller,
                    ),
                  ),
                ],
              ),

              // Dot Navigation
              const SlectivonBoardingDotNavigation(),

              // Next Button
              const SlectivonBoardingNextButton(),
            ],
          ),
        ),
      ),
    );
  }
}
