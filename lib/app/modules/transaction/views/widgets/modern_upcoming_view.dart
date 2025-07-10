import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:slectiv_studio_app/app/modules/booking/controllers/booking_controller.dart';
import 'package:slectiv_studio_app/app/modules/bottom_navigation_bar/controllers/bottom_navigation_bar_controller.dart';
import 'package:slectiv_studio_app/app/modules/transaction/controllers/transaction_controller.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';

class ModernUpcomingView extends StatelessWidget {
  const ModernUpcomingView({super.key});

  @override
  Widget build(BuildContext context) {
    final BookingController bookingController = Get.put(BookingController());
    final TransactionController transactionController = Get.put(
      TransactionController(),
    );

    return Obx(() {
      if (bookingController.bookings.isEmpty) {
        return _buildEmptyState(
          'No bookings found',
          'Start booking your sessions to see them here',
        );
      }

      List<Map<String, dynamic>> upcomingBookings =
          transactionController.getUpcomingBookings();

      if (upcomingBookings.isEmpty) {
        return _buildEmptyState(
          'No upcoming bookings',
          'All your bookings are completed or expired',
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: upcomingBookings.length,
        itemBuilder: (context, index) {
          final booking = upcomingBookings[index];
          return _buildModernBookingCard(
            transactionController,
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
              FluentIcons.calendar_empty_24_regular,
              size: 48,
              color: SlectivColors.primaryBlue.withOpacity(0.7),
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

  Widget _buildModernBookingCard(
    TransactionController controller,
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

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: SlectivColors.primaryBlue.withOpacity(0.06),
            blurRadius: 12,
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
                colors: [
                  SlectivColors.primaryBlue,
                  SlectivColors.primaryBlue.withOpacity(0.8),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  FluentIcons.calendar_24_filled,
                  color: Colors.white,
                  size: 20,
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
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        dayOfWeek,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
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
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Upcoming',
                    style: TextStyle(
                      color: Colors.orange.shade700,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Compact booking details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildCompactDetail(FluentIcons.clock_24_regular, time),
                    const SizedBox(width: 16),
                    _buildCompactDetail(FluentIcons.color_24_regular, color),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildCompactDetail(FluentIcons.people_24_regular, person),
                    if (!role && email.isNotEmpty) ...[
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildCompactDetail(
                          FluentIcons.mail_24_regular,
                          email,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),

                // Compact Action buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildCompactButton(
                        icon: FluentIcons.edit_24_regular,
                        label: 'Edit',
                        color: SlectivColors.primaryBlue,
                        onTap:
                            () => controller.showEditDialog(
                              date,
                              time,
                              color,
                              person,
                              email,
                            ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildCompactButton(
                        icon: FluentIcons.delete_24_regular,
                        label: 'Cancel',
                        color: Colors.red.shade500,
                        onTap:
                            () => controller.showDeleteConfirmation(
                              date,
                              time,
                              email,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactDetail(IconData icon, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: SlectivColors.primaryBlue, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
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
}
