import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:slectiv_studio_app/app/modules/booking/controllers/booking_controller.dart';
import 'package:slectiv_studio_app/app/modules/transaction/controllers/transaction_controller.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';

class ModernTransactionStats extends StatelessWidget {
  const ModernTransactionStats({super.key});

  @override
  Widget build(BuildContext context) {
    final BookingController bookingController = Get.put(BookingController());
    final TransactionController transactionController = Get.put(
      TransactionController(),
    );

    return Obx(() {
      // Calculate stats
      int totalBookings = _getTotalBookings(bookingController);
      int upcomingCount = transactionController.getUpcomingBookings().length;
      int completedCount = _getCompletedBookings(bookingController);

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: FluentIcons.calendar_24_filled,
                title: 'Total',
                value: totalBookings.toString(),
                color: SlectivColors.primaryBlue,
                subtitle: 'All Bookings',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: FluentIcons.clock_24_filled,
                title: 'Upcoming',
                value: upcomingCount.toString(),
                color: Colors.orange,
                subtitle: 'Pending',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: FluentIcons.checkmark_circle_24_filled,
                title: 'Completed',
                value: completedCount.toString(),
                color: Colors.green,
                subtitle: 'Done',
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.1), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color.withOpacity(0.15), color.withOpacity(0.08)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  int _getTotalBookings(BookingController bookingController) {
    int total = 0;
    for (String date in bookingController.bookings.keys) {
      List<String> bookings = bookingController.bookings[date] ?? [];
      total += bookings.length;
    }
    return total;
  }

  int _getCompletedBookings(BookingController bookingController) {
    int completed = 0;
    DateTime now = DateTime.now();

    for (String date in bookingController.bookings.keys) {
      DateTime parsedDate = DateTime.parse(date);
      List<String> bookings = bookingController.bookings[date] ?? [];

      for (String booking in bookings) {
        // Debug logging
        if (booking.isEmpty) {
          debugPrint("Empty booking found for date: $date");
          continue;
        }

        List<String> bookingDetails = booking.split('|');
        if (bookingDetails.isEmpty) {
          debugPrint("Empty booking details for booking: '$booking'");
          continue;
        }

        String time = bookingDetails[0];
        if (time.isEmpty) {
          debugPrint("Empty time in booking: '$booking'");
          continue;
        }

        try {
          List<String> timeParts = time.split(':');
          if (timeParts.length != 2) {
            debugPrint("Invalid time format '$time' in booking: '$booking'");
            continue;
          }

          int hour = int.parse(timeParts[0]);
          int minute = int.parse(timeParts[1]);

          DateTime bookingTime = DateTime(
            parsedDate.year,
            parsedDate.month,
            parsedDate.day,
            hour,
            minute,
          );

          if (bookingTime.isBefore(now)) {
            completed++;
          }
        } catch (e) {
          debugPrint("Error parsing time '$time' in booking '$booking': $e");
        }
      }
    }
    return completed;
  }
}
