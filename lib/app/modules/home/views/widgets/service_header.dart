import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';

class ServiceHeader extends StatelessWidget {
  const ServiceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [SlectivColors.primaryBlue, SlectivColors.secondaryBlue],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.photo_camera_outlined,
            color: SlectivColors.whiteColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          "Our Services",
          style: GoogleFonts.spaceGrotesk(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: SlectivColors.titleColor,
          ),
        ),
      ],
    );
  }
}
