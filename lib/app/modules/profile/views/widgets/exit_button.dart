import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slectiv_studio_app/app/routes/app_pages.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';

class SlectivExitButton extends StatelessWidget {
  const SlectivExitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: SlectivColors.cancelAndNegatifSnackbarButtonColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: SlectivColors.cancelAndNegatifSnackbarButtonColor
                    .withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () async {
              bool confirmExit = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      SlectivTexts.profileExitTitle,
                      style: GoogleFonts.spaceGrotesk(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: SlectivColors.blackColor,
                        ),
                      ),
                    ),
                    content: Text(
                      SlectivTexts.profileConfirmExitMessage,
                      style: GoogleFonts.spaceGrotesk(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: SlectivColors.blackColor,
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: SlectivColors.primaryBlue,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextButton(
                          child: Text(
                            SlectivTexts.profileConfirmCancel,
                            style: GoogleFonts.spaceGrotesk(
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: SlectivColors.primaryBlue,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Get.back(result: false);
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color:
                              SlectivColors.cancelAndNegatifSnackbarButtonColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextButton(
                          child: Text(
                            SlectivTexts.profileConfirmExit,
                            style: GoogleFonts.spaceGrotesk(
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Get.back(result: true);
                          },
                        ),
                      ),
                    ],
                  );
                },
              );

              if (confirmExit == true) {
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

                Get.back();

                Get.snackbar(
                  SlectivTexts.profileSuccessLogoutTitleButton,
                  SlectivTexts.profileSuccessLogoutSubtitleButton,
                  backgroundColor: SlectivColors.positifSnackbarColor,
                  colorText: SlectivColors.whiteColor,
                  duration: const Duration(seconds: 4),
                );

                Get.offAllNamed(Routes.LOGIN_SCREEN);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 0,
            ),
            child: Text(
              SlectivTexts.exit,
              style: GoogleFonts.spaceGrotesk(
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
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
