import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slectiv_studio_app/app/modules/bottom_navigation_bar/controllers/bottom_navigation_bar_controller.dart';
import 'package:slectiv_studio_app/app/modules/bottom_navigation_bar/views/bottom_navigation_bar_view.dart';
import 'package:slectiv_studio_app/app/modules/login_screen/views/widgets/submit_button.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/utils/constants/image_strings.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';

class SlectivSelfPhoto extends StatelessWidget {
  const SlectivSelfPhoto({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SlectivColors.lightBlueBackground,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              // Title
              Text(
                SlectivTexts.selfPhotoTitle,
                style: GoogleFonts.spaceGrotesk(
                  textStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: SlectivColors.blackColor,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Image Card
              Card(
                elevation: 8,
                shadowColor: SlectivColors.blackColor.withOpacity(0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: const Image(
                      image: AssetImage(SlectivImages.selfPhotoImages),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Description Card
              Card(
                elevation: 8,
                shadowColor: SlectivColors.blackColor.withOpacity(0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Service Description",
                        style: GoogleFonts.spaceGrotesk(
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: SlectivColors.blackColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        SlectivTexts.selfPhotoDescription,
                        style: GoogleFonts.spaceGrotesk(
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: SlectivColors.blackColor,
                            height: 1.5,
                          ),
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Pricing and Features Card
              Card(
                elevation: 8,
                shadowColor: SlectivColors.blackColor.withOpacity(0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pricing Section
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pricing",
                              style: GoogleFonts.spaceGrotesk(
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: SlectivColors.blackColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              SlectivTexts.selfPhotoPerson,
                              style: GoogleFonts.spaceGrotesk(
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: SlectivColors.blackColor,
                                ),
                              ),
                            ),
                            Text(
                              SlectivTexts.selfPhotoPrice,
                              style: GoogleFonts.spaceGrotesk(
                                textStyle: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: SlectivColors.primaryColor,
                                ),
                              ),
                            ),
                            Text(
                              SlectivTexts.selfPhotoFee,
                              style: GoogleFonts.spaceGrotesk(
                                textStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: SlectivColors.hintColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 20),

                      // Features Section
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "What's Included",
                              style: GoogleFonts.spaceGrotesk(
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: SlectivColors.blackColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildFeatureItem(
                              SlectivTexts.minutes15SessionFeature,
                            ),
                            const SizedBox(height: 8),
                            _buildFeatureItem(SlectivTexts.softliteFeature),
                            const SizedBox(height: 8),
                            _buildFeatureItem(SlectivTexts.printedPhotoFeature),
                            const SizedBox(height: 8),
                            _buildFeatureItem(
                              SlectivTexts.chooseBackgroundFeature,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Book Now Button
              SlectiveWidgetButton(
                buttonName: SlectivTexts.selfPhotoButtonName,
                onPressed: () {
                  final bottomNavBarController =
                      Get.find<BottomNavigationBarController>();
                  bottomNavBarController.selectedIndex.value = 1;
                  Get.to(const BottomNavigationBarView());
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: SlectivColors.primaryColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            feature,
            style: GoogleFonts.spaceGrotesk(
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: SlectivColors.blackColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
