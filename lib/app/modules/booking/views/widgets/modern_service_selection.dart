import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slectiv_studio_app/app/modules/booking/controllers/booking_controller.dart';
import 'package:slectiv_studio_app/app/modules/booking/views/widgets/color_dropdown.dart';
import 'package:slectiv_studio_app/app/modules/booking/views/widgets/person_dropdown.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';

class ModernServiceSelection extends StatelessWidget {
  final BookingController controller;

  const ModernServiceSelection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  SlectivColors.primaryBlue.withOpacity(0.05),
                  SlectivColors.secondaryBlue.withOpacity(0.05),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        SlectivColors.primaryBlue,
                        SlectivColors.secondaryBlue,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: SlectivColors.primaryBlue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.tune, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Service Options',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: SlectivColors.blackColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Customize your photo session preferences',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: SlectivColors.textGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Service Options Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Background Color Section
                _buildOptionSection(
                  icon: Icons.palette,
                  title: 'Background Color',
                  subtitle: 'Choose your photo background',
                  child: SlectivColorDropdown(controller: controller),
                ),

                const SizedBox(height: 24),

                // Number of People Section
                _buildOptionSection(
                  icon: Icons.people,
                  title: 'Number of People',
                  subtitle: 'How many people will be in the photo?',
                  child: SlectivPersonDropdown(controller: controller),
                ),

                const SizedBox(height: 16),

                // Selection Summary
                Obx(() {
                  bool hasOptions =
                      controller.selectedOption.value.isNotEmpty ||
                      controller.selectedPerson.value.isNotEmpty;

                  if (!hasOptions) return const SizedBox.shrink();

                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: SlectivColors.primaryBlue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: SlectivColors.primaryBlue.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: SlectivColors.primaryBlue,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Selected Options:',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: SlectivColors.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (controller.selectedOption.value.isNotEmpty) ...[
                          Text(
                            '• Background: ${controller.selectedOption.value}',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: SlectivColors.textGray,
                            ),
                          ),
                        ],
                        if (controller.selectedPerson.value.isNotEmpty) ...[
                          Text(
                            '• People: ${controller.selectedPerson.value}',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: SlectivColors.textGray,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionSection({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: SlectivColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: SlectivColors.primaryBlue, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: SlectivColors.blackColor,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: SlectivColors.textGray,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}
