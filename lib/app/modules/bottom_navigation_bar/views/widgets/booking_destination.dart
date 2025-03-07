import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';

import '../../controllers/bottom_navigation_bar_controller.dart';

class SlectivBookingDestination extends StatelessWidget {
  const SlectivBookingDestination({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BottomNavigationBarController());
    controller.onInit();
    return controller.isUser.value
        ? const NavigationDestination(
          icon: Icon(FluentIcons.camera_add_24_regular),
          label: SlectivTexts.bookingLabel,
          selectedIcon: Icon(
            FluentIcons.camera_add_24_filled,
            color: SlectivColors.submitButtonColor,
          ),
        )
        : const NavigationDestination(
          icon: Icon(FluentIcons.data_usage_24_regular),
          label: SlectivTexts.transactionLabel,
          selectedIcon: Icon(
            FluentIcons.data_usage_24_regular,
            color: SlectivColors.submitButtonColor,
          ),
        );
  }
}
