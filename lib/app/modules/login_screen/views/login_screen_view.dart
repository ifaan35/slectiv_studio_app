import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slectiv_studio_app/app/modules/login_screen/views/widgets/authentication_header.dart';
import 'package:slectiv_studio_app/app/modules/login_screen/views/widgets/header_text.dart';
import 'package:slectiv_studio_app/app/modules/login_screen/views/widgets/login_form.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/utils/constants/image_strings.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';
import '../controllers/login_screen_controller.dart';

class LoginScreenView extends GetView<LoginScreenController> {
  LoginScreenView({super.key});

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final loginController = Get.put(LoginScreenController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Logo section
                Container(
                  width: 120,
                  height: 120,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFF8F9FA),
                    border: Border.all(
                      color: const Color(0xFFE9ECEF),
                      width: 1,
                    ),
                  ),
                  child: const Image(
                    image: AssetImage(SlectivImages.applogo),
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 24),

                // Brand text
                Text(
                  "SLECTIV STUDIO",
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF212529),
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 8),

                // Decorative line
                Container(
                  width: 60,
                  height: 3,
                  decoration: BoxDecoration(
                    color: SlectivColors.primaryBlue,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Smile, Click, And Make Everlasting",
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6C757D),
                  ),
                ),

                const SizedBox(height: 48),

                // Welcome section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome!",
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF212529),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Please login to get started",
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6C757D),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Login Form
                SlectivLoginForm(
                  loginFormKey: loginFormKey,
                  loginController: loginController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
