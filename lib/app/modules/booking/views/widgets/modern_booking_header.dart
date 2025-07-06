import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slectiv_studio_app/app/modules/booking/views/widgets/booking_history.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';

class ModernBookingHeader extends StatelessWidget {
  const ModernBookingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Back Button with enhanced design
        GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),

        // Enhanced Title
        Column(
          children: [
            Text(
              SlectivTexts.bookingTitle,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Container(
              width: 40,
              height: 2,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),

        // History Button with enhanced design
        GestureDetector(
          onTap: () => Get.to(() => const SlectivBookingHistory()),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: const Icon(Icons.history, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }
}
