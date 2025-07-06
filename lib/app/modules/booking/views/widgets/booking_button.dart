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
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        SlectivColors.primaryBlue,
                        SlectivColors.secondaryBlue,
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
                        color: SlectivColors.primaryBlue.withValues(alpha: 0.3),
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
                          // Show loading dialog
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

                          try {
                            // Process booking and payment
                            await controller.slectivBookingValidation(
                              controller,
                            );
                            // Close loading dialog
                            Get.back();
                          } catch (e) {
                            // Close loading dialog on error
                            Get.back();
                            Get.snackbar(
                              'Error',
                              'Terjadi kesalahan: ${e.toString()}',
                              backgroundColor:
                                  SlectivColors
                                      .cancelAndNegatifSnackbarButtonColor,
                              colorText: SlectivColors.whiteColor,
                            );
                          }
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
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              contentPadding: const EdgeInsets.all(24),
              title: null, // Remove default title
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Custom Title with Icon
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              SlectivColors.primaryBlue.withOpacity(0.2),
                              SlectivColors.secondaryBlue.withOpacity(0.2),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.help_outline_rounded,
                          color: SlectivColors.primaryBlue,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          SlectivTexts.snackbarBookingConfirmTitle,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: SlectivColors.primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Content
                  Text(
                    SlectivTexts.snackbarBookingConfirmSubtitle,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: SlectivColors.textGray,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Action Buttons
                  Row(
                    children: [
                      // Cancel Button
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: SlectivColors.primaryBlue.withOpacity(0.4),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              SlectivTexts.bookingNo,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: SlectivColors.primaryBlue,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Confirm Button
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                SlectivColors.primaryBlue,
                                SlectivColors.secondaryBlue,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: SlectivColors.primaryBlue.withOpacity(
                                  0.4,
                                ),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              SlectivTexts.bookingYes,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ) ??
        false;
  }
}
