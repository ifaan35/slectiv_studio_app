import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slectiv_studio_app/app/modules/booking/controllers/booking_controller.dart';
import 'package:slectiv_studio_app/app/modules/bottom_navigation_bar/controllers/bottom_navigation_bar_controller.dart';
import 'package:slectiv_studio_app/app/modules/transaction/controllers/transaction_controller.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';

class Upcoming extends StatelessWidget {
  const Upcoming({super.key});

  @override
  Widget build(BuildContext context) {
    final BookingController bookingController = Get.put(BookingController());
    final TransactionController transactionController = Get.put(
      TransactionController(),
    );

    return SafeArea(
      child: Obx(() {
        if (bookingController.bookings.isEmpty) {
          return const Center(
            child: Text(
              SlectivTexts.bookingNotHistory,
              style: TextStyle(fontSize: 16, color: SlectivColors.blackColor),
            ),
          );
        }

        List<Map<String, dynamic>> upcomingBookings =
            transactionController.getUpcomingBookings();

        if (upcomingBookings.isEmpty) {
          return const Center(
            child: Text(
              'No upcoming bookings',
              style: TextStyle(fontSize: 16, color: SlectivColors.blackColor),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          children: [
            const SizedBox(height: 8),
            ...upcomingBookings.map((booking) {
              return _buildBookingCard(
                transactionController,
                booking[SlectivTexts.bookingDate],
                booking[SlectivTexts.bookingDetails],
              );
            }),
          ],
        );
      }),
    );
  }

  Widget _buildBookingCard(
    TransactionController controller,
    String date,
    String bookingDetails,
  ) {
    List<String> details = bookingDetails.split('|');
    String time = details[0];
    String color = details[1];
    String person = details[2];
    String email = details.length > 3 ? details[3] : "";

    final BottomNavigationBarController bottomNavigationBarController = Get.put(
      BottomNavigationBarController(),
    );
    var role = bottomNavigationBarController.isUser.value;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main Container
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$date $time",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${SlectivTexts.bookingTitleTime} : $time",
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  "${SlectivTexts.bookingTitle3} : $color",
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  "${SlectivTexts.bookingTitle4} : $person",
                  style: const TextStyle(fontSize: 16),
                ),
                if (!role) // Show email only for admin
                  Text("Email : $email", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
              ],
            ),
          ),

          // Edit Button
          Positioned(
            right: 50,
            bottom: -15,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    SlectivColors.primaryBlue,
                    SlectivColors.secondaryBlue,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: SlectivColors.primaryBlue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap:
                      () => controller.showEditDialog(
                        date,
                        time,
                        color,
                        person,
                        email,
                      ),
                  child: const Icon(Icons.edit, size: 20, color: Colors.white),
                ),
              ),
            ),
          ),

          // Delete Button
          Positioned(
            right: 0,
            bottom: -15,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: SlectivColors.cancelAndNegatifSnackbarButtonColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: SlectivColors.cancelAndNegatifSnackbarButtonColor
                        .withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap:
                      () =>
                          controller.showDeleteConfirmation(date, time, email),
                  child: const Icon(
                    Icons.delete,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
