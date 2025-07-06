import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slectiv_studio_app/app/modules/home/controllers/home_controller.dart';
import 'package:slectiv_studio_app/app/modules/home/views/widgets/modern_header.dart';
import 'package:slectiv_studio_app/app/modules/home/views/widgets/modern_membership_section.dart';
import 'package:slectiv_studio_app/app/modules/home/views/widgets/modern_welcome_section.dart';
import 'package:slectiv_studio_app/app/modules/home/views/widgets/service_header.dart';
import 'package:slectiv_studio_app/app/modules/home/views/widgets/tab_bar.dart';
import 'package:slectiv_studio_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(ProfileController());
    return Scaffold(
      backgroundColor: SlectivColors.lightBlueBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Modern App Bar with Header
            const SliverToBoxAdapter(child: ModernHeader()),

            // Welcome Section
            SliverToBoxAdapter(
              child: ModernWelcomeSection(profileController: profileController),
            ),

            // Content Container
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                decoration: const BoxDecoration(
                  color: SlectivColors.whiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Membership Banner with enhanced styling
                      const ModernMembershipSection(),

                      const SizedBox(height: 32),

                      // Service Categories Header
                      const ServiceHeader(),

                      const SizedBox(height: 16),

                      // Tab Bar with modern design
                      const SlectivTabSection(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
