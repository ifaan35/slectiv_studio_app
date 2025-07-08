import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:slectiv_studio_app/app/routes/app_pages.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';

class GuestProfileView extends StatelessWidget {
  const GuestProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [SlectivColors.primary, SlectivColors.lightBlueBackground],
            stops: [0.0, 0.4],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Content
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        // Guest Welcome Card
                        _buildGuestWelcomeCard(),

                        const SizedBox(height: 30),

                        // Login Benefits
                        _buildLoginBenefits(),

                        const SizedBox(height: 40),

                        // Action Buttons
                        _buildActionButtons(),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          const Text(
            'Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              FluentIcons.person_24_regular,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            SlectivColors.primary.withOpacity(0.1),
            SlectivColors.lightBlueBackground.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: SlectivColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: SlectivColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: SlectivColors.primary.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(
              FluentIcons.person_24_regular,
              size: 40,
              color: SlectivColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Welcome to Slectiv Studio',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: SlectivColors.dark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sign in to unlock your personalized experience',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: SlectivColors.darkGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBenefits() {
    final benefits = [
      {
        'icon': FluentIcons.bookmark_24_regular,
        'title': 'Easy Booking',
        'subtitle': 'Book your sessions with just a few taps',
      },
      {
        'icon': FluentIcons.history_24_regular,
        'title': 'Booking History',
        'subtitle': 'Track all your past and upcoming sessions',
      },
      {
        'icon': FluentIcons.person_24_regular,
        'title': 'Profile Management',
        'subtitle': 'Manage your personal information and preferences',
      },
      {
        'icon': FluentIcons.star_24_regular,
        'title': 'Exclusive Benefits',
        'subtitle': 'Get special offers and loyalty rewards',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Benefits of Creating Account',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: SlectivColors.dark,
          ),
        ),
        const SizedBox(height: 16),
        ...benefits.map(
          (benefit) => _buildBenefitItem(
            icon: benefit['icon'] as IconData,
            title: benefit['title'] as String,
            subtitle: benefit['subtitle'] as String,
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: SlectivColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: SlectivColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: SlectivColors.dark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: SlectivColors.darkGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Sign In Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => Get.toNamed(Routes.LOGIN_SCREEN),
            style: ElevatedButton.styleFrom(
              backgroundColor: SlectivColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FluentIcons.person_24_filled,
                  size: 20,
                  color: Colors.white,
                ),
                SizedBox(width: 12),
                Text(
                  'Sign In',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Create Account Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: () => Get.toNamed(Routes.REGISTER_SCREEN),
            style: OutlinedButton.styleFrom(
              foregroundColor: SlectivColors.primary,
              side: BorderSide(color: SlectivColors.primary, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FluentIcons.person_add_24_regular,
                  size: 20,
                  color: SlectivColors.primaryColor,
                ),
                SizedBox(width: 12),
                Text(
                  'Create Account',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
