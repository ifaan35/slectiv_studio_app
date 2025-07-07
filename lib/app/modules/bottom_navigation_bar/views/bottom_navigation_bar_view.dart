import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slectiv_studio_app/app/modules/bottom_navigation_bar/controllers/bottom_navigation_bar_controller.dart';
import 'package:slectiv_studio_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';

class BottomNavigationBarView extends GetView<BottomNavigationBarController> {
  const BottomNavigationBarView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BottomNavigationBarController());

    // Pastikan ProfileController sudah terdaftar
    if (!Get.isRegistered<ProfileController>()) {
      Get.lazyPut(() => ProfileController());
    }
    final profileController = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: SlectivColors.lightBlueBackground,

      // Modern Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: SlectivColors.whiteColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPillNavItem(
                  icon: FluentIcons.home_24_regular,
                  selectedIcon: FluentIcons.home_24_filled,
                  label: SlectivTexts.homeLabel,
                  isSelected: controller.selectedIndex.value == 0,
                  onTap: () => controller.selectedIndex.value = 0,
                ),
                Obx(
                  () =>
                      controller.isUser.value
                          ? _buildPillNavItem(
                            icon: FluentIcons.camera_add_24_regular,
                            selectedIcon: FluentIcons.camera_add_24_filled,
                            label: SlectivTexts.bookingLabel,
                            isSelected: controller.selectedIndex.value == 1,
                            onTap: () => controller.selectedIndex.value = 1,
                          )
                          : _buildPillNavItem(
                            icon: FluentIcons.data_usage_24_regular,
                            selectedIcon: FluentIcons.data_usage_24_filled,
                            label: SlectivTexts.transactionLabel,
                            isSelected: controller.selectedIndex.value == 1,
                            onTap: () => controller.selectedIndex.value = 1,
                          ),
                ),
                _buildPillNavItem(
                  icon: FluentIcons.document_bullet_list_24_regular,
                  selectedIcon: FluentIcons.document_bullet_list_24_filled,
                  label: SlectivTexts.galleyLabel,
                  isSelected: controller.selectedIndex.value == 2,
                  onTap: () => controller.selectedIndex.value = 2,
                ),
                _buildProfilePillNavItem(
                  profileController,
                  label: SlectivTexts.profileLabel,
                  isSelected: controller.selectedIndex.value == 3,
                  onTap: () => controller.selectedIndex.value = 3,
                ),
              ],
            ),
          ),
        ),
      ),

      // Body dari masing-masing tab
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }

  // Pill-shaped navigation item builder
  Widget _buildPillNavItem({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? SlectivColors.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected ? Colors.white : Colors.grey.shade600,
              size: 15,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade600,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Pill-shaped profile navigation item builder
  Widget _buildProfilePillNavItem(
    ProfileController profileController, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final userImage = profileController.profileImageUrl.value;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? SlectivColors.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            userImage.isNotEmpty
                ? Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.white : Colors.grey.shade600,
                      width: 1.5,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      userImage,
                      fit: BoxFit.cover,
                      width: 15,
                      height: 15,
                    ),
                  ),
                )
                : Icon(
                  isSelected
                      ? FluentIcons.person_24_filled
                      : FluentIcons.person_24_regular,
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  size: 15,
                ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade600,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
