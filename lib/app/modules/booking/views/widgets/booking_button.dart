import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slectiv_studio_app/app/modules/booking/controllers/booking_controller.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';

class SlectivBookingButton extends StatelessWidget {
  const SlectivBookingButton({super.key, required this.controller});

  final BookingController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(() {
        final isButtonEnabled = controller.isBookingComplete;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient:
                isButtonEnabled
                    ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        SlectivColors.primaryColor,
                        SlectivColors.submitButtonColor,
                      ],
                    )
                    : null,
            color:
                isButtonEnabled
                    ? null
                    : SlectivColors.hintColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
            boxShadow:
                isButtonEnabled
                    ? [
                      BoxShadow(
                        color: SlectivColors.primaryColor.withValues(
                          alpha: 0.3,
                        ),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ]
                    : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap:
                  isButtonEnabled
                      ? () async {
                        bool confirmed = await _showBookingConfirmation(
                          context,
                        );
                        if (confirmed) {
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
                          await controller.slectivBookingValidation(controller);
                          Get.back();
                        }
                      }
                      : null,
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event_available,
                      color:
                          isButtonEnabled
                              ? Colors.white
                              : SlectivColors.hintColor,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      SlectivTexts.bookingNow,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color:
                            isButtonEnabled
                                ? Colors.white
                                : SlectivColors.hintColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Future<bool> _showBookingConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                SlectivTexts.snackbarBookingConfirmTitle,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: SlectivColors.blackColor,
                ),
              ),
              content: Text(
                SlectivTexts.snackbarBookingConfirmSubtitle,
                textAlign: TextAlign.justify,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: SlectivColors.hintColor,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    SlectivTexts.bookingNo,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: SlectivColors.hintColor,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        SlectivColors.primaryColor,
                        SlectivColors.submitButtonColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(
                      SlectivTexts.bookingYes,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
