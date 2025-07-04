import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slectiv_studio_app/app/modules/forget_password_screen/controllers/forget_password_screen_controller.dart';
import 'package:slectiv_studio_app/app/modules/login_screen/views/login_screen_view.dart';
import 'package:slectiv_studio_app/app/modules/login_screen/views/widgets/submit_button.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';
import 'package:slectiv_studio_app/utils/validators/validation.dart';

class SlectivFormForgetPassword extends StatelessWidget {
  const SlectivFormForgetPassword({
    super.key,
    required this.forgetPasswordFormKey,
    required this.forgetPasswordController,
  });

  final GlobalKey<FormState> forgetPasswordFormKey;
  final ForgetPasswordScreenController forgetPasswordController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: forgetPasswordFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -- Email
          Text(
            "Email",
            style: GoogleFonts.spaceGrotesk(
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF212529),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: forgetPasswordController.emailController,
            validator:
                (value) => SlectiValidator.forgetPasswordEmailValidate(value),
            decoration: InputDecoration(
              hintText: "Enter your email",
              hintStyle: GoogleFonts.spaceGrotesk(
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF9CA3AF),
                ),
              ),
              fillColor: const Color(0xFFF3F4F6),
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: SlectivColors.primaryBlue,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            style: GoogleFonts.spaceGrotesk(
              textStyle: const TextStyle(
                fontSize: 16,
                color: Color(0xFF212529),
              ),
            ),
          ),
          const SizedBox(height: 48),

          // -- Forget Password Button
          Obx(
            () => SlectiveWidgetButton(
              buttonName: SlectivTexts.sendForgetPassword,
              onPressed:
                  forgetPasswordController.isFormValid.value
                      ? () async {
                        if (forgetPasswordFormKey.currentState!.validate()) {
                          Get.dialog(
                            const Center(
                              child: SizedBox(
                                height: 100,
                                width: 100,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    SlectivColors.circularProgressColor,
                                  ),
                                ),
                              ),
                            ),
                            barrierDismissible: false,
                          );
                          await Future.delayed(const Duration(seconds: 3));

                          forgetPasswordController.resetPassword(
                            forgetPasswordController.emailController.text,
                          );

                          Get.back();

                          forgetPasswordController.clearForm();
                        }
                      }
                      : null,
              backgroundColor: SlectivColors.submitButtonColor,
              isEnabled: forgetPasswordController.isFormValid.value,
            ),
          ),
          const SizedBox(height: 24),

          // -- Back to login Button
          SlectiveCancelButton(
            buttonName: SlectivTexts.backToLogin,
            onPressed: () => Get.off(() => LoginScreenView()),
          ),
        ],
      ),
    );
  }
}
