import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slectiv_studio_app/app/modules/booking/views/widgets/booking_button.dart';
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -- Header
                const SizedBox(height: 24),
                const SlectivBookingHeader(),
                const SizedBox(height: 10),

                // -- Calendar
                SlectivCalendarReservation(controller: controller, now: now),
                const SizedBox(height: 20),

                // -- Date Choosing
                const SlectivChooseDateTitle(),
                const SizedBox(height: 20),

                // -- Time slots
                SlectivTimeReservation(controller: controller, now: now),
                const SizedBox(height: 20),

                // -- Color Dropdowns
                const SlectivColorDropdownTitle(),
                const SizedBox(height: 8),

                SlectivColorDropdown(controller: controller),
                const SizedBox(height: 20),

                // -- Person Dropdowns
                const SlectivPersonDropdownTitle(),
                const SizedBox(height: 8),

                SlectivPersonDropdown(controller: controller),
                const SizedBox(height: 32),

                // -- Booking Button
                SlectivBookingButton(controller: controller),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
