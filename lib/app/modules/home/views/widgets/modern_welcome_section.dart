import 'package:flutter/material.dart';
import 'package:slectiv_studio_app/app/modules/home/views/widgets/account_type.dart.dart';
import 'package:slectiv_studio_app/app/modules/home/views/widgets/welcome_user.dart';
import 'package:slectiv_studio_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';

class ModernWelcomeSection extends StatelessWidget {
  final ProfileController profileController;

  const ModernWelcomeSection({super.key, required this.profileController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [SlectivColors.primaryBlue, SlectivColors.secondaryBlue],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: SlectivColors.primaryBlue.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section with Icon
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SlectivHelloToUser(
                        profileController: profileController,
                        textColor: SlectivColors.whiteColor,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: SlectivColors.whiteColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.waving_hand,
                    color: SlectivColors.whiteColor,
                    size: 24,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Divider line
            Container(
              height: 1,
              color: SlectivColors.whiteColor.withOpacity(0.2),
            ),

            const SizedBox(height: 16),

            // Account Type Section with clean design
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: SlectivColors.whiteColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.account_circle_outlined,
                    color: SlectivColors.whiteColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Account Type",
                        style: TextStyle(
                          fontSize: 12,
                          color: SlectivColors.whiteColor.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SlectivTypeAccount(textColor: SlectivColors.whiteColor),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
