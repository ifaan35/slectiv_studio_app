import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';

class SlectivLoginHeaderText extends StatelessWidget {
  const SlectivLoginHeaderText({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.spaceGrotesk(
            textStyle: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: SlectivColors.primaryBlue,
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: GoogleFonts.spaceGrotesk(
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: SlectivColors.textGray,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Decorative line
        Container(
          width: 40,
          height: 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: LinearGradient(
              colors: [SlectivColors.primaryBlue, SlectivColors.secondaryBlue],
            ),
          ),
        ),
      ],
    );
  }
}
