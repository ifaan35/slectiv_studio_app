import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slectiv_studio_app/app/modules/booking/views/widgets/booking_button_modern.dart';
import 'package:slectiv_studio_app/app/modules/booking/views/widgets/booking_header.dart';
import 'package:slectiv_studio_app/app/modules/booking/views/widgets/calendar_reservation.dart';
import 'package:slectiv_studio_app/app/modules/booking/views/widgets/choose_date_title.dart';
import 'package:slectiv_studio_app/app/modules/booking/views/widgets/color_dropdown.dart';
import 'package:slectiv_studio_app/app/modules/booking/views/widgets/color_dropdown_title.dart';
import 'package:slectiv_studio_app/app/modules/booking/views/widgets/person_dropdown.dart';
import 'package:slectiv_studio_app/app/modules/booking/views/widgets/person_dropdown_title.dart';
import 'package:slectiv_studio_app/app/modules/booking/views/widgets/time_reservation.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import '../controllers/booking_controller.dart';

class BookingView extends GetView<BookingController> {
  const BookingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BookingController());
    final DateTime now = DateTime.now();
    // Mengatur ulang status pemesanan setelah berhasil atau gagal
    controller.selectedOption.value = '';
    controller.selectedQuantity.value = '';
    controller.selectedPerson.value = '';
    controller.selectedTime.value = '';

    return Scaffold(
      backgroundColor: SlectivColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Modern Header with gradient
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    SlectivColors.primaryColor,
                    SlectivColors.submitButtonColor,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: SlectivColors.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SlectivBookingHeader(),
                  const SizedBox(height: 16),
                  // Welcome text
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Book Your Session',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Choose your preferred date, time, and service options',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // Calendar Section with modern card
                    _buildModernSection(
                      icon: Icons.calendar_today,
                      title: 'Select Date',
                      subtitle: 'Choose your preferred session date',
                      child: Column(
                        children: [
                          SlectivCalendarReservation(
                            controller: controller,
                            now: now,
                          ),
                          const SizedBox(height: 16),
                          const SlectivChooseDateTitle(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Time Section with modern card
                    _buildModernSection(
                      icon: Icons.access_time,
                      title: 'Select Time',
                      subtitle: 'Pick your preferred session time',
                      child: SlectivTimeReservation(
                        controller: controller,
                        now: now,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Service Options Section
                    _buildModernSection(
                      icon: Icons.palette,
                      title: 'Background Color',
                      subtitle: 'Choose your photo background',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SlectivColorDropdownTitle(),
                          const SizedBox(height: 8),
                          SlectivColorDropdown(controller: controller),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // People Section
                    _buildModernSection(
                      icon: Icons.people,
                      title: 'Number of People',
                      subtitle: 'How many people will be in the photo?',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SlectivPersonDropdownTitle(),
                          const SizedBox(height: 8),
                          SlectivPersonDropdown(controller: controller),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Booking Button
                    SlectivBookingButton(controller: controller),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernSection({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
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
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: SlectivColors.blackColor,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: SlectivColors.hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Section Content
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: child,
          ),
        ],
      ),
    );
  }
}
