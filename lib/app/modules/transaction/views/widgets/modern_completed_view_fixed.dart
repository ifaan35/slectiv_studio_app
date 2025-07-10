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
        padding: const EdgeInsets.only(bottom: 20),
        itemCount: completedBookings.length,
        itemBuilder: (context, index) {
          final booking = completedBookings[index];
          return _buildModernCompletedCard(
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

  Widget _buildModernCompletedCard(
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
    String dayOfWeek = _getDayOfWeek(parsedDate.weekday);

    // Calculate time ago
    DateTime? bookingTime;
    String timeAgo = 'Unknown';

    try {
      List<String> timeParts = time.split(':');
      if (timeParts.length == 2) {
        int hour = int.parse(timeParts[0]);
        int minute = int.parse(timeParts[1]);

        bookingTime = DateTime(
          parsedDate.year,
          parsedDate.month,
          parsedDate.day,
          hour,
          minute,
        );
        timeAgo = _getTimeAgo(bookingTime);
      }
    } catch (e) {
      debugPrint("Error parsing time '$time': $e");
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.08),
            blurRadius: 24,
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
          // Enhanced Header with completed status
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.green.shade600, Colors.green.shade500],
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
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    FluentIcons.checkmark_circle_24_filled,
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
                        formattedDate,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$dayOfWeek • $timeAgo',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        FluentIcons.checkmark_24_filled,
                        color: Colors.green.shade600,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Completed',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Enhanced Booking details
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildDetailRow(
                  FluentIcons.clock_24_regular,
                  'Time',
                  time,
                  Colors.green.shade600,
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  FluentIcons.color_24_regular,
                  'Background',
                  color,
                  Colors.purple.shade600,
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  FluentIcons.people_24_regular,
                  'People',
                  person,
                  Colors.blue.shade600,
                ),
                if (!role && email.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    FluentIcons.mail_24_regular,
                    'Email',
                    email,
                    Colors.orange.shade600,
                  ),
                ],
                const SizedBox(height: 20),

                // Session completed indicator
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.green.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        FluentIcons.star_24_filled,
                        color: Colors.amber.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Session completed successfully',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconColor.withOpacity(0.1), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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

  String _getDayOfWeek(int day) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[day - 1];
  }

  String _getTimeAgo(DateTime bookingTime) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(bookingTime);

    if (difference.inDays > 30) {
      int months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else {
      return 'Recently';
    }
  }
}
