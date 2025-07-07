import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import '../controllers/profile_controller.dart';
import 'widgets/modern_profile_header.dart';
import 'widgets/modern_profile_info_card.dart';
import 'widgets/modern_profile_menu.dart';
import 'widgets/modern_profile_stats.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SlectivColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Modern Header with Gradient
              const ModernProfileHeader(),

              // Content Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    // Profile Info Card
                    const ModernProfileInfoCard(),

                    const SizedBox(height: 24),

                    // Profile Stats
                    const ModernProfileStats(),

                    const SizedBox(height: 24),

                    // Profile Menu
                    const ModernProfileMenu(),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
