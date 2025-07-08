import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:slectiv_studio_app/app/routes/app_pages.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/utils/constants/image_strings.dart';

class GuestBookingView extends StatelessWidget {
  const GuestBookingView({super.key});

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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Booking Info Card
                        _buildBookingInfoCard(),

                        const SizedBox(height: 30),

                        // Services Preview
                        _buildServicesPreview(),

                        const SizedBox(height: 30),

                        // Why Create Account
                        _buildWhyCreateAccount(),

                        const SizedBox(height: 30),

                        // Action Buttons
                        _buildActionButtons(),
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
            'Booking',
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
              FluentIcons.calendar_24_regular,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingInfoCard() {
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
              FluentIcons.calendar_add_24_regular,
              size: 40,
              color: SlectivColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Ready to Book Your Session?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: SlectivColors.dark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sign in to access our easy booking system and manage your appointments',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: SlectivColors.darkGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesPreview() {
    final services = [
      {
        'image': SlectivImages.selfPhoto,
        'title': 'Self Photo',
        'description': 'Professional solo portraits',
        'price': 'Starting from Rp 75.000',
      },
      {
        'image': SlectivImages.widePhotobox,
        'title': 'Wide Photobox',
        'description': 'Group photos and family sessions',
        'price': 'Starting from Rp 75.000',
      },
      {
        'image': SlectivImages.photobooth,
        'title': 'Photobooth',
        'description': 'Fun instant photo sessions',
        'price': 'Price by agreement',
      },
      //to portrait
      {
        'image': SlectivImages.potrait,
        'title': 'Portrait',
        'description': 'Artistic and creative portraits',
        'price': 'Price by agreement',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Our Services',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: SlectivColors.dark,
          ),
        ),
        const SizedBox(height: 16),
        ...services.map(
          (service) => _buildServiceCard(
            image: service['image'] as String,
            title: service['title'] as String,
            description: service['description'] as String,
            price: service['price'] as String,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard({
    required String image,
    required String title,
    required String description,
    required String price,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SlectivColors.lightGrey, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: SlectivColors.lightBlueBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    FluentIcons.camera_24_regular,
                    color: SlectivColors.primary,
                    size: 24,
                  ),
                );
              },
            ),
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
                  description,
                  style: TextStyle(fontSize: 13, color: SlectivColors.darkGrey),
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: SlectivColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            FluentIcons.chevron_right_24_regular,
            color: SlectivColors.darkGrey,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildWhyCreateAccount() {
    final benefits = [
      {
        'icon': FluentIcons.calendar_checkmark_24_regular,
        'title': 'Easy Scheduling',
        'description': 'Pick your preferred date and time',
      },
      {
        'icon': FluentIcons.payment_24_regular,
        'title': 'Secure Payment',
        'description': 'Multiple payment options available',
      },
      {
        'icon': FluentIcons.alert_24_regular,
        'title': 'Instant Confirmation',
        'description': 'Get booking confirmation immediately',
      },
      {
        'icon': FluentIcons.history_24_regular,
        'title': 'Booking History',
        'description': 'Track all your sessions in one place',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Why Sign In to Book?',
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
            description: benefit['description'] as String,
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: SlectivColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: SlectivColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: SlectivColors.dark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: SlectivColors.darkGrey),
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
        // Sign In to Book Button
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
                  FluentIcons.calendar_add_24_filled,
                  size: 20,
                  color: SlectivColors.whiteColor,
                ),
                SizedBox(width: 12),

                Text(
                  'Sign In to Book',
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
                  color: SlectivColors.primaryColor,
                  size: 20,
                ),
                SizedBox(width: 12),
                Text(
                  'Create New Account',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Browse Gallery Button (Without Login)
      ],
    );
  }
}
