import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';

class SlectiveWidgetButton extends StatelessWidget {
  const SlectiveWidgetButton({
    super.key,
    required this.buttonName,
    required this.onPressed,
    required this.backgroundColor,
    this.isEnabled = true,
  });
  final String buttonName;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final buttonHeight =
        screenHeight < 600
            ? 48.0
            : screenHeight < 800
            ? 52.0
            : 56.0;

    return Container(
      width: double.infinity,
      height: buttonHeight,
      decoration: BoxDecoration(
        gradient:
            isEnabled
                ? LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    SlectivColors.primaryBlue,
                    SlectivColors.secondaryBlue,
                  ],
                )
                : null,
        color: isEnabled ? null : SlectivColors.hintColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          elevation: WidgetStateProperty.all(0),
        ),
        child: Text(
          buttonName,
          style: GoogleFonts.spaceGrotesk(
            textStyle: TextStyle(
              fontSize:
                  screenHeight < 600
                      ? 16.0
                      : screenHeight < 800
                      ? 17.0
                      : 18.0,
              fontWeight: FontWeight.w600,
              color: isEnabled ? Colors.white : SlectivColors.hintColor,
            ),
          ),
        ),
      ),
    );
  }
}

class SlectiveCancelButton extends StatelessWidget {
  const SlectiveCancelButton({
    super.key,
    required this.buttonName,
    required this.onPressed,
  });
  final String buttonName;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final buttonHeight =
        screenHeight < 600
            ? 48.0
            : screenHeight < 800
            ? 52.0
            : 56.0;

    return Container(
      width: double.infinity,
      height: buttonHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: SlectivColors.primaryBlue, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          elevation: WidgetStateProperty.all(0),
        ),
        child: Text(
          buttonName,
          style: GoogleFonts.spaceGrotesk(
            textStyle: TextStyle(
              fontSize:
                  screenHeight < 600
                      ? 16.0
                      : screenHeight < 800
                      ? 17.0
                      : 18.0,
              fontWeight: FontWeight.w600,
              color: SlectivColors.primaryBlue,
            ),
          ),
        ),
      ),
    );
  }
}
