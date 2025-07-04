import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/utils/constants/image_strings.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';

class SlectivAuthenticationHeader extends StatelessWidget {
  const SlectivAuthenticationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // Circular logo container like in the image
          Container(
            width: 120,
            height: 120,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: SlectivColors.whiteColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Image(
              image: AssetImage(SlectivImages.applogo),
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 24),
          // Brand Title
          Text(
            "SLECTIV STUDIO",
            style: GoogleFonts.spaceGrotesk(
              textStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: SlectivColors.titleColor,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Blue underline
          Container(
            width: 60,
            height: 3,
            decoration: BoxDecoration(
              color: SlectivColors.primaryBlue,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),
          // Subtitle
          Text(
            SlectivTexts.brandSubtitle,
            style: GoogleFonts.spaceGrotesk(
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: SlectivColors.textGray,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
