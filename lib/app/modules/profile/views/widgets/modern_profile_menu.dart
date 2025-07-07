import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slectiv_studio_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';

class ModernProfileMenu extends StatelessWidget {
  const ModernProfileMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Account Settings Section
        _buildMenuSection(
          title: "Account Settings",
          icon: Icons.settings_outlined,
          children: [
            _buildMenuItem(
              icon: Icons.edit_outlined,
              title: "Edit Profile",
              subtitle: "Update your personal information",
              onTap: () => _showEditProfile(),
            ),
            _buildMenuItem(
              icon: Icons.security_outlined,
              title: "Privacy & Security",
              subtitle: "Manage your account security",
              onTap: () => _showPrivacySettings(),
            ),
            _buildMenuItem(
              icon: Icons.notifications_outlined,
              title: "Notifications",
              subtitle: "Configure notification preferences",
              onTap: () => _showNotificationSettings(),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // App Settings Section
        _buildMenuSection(
          title: "App Settings",
          icon: Icons.tune_outlined,
          children: [
            _buildMenuItem(
              icon: Icons.language_outlined,
              title: "Language",
              subtitle: "Change app language",
              trailing: Text(
                "English",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 12,
                  color: SlectivColors.textGray,
                ),
              ),
              onTap: () => _showLanguageSettings(),
            ),
            _buildMenuItem(
              icon: Icons.dark_mode_outlined,
              title: "Theme",
              subtitle: "Switch between light and dark mode",
              trailing: Switch(
                value: false,
                onChanged: (value) => _toggleTheme(value),
                activeColor: SlectivColors.primaryBlue,
              ),
              onTap: null,
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Support Section
        _buildMenuSection(
          title: "Support",
          icon: Icons.help_outline_rounded,
          children: [
            _buildMenuItem(
              icon: Icons.help_center_outlined,
              title: "Help Center",
              subtitle: "Get help and support",
              onTap: () => _showHelpCenter(),
            ),
            _buildMenuItem(
              icon: Icons.feedback_outlined,
              title: "Send Feedback",
              subtitle: "Share your thoughts with us",
              onTap: () => _showFeedback(),
            ),
            _buildMenuItem(
              icon: Icons.info_outlined,
              title: "About",
              subtitle: "App version and information",
              onTap: () => _showAbout(),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Sign Out Button
        _buildSignOutButton(),
      ],
    );
  }

  Widget _buildMenuSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
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
        children: [
          // Section Header
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: SlectivColors.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: SlectivColors.primaryBlue, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: SlectivColors.titleColor,
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            color: SlectivColors.backgroundColor,
          ),

          // Menu Items
          ...children,
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: SlectivColors.backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: SlectivColors.primaryBlue, size: 18),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: SlectivColors.titleColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: SlectivColors.textGray,
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
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

  Widget _buildSignOutButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
      child: ElevatedButton(
        onPressed: () => _showSignOutConfirmation(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade50,
          foregroundColor: Colors.red.shade600,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.red.shade200, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, size: 20, color: Colors.red.shade600),
            const SizedBox(width: 8),
            Text(
              "Sign Out",
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.red.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Action Methods
  void _showEditProfile() {
    Get.snackbar("Edit Profile", "Feature coming soon!");
  }

  void _showPrivacySettings() {
    Get.snackbar("Privacy & Security", "Feature coming soon!");
  }

  void _showNotificationSettings() {
    Get.snackbar("Notifications", "Feature coming soon!");
  }

  void _showLanguageSettings() {
    Get.snackbar("Language", "Feature coming soon!");
  }

  void _toggleTheme(bool value) {
    Get.snackbar("Theme", "Theme switching coming soon!");
  }

  void _showHelpCenter() {
    Get.snackbar("Help Center", "Feature coming soon!");
  }

  void _showFeedback() {
    Get.snackbar("Feedback", "Feature coming soon!");
  }

  void _showAbout() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "About Slectiv Studio",
          style: GoogleFonts.spaceGrotesk(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Version: 1.0.0",
              style: GoogleFonts.spaceGrotesk(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              "Professional Photography Studio App",
              style: GoogleFonts.spaceGrotesk(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              "© 2025 Slectiv Studio",
              style: GoogleFonts.spaceGrotesk(
                fontSize: 12,
                color: SlectivColors.textGray,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "OK",
              style: GoogleFonts.spaceGrotesk(
                color: SlectivColors.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSignOutConfirmation() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Sign Out",
          style: GoogleFonts.spaceGrotesk(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          "Are you sure you want to sign out?",
          style: GoogleFonts.spaceGrotesk(fontSize: 14),
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
              Get.back();
              final controller = Get.find<ProfileController>();
              controller.signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Sign Out",
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
