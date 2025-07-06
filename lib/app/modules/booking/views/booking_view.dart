import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slectiv_studio_app/app/modules/booking/views/widgets/booking_button_modern.dart';
import 'package:slectiv_studio_app/app/modules/booking/views/widgets/modern_booking_header.dart';
import 'package:slectiv_studio_app/app/modules/booking/views/widgets/modern_calendar_section.dart';
import 'package:slectiv_studio_app/app/modules/booking/views/widgets/modern_time_selection.dart';
import 'package:slectiv_studio_app/app/modules/booking/views/widgets/modern_service_selection.dart';
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
      backgroundColor: SlectivColors.lightBlueBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Modern Header with enhanced design
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    SlectivColors.primaryBlue,
                    SlectivColors.secondaryBlue,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: SlectivColors.primaryBlue.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const ModernBookingHeader(),
                  const SizedBox(height: 10),
                  // Enhanced welcome section
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.event_available,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Book Your Session',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Choose your preferred date, time, and service options',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Scrollable content with modern design
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Calendar Section
                    ModernCalendarSection(controller: controller, now: now),
                    const SizedBox(height: 24),

                    // Time Selection Section
                    ModernTimeSelection(controller: controller, now: now),
                    const SizedBox(height: 24),

                    // Service Selection Section
                    ModernServiceSelection(controller: controller),
                    const SizedBox(height: 32),

                    // Booking Summary Card
                    _buildBookingSummary(controller),
                    const SizedBox(height: 24),

                    // Enhanced Booking Button
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

  Widget _buildBookingSummary(BookingController controller) {
    return Obx(() {
      bool hasSelections =
          controller.selectedDay.value.toString().isNotEmpty ||
          controller.selectedTime.value.isNotEmpty ||
          controller.selectedOption.value.isNotEmpty ||
          controller.selectedPerson.value.isNotEmpty;

      if (!hasSelections) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              SlectivColors.primaryBlue.withOpacity(0.1),
              SlectivColors.secondaryBlue.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: SlectivColors.primaryBlue.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.summarize,
                  color: SlectivColors.primaryBlue,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Booking Summary',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: SlectivColors.primaryBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (controller.selectedDay.value.toString().isNotEmpty) ...[
              _buildSummaryItem(
                'Date',
                controller.selectedDay.value.toString().split(' ')[0],
              ),
              const SizedBox(height: 8),
            ],
            if (controller.selectedTime.value.isNotEmpty) ...[
              _buildSummaryItem('Time', controller.selectedTime.value),
              const SizedBox(height: 8),
            ],
            if (controller.selectedOption.value.isNotEmpty) ...[
              _buildSummaryItem('Background', controller.selectedOption.value),
              const SizedBox(height: 8),
            ],
            if (controller.selectedPerson.value.isNotEmpty) ...[
              _buildSummaryItem('People', controller.selectedPerson.value),
              const SizedBox(height: 8),
            ],
            // Price calculation
            if (controller.selectedPerson.value.isNotEmpty) ...[
              const Divider(color: SlectivColors.primaryBlue, thickness: 0.5),
              const SizedBox(height: 8),
              _buildPriceCalculation(controller.selectedPerson.value),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildSummaryItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: SlectivColors.textGray,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: SlectivColors.blackColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceCalculation(String personCount) {
    int numberOfPeople = int.tryParse(personCount) ?? 1;
    int basePrice = 75000; // Base price for 1-3 people
    int additionalPrice = 0;

    if (numberOfPeople > 3) {
      additionalPrice = (numberOfPeople - 3) * 20000;
    }

    int totalPrice = basePrice + additionalPrice;

    return Column(
      children: [
        // Base price
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Base Price (1-3 people)',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: SlectivColors.textGray,
              ),
            ),
            Text(
              'Rp ${basePrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: SlectivColors.blackColor,
              ),
            ),
          ],
        ),
        // Additional price if more than 3 people
        if (numberOfPeople > 3) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Additional (${numberOfPeople - 3} person × Rp 20.000)',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: SlectivColors.textGray,
                ),
              ),
              Text(
                'Rp ${additionalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: SlectivColors.blackColor,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 8),
        const Divider(color: SlectivColors.primaryBlue, thickness: 0.5),
        const SizedBox(height: 8),
        // Total price
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Price',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: SlectivColors.primaryBlue,
              ),
            ),
            Text(
              'Rp ${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: SlectivColors.primaryBlue,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
