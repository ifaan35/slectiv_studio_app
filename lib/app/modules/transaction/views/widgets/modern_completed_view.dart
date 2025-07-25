import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:slectiv_studio_app/app/modules/booking/controllers/booking_controller.dart';
import 'package:slectiv_studio_app/app/modules/bottom_navigation_bar/controllers/bottom_navigation_bar_controller.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';

class ModernCompletedView extends StatelessWidget {
  const ModernCompletedView({super.key});

  @override
  Widget build(BuildContext context) {
    final BookingController bookingController = Get.put(BookingController());

    return Obx(() {
      if (bookingController.bookings.isEmpty) {
        return _buildEmptyState(
          'No bookings found',
          'Start booking your sessions to see completed ones here',
        );
      }

      List<String> sortedDates = bookingController.bookings.keys.toList();
      DateTime now = DateTime.now();
      List<Map<String, dynamic>> completedBookings = [];

      for (String date in sortedDates) {
        DateTime parsedDate = DateTime.parse(date);
        List<String> bookings = bookingController.bookings[date] ?? [];

        for (String booking in bookings) {
          // Debug logging
          if (booking.isEmpty) {
            debugPrint("Empty booking found for date: $date");
            continue;
          }

          List<String> bookingDetails = booking.split('|');
          if (bookingDetails.isEmpty || bookingDetails.length < 4) {
            debugPrint("Invalid booking details for booking: '$booking'");
            continue;
          }

          String time = bookingDetails[0];
          String color = bookingDetails[1];
          String person = bookingDetails[2];
          // String email = bookingDetails[3]; // Not used in this validation

          // Skip if any critical data is empty
          if (time.isEmpty || color.isEmpty || person.isEmpty) {
            debugPrint("Missing critical data in booking: '$booking'");
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
              completedBookings.add({
                SlectivTexts.bookingDate: date,
                SlectivTexts.bookingDetails: booking,
              });
            }
          } catch (e) {
            debugPrint("Error parsing time '$time' in booking '$booking': $e");
          }
        }
      }

      // Sort by most recent first
      completedBookings.sort((a, b) {
        try {
          DateTime dateTimeA = DateTime.parse(a[SlectivTexts.bookingDate]);
          DateTime dateTimeB = DateTime.parse(b[SlectivTexts.bookingDate]);

          List<String> timePartsA = a[SlectivTexts.bookingDetails]
              .split('|')[0]
              .split(':');
          List<String> timePartsB = b[SlectivTexts.bookingDetails]
              .split('|')[0]
              .split(':');

          if (timePartsA.length != 2 || timePartsB.length != 2) {
            return dateTimeB.compareTo(dateTimeA);
          }

          DateTime timeA = DateTime(
            dateTimeA.year,
            dateTimeA.month,
            dateTimeA.day,
            int.parse(timePartsA[0]),
            int.parse(timePartsA[1]),
          );
          DateTime timeB = DateTime(
            dateTimeB.year,
            dateTimeB.month,
            dateTimeB.day,
            int.parse(timePartsB[0]),
            int.parse(timePartsB[1]),
          );
          return timeB.compareTo(timeA);
        } catch (e) {
          debugPrint("Error sorting bookings: $e");
          return 0;
        }
      });

      if (completedBookings.isEmpty) {
        return _buildEmptyState(
          'No completed bookings',
          'Your completed bookings will appear here',
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: completedBookings.length,
        itemBuilder: (context, index) {
          final booking = completedBookings[index];
          return _buildCompactCompletedCard(
            booking[SlectivTexts.bookingDate],
            booking[SlectivTexts.bookingDetails],
            index,
          );
        },
      );
    });
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: SlectivColors.lightBlueBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              FluentIcons.checkmark_circle_24_regular,
              size: 48,
              color: Colors.green.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactCompletedCard(
    String date,
    String bookingDetails,
    int index,
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

    // Parse date for better formatting
    DateTime parsedDate = DateTime.parse(date);
    String formattedDate =
        "${_getMonthName(parsedDate.month)} ${parsedDate.day}, ${parsedDate.year}";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          // Compact Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.green.shade600, Colors.green.shade500],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    FluentIcons.checkmark_circle_24_filled,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        FluentIcons.checkmark_24_filled,
                        color: Colors.green.shade600,
                        size: 10,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Completed',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Compact Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildCompactDetail(
                  FluentIcons.color_24_regular,
                  'Background',
                  color,
                  Colors.purple.shade600,
                ),
                const SizedBox(height: 8),
                _buildCompactDetail(
                  FluentIcons.people_24_regular,
                  'People',
                  person,
                  Colors.blue.shade600,
                ),
                if (!role && email.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildCompactDetail(
                    FluentIcons.mail_24_regular,
                    'Email',
                    email,
                    Colors.orange.shade600,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactDetail(
    IconData icon,
    String label,
    String value,
    Color iconColor,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
