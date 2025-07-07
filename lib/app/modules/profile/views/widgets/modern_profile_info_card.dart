import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slectiv_studio_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';

class ModernProfileInfoCard extends StatelessWidget {
  const ModernProfileInfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) {
        return Obx(
          () => Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: SlectivColors.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.person_outline_rounded,
                        color: SlectivColors.primaryBlue,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Personal Information",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: SlectivColors.titleColor,
                      ),
                    ),
                    const Spacer(),
                    if (controller.isLoading.value)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  ],
                ),

                const SizedBox(height: 24),

                // Name Field
                _buildInfoField(
                  icon: Icons.person_outline,
                  label: "Full Name",
                  value:
                      controller.name.value.isNotEmpty
                          ? controller.name.value
                          : "Not set",
                  onTap: () => _showEditNameDialog(context),
                ),

                const SizedBox(height: 16),

                // Email Field
                _buildInfoField(
                  icon: Icons.email_outlined,
                  label: "Email Address",
                  value:
                      controller.email.value.isNotEmpty
                          ? controller.email.value
                          : "Not set",
                  onTap: () => _showEditEmailDialog(context),
                ),

                const SizedBox(height: 16),

                // Phone Field
                _buildInfoField(
                  icon: Icons.phone_outlined,
                  label: "Phone Number",
                  value:
                      controller.phoneNumber.value.isNotEmpty
                          ? controller.phoneNumber.value
                          : "Not set",
                  onTap: () => _showEditPhoneDialog(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoField({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: SlectivColors.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: SlectivColors.primaryBlue.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: SlectivColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: SlectivColors.primaryBlue, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: SlectivColors.textGray,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: SlectivColors.titleColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: SlectivColors.textGray,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showEditNameDialog(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final TextEditingController nameController = TextEditingController(
      text: controller.name.value,
    );

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Edit Name",
          style: GoogleFonts.spaceGrotesk(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: "Full Name",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: GoogleFonts.spaceGrotesk(color: SlectivColors.textGray),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final controller = Get.find<ProfileController>();
              controller.updateName(nameController.text);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: SlectivColors.primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Save",
              style: GoogleFonts.spaceGrotesk(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditEmailDialog(BuildContext context) {
    Get.snackbar(
      "Info",
      "Email cannot be changed from this screen",
      backgroundColor: SlectivColors.primaryBlue.withOpacity(0.1),
      colorText: SlectivColors.primaryBlue,
    );
  }

  void _showEditPhoneDialog(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final TextEditingController phoneController = TextEditingController(
      text: controller.phoneNumber.value,
    );

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Edit Phone Number",
          style: GoogleFonts.spaceGrotesk(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: "Phone Number",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: GoogleFonts.spaceGrotesk(color: SlectivColors.textGray),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final controller = Get.find<ProfileController>();
              controller.updatePhoneNumber(phoneController.text);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: SlectivColors.primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Save",
              style: GoogleFonts.spaceGrotesk(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
