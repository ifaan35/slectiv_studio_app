import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slectiv_studio_app/app/modules/booking/controllers/booking_controller.dart';
import 'package:slectiv_studio_app/app/modules/booking/views/widgets/time_reservation.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';

class ModernTimeSelection extends StatelessWidget {
  final BookingController controller;
  final DateTime now;

  const ModernTimeSelection({
    super.key,
    required this.controller,
    required this.now,
  });

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
                  SlectivColors.secondaryBlue.withOpacity(0.1),
                  SlectivColors.primaryBlue.withOpacity(0.1),
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
                        SlectivColors.secondaryBlue,
                        SlectivColors.primaryBlue,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: SlectivColors.secondaryBlue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.access_time,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Time',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: SlectivColors.blackColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pick your preferred session time',
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

          // Time Selection Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                SlectivTimeReservation(controller: controller, now: now),
                const SizedBox(height: 16),

                // Selected time display
                Obx(() {
                  if (controller.selectedTime.value.isNotEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: SlectivColors.secondaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: SlectivColors.secondaryBlue.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            color: SlectivColors.secondaryBlue,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Selected Time: ${controller.selectedTime.value}',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: SlectivColors.secondaryBlue,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
