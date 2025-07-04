import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slectiv_studio_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';

class SlectivHelloToUser extends StatelessWidget {
  const SlectivHelloToUser({
    super.key,
    required this.profileController,
    this.textColor = SlectivColors.titleColor,
  });

  final ProfileController profileController;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            SlectivTexts.hallo,
            style: GoogleFonts.spaceGrotesk(
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textColor.withOpacity(0.8),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            profileController.name.value,
            style: GoogleFonts.spaceGrotesk(
              textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
