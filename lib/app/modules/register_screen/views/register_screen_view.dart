import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slectiv_studio_app/app/modules/register_screen/views/widgets/register_form.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/utils/constants/image_strings.dart';
import '../controllers/register_screen_controller.dart';

class RegisterScreenView extends GetView<RegisterScreenController> {
  RegisterScreenView({super.key});

  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final registerController = Get.put(RegisterScreenController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(height: 60),

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

                // Register Header
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Create Account",
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF212529),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Sign up to get started with our services",
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

                // Register Form
                SlectivRegisterForm(
                  registerFormKey: registerFormKey,
                  registerController: registerController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
