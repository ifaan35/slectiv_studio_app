import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';

class EmptyGallery extends StatelessWidget {
  const EmptyGallery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: SlectivColors.primaryBlue.withOpacity(0.2),
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: SlectivColors.primaryBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.photo_library_outlined,
              size: 48,
              color: SlectivColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Empty Gallery',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: SlectivColors.titleColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Photos will be added soon',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: SlectivColors.textGray,
            ),
          ),
        ],
      ),
    );
  }
}
