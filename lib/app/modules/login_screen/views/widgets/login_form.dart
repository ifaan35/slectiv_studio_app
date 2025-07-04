import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slectiv_studio_app/app/modules/login_screen/controllers/login_screen_controller.dart';
import 'package:slectiv_studio_app/app/modules/login_screen/views/widgets/forget_password.dart';
import 'package:slectiv_studio_app/app/modules/login_screen/views/widgets/submit_button.dart';
import 'package:slectiv_studio_app/app/modules/register_screen/views/register_screen_view.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';
import 'package:slectiv_studio_app/utils/validators/validation.dart';

class SlectivLoginForm extends StatelessWidget {
  const SlectivLoginForm({
    super.key,
    required this.loginFormKey,
    required this.loginController,
  });

  final GlobalKey<FormState> loginFormKey;
  final LoginScreenController loginController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: loginFormKey,
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
            controller: loginController.emailController,
            validator: (value) => SlectiValidator.emailValidate(value),
            decoration: InputDecoration(
              hintText: "Enter your Email",
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

          Text(
            "Password",
            style: GoogleFonts.spaceGrotesk(
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF212529),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // -- Password
          Obx(
            () => TextFormField(
              controller: loginController.passwordController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => SlectiValidator.passwordValidate(value),
              obscureText: loginController.hidePassword.value,
              decoration: InputDecoration(
                hintText: "Enter your Password",
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
                suffixIcon: Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    onPressed:
                        () =>
                            loginController.hidePassword.value =
                                !loginController.hidePassword.value,
                    icon: Icon(
                      loginController.hidePassword.value
                          ? FluentIcons.eye_off_20_regular
                          : FluentIcons.eye_20_regular,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ),
              ),
              style: GoogleFonts.spaceGrotesk(
                textStyle: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF212529),
                ),
              ),
            ),
          ),
          const SlectivForgetPassword(),
          const SizedBox(height: 36),

          // -- Login Button
          Obx(
            () => SlectiveWidgetButton(
              buttonName: SlectivTexts.login,
              onPressed:
                  loginController.isFormValid.value
                      ? () async {
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

                        loginController.loginValidation();

                        Get.back();
                      }
                      : null,
              isEnabled: loginController.isFormValid.value,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                SlectivTexts.dontHaveAccount,
                style: GoogleFonts.spaceGrotesk(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: SlectivColors.blackColor,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Get.to(() => RegisterScreenView()),
                child: Text(
                  SlectivTexts.registerHere,
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
        ],
      ),
    );
  }
}
