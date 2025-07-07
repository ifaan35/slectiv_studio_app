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
        padding: const EdgeInsets.only(bottom: 20),
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
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with date and status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  SlectivColors.primaryBlue.withOpacity(0.8),
                  SlectivColors.secondaryBlue.withOpacity(0.8),
                ],
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
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    FluentIcons.calendar_24_filled,
                    color: Colors.white,
                    size: 20,
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
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        dayOfWeek,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.orange.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        FluentIcons.clock_24_filled,
                        color: Colors.orange,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Upcoming',
                        style: TextStyle(
                          color: Colors.orange.shade700,
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

          // Booking details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDetailRow(
                  FluentIcons.clock_24_regular,
                  'Time',
                  time,
                  SlectivColors.primaryBlue,
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  FluentIcons.color_24_regular,
                  'Background',
                  color,
                  Colors.purple,
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  FluentIcons.people_24_regular,
                  'People',
                  person,
                  Colors.green,
                ),
                if (!role && email.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    FluentIcons.mail_24_regular,
                    'Email',
                    email,
                    Colors.orange,
                  ),
                ],
                const SizedBox(height: 20),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
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
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionButton(
                        icon: FluentIcons.delete_24_regular,
                        label: 'Cancel',
                        color:
                            SlectivColors.cancelAndNegatifSnackbarButtonColor,
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

  Widget _buildDetailRow(
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
              const SizedBox(height: 2),
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

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
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
