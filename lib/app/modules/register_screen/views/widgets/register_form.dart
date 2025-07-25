import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slectiv_studio_app/app/modules/login_screen/views/login_screen_view.dart';
import 'package:slectiv_studio_app/app/modules/login_screen/views/widgets/submit_button.dart';
import 'package:slectiv_studio_app/app/modules/register_screen/controllers/register_screen_controller.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';
import 'package:slectiv_studio_app/utils/validators/validation.dart';

class SlectivRegisterForm extends StatelessWidget {
  const SlectivRegisterForm({
    super.key,
    required this.registerFormKey,
    required this.registerController,
  });

  final GlobalKey<FormState> registerFormKey;
  final RegisterScreenController registerController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: registerFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -- Name
          Text(
            "Full Name",
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
            controller: registerController.name,
            validator: (value) => SlectiValidator.nameValidate(value),
            decoration: InputDecoration(
              hintText: "Enter your full name",
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
          const SizedBox(height: 20),

          // -- Phone Number
          Text(
            "Phone Number",
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
            controller: registerController.phoneNumber,
            validator: (value) => SlectiValidator.phoneNumberValidate(value),
            decoration: InputDecoration(
              hintText: "Enter your phone number",
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
          const SizedBox(height: 20),

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
            controller: registerController.email,
            validator: (value) => SlectiValidator.emailValidate(value),
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
          const SizedBox(height: 20),

          // -- Password
          Text(
            "Password",
            style: GoogleFonts.spaceGrotesk(
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: SlectivColors.blackColor,
              ),
            ),
          ),
          const SizedBox(height: 8),

          Obx(
            () => TextFormField(
              controller: registerController.password,
              validator: (value) => SlectiValidator.passwordValidate(value),
              obscureText: registerController.hidePassword.value,
              decoration: InputDecoration(
                hintText: SlectivTexts.passwordHintText,
                hintStyle: GoogleFonts.spaceGrotesk(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: SlectivColors.hintColor,
                  ),
                ),
                fillColor: const Color(0xFFF6F6F6),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: SlectivColors.blackColor),
                ),
                suffixIcon: IconButton(
                  onPressed:
                      () =>
                          registerController.hidePassword.value =
                              !registerController.hidePassword.value,
                  icon: Icon(
                    registerController.hidePassword.value
                        ? FluentIcons.eye_off_20_regular
                        : FluentIcons.eye_20_regular,
                  ),
                ),
              ),
              style: GoogleFonts.spaceGrotesk(
                textStyle: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // -- Confirm Password
          Text(
            SlectivTexts.confirmPassword,
            style: GoogleFonts.spaceGrotesk(
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: SlectivColors.blackColor,
              ),
            ),
          ),
          const SizedBox(height: 8),

          Obx(
            () => TextFormField(
              controller: registerController.confirmPassword,
              validator:
                  (value) => SlectiValidator.confirmPasswordValidate(
                    value,
                    registerController.password.text,
                  ),
              obscureText: registerController.hideConfirmPassword.value,
              decoration: InputDecoration(
                hintText: SlectivTexts.confirmPasswordHintText,
                hintStyle: GoogleFonts.spaceGrotesk(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: SlectivColors.hintColor,
                  ),
                ),
                fillColor: const Color(0xFFF6F6F6),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: SlectivColors.blackColor),
                ),
                suffixIcon: IconButton(
                  onPressed:
                      () =>
                          registerController.hideConfirmPassword.value =
                              !registerController.hideConfirmPassword.value,
                  icon: Icon(
                    registerController.hideConfirmPassword.value
                        ? FluentIcons.eye_off_20_regular
                        : FluentIcons.eye_20_regular,
                  ),
                ),
              ),
              style: GoogleFonts.spaceGrotesk(
                textStyle: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 36),

          // -- Register Button
          Obx(
            () => SlectiveWidgetButton(
              buttonName: SlectivTexts.register,
              onPressed:
                  registerController.isFormValid.value
                      ? () async {
                        if (registerFormKey.currentState?.validate() ?? false) {
                          // Show loading dialog
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

                          try {
                            String name = registerController.name.text;
                            String phoneNumber =
                                registerController.phoneNumber.text;
                            String email = registerController.email.text;
                            String password = registerController.password.text;

                            await registerController.registerUser(
                              name,
                              phoneNumber,
                              email,
                              password,
                            );

                            // Hide loading dialog
                            Get.back();

                            // Show success snackbar
                            Get.snackbar(
                              SlectivTexts.registerSuccessfullTitle,
                              SlectivTexts.registerSuccessfullSubtitle,
                              backgroundColor:
                                  SlectivColors.positifSnackbarColor,
                              colorText: SlectivColors.whiteColor,
                              duration: const Duration(seconds: 4),
                            );

                            // Clear form
                            registerController.clearForm();

                            // Navigate to LoginScreenView
                            Get.off(
                              () => LoginScreenView(),
                              transition: Transition.fadeIn,
                              duration: const Duration(seconds: 2),
                            );
                          } catch (e) {
                            // Hide loading dialog
                            Get.back();

                            // Show error snackbar
                            Get.snackbar(
                              SlectivTexts.snackbarErrorTitle,
                              SlectivTexts.snackbarErrorRegistrationSubtitle,
                              backgroundColor:
                                  SlectivColors
                                      .cancelAndNegatifSnackbarButtonColor,
                              colorText: Colors.white,
                            );
                          }
                        }
                      }
                      : null,
              isEnabled: registerController.isFormValid.value,
            ),
          ),

          // -- Already Have a Account ??
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                SlectivTexts.alreadyHave,
                style: GoogleFonts.spaceGrotesk(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: SlectivColors.blackColor,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Get.offAll(() => LoginScreenView()),
                child: Text(
                  SlectivTexts.loginHere,
                  style: GoogleFonts.spaceGrotesk(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: SlectivColors.submitButtonColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
