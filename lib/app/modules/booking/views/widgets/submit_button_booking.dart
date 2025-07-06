import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';

class SlectiveWidgetButtonBooking extends StatelessWidget {
  const SlectiveWidgetButtonBooking({
    super.key,
    required this.buttonName,
    required this.onPressed,
    required this.backgroundColor,
  });
  final String buttonName;
  final VoidCallback onPressed;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [SlectivColors.primaryBlue, SlectivColors.secondaryBlue],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: SlectivColors.primaryBlue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Text(
              buttonName,
              style: GoogleFonts.spaceGrotesk(
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: SlectivColors.whiteColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
