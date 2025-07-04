import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:slectiv_studio_app/app/modules/onboarding_screen/controllers/onboarding_screen_controller.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';

class SlectivonBoardingNextButton extends StatelessWidget {
  const SlectivonBoardingNextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 24,
      bottom: kBottomNavigationBarHeight,
      child: GestureDetector(
        onTap: () => OnboardingScreenController.instance.nextPage(),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [SlectivColors.primaryBlue, SlectivColors.secondaryBlue],
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: SlectivColors.primaryBlue.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            FluentIcons.arrow_right_20_filled,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}
