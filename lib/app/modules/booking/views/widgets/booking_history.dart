import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:slectiv_studio_app/app/modules/booking/controllers/booking_controller.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';
import 'package:slectiv_studio_app/app/modules/profile/controllers/profile_controller.dart';

class SlectivBookingHistory extends StatefulWidget {
  const SlectivBookingHistory({super.key});

  @override
  _SlectivBookingHistoryState createState() => _SlectivBookingHistoryState();
}

class _SlectivBookingHistoryState extends State<SlectivBookingHistory> {
  bool showMoreUpcoming = false;
  bool showMoreCompleted = false;

  @override
  Widget build(BuildContext context) {
    final BookingController bookingController = Get.put(BookingController());
    final ProfileController profileController = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: SlectivColors.backgroundColor,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              FluentIcons.arrow_left_20_regular,
              size: 25,
              color: SlectivColors.primaryBlue,
            ),
          ),
        ),
        backgroundColor: SlectivColors.backgroundColor,
        title: Text(
          SlectivTexts.bookingHistoryTitle,
          style: GoogleFonts.spaceGrotesk(
            textStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: SlectivColors.primaryBlue,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (bookingController.bookings.isEmpty) {
            return const Center(
              child: Text(
                SlectivTexts.bookingNotHistory,
                style: TextStyle(fontSize: 16, color: SlectivColors.blackColor),
              ),
            );
          } else {
            String userEmail = profileController.email.value;
            print("${SlectivTexts.bookingUserEmail} $userEmail");
            List<String> sortedDates = bookingController.bookings.keys.toList();
            DateTime now = DateTime.now();

            List<Map<String, dynamic>> upcomingBookings = [];
            List<Map<String, dynamic>> completedBookings = [];

            for (String date in sortedDates) {
              DateTime parsedDate = DateTime.parse(date);
              List<String> bookings = bookingController.bookings[date] ?? [];
              for (String booking in bookings) {
                List<String> bookingDetails = booking.split('|');
                String email = bookingDetails[3];

                if (email == userEmail) {
                  String time = bookingDetails[0];
                  try {
                    DateTime bookingTime = DateTime(
                      parsedDate.year,
                      parsedDate.month,
                      parsedDate.day,
                      int.parse(time.split(':')[0]),
                      int.parse(time.split(':')[1]),
                    );

                    if (bookingTime.isAfter(now)) {
                      upcomingBookings.add({
                        SlectivTexts.bookingDate: date,
                        SlectivTexts.bookingDetails: booking,
                      });
                    } else {
                      completedBookings.add({
                        SlectivTexts.bookingDate: date,
                        SlectivTexts.bookingDetails: booking,
                      });
                    }
                  } catch (e) {
                    print("Error parsing time: $time");
                  }
                }
              }
            }

            print("${SlectivTexts.bookingUpcoming}: $upcomingBookings");
            print("${SlectivTexts.bookingCompleted}: $completedBookings");

            upcomingBookings.sort((a, b) {
              DateTime dateTimeA = DateTime.parse(a[SlectivTexts.bookingDate]);
              DateTime dateTimeB = DateTime.parse(b[SlectivTexts.bookingDate]);
              DateTime timeA = DateTime(
                dateTimeA.year,
                dateTimeA.month,
                dateTimeA.day,
                int.parse(
                  a[SlectivTexts.bookingDetails].split('|')[0].split(':')[0],
                ),
                int.parse(
                  a[SlectivTexts.bookingDetails].split('|')[0].split(':')[1],
                ),
              );
              DateTime timeB = DateTime(
                dateTimeB.year,
                dateTimeB.month,
                dateTimeB.day,
                int.parse(
                  b[SlectivTexts.bookingDetails].split('|')[0].split(':')[0],
                ),
                int.parse(
                  b[SlectivTexts.bookingDetails].split('|')[0].split(':')[1],
                ),
              );
              return timeA.compareTo(timeB);
            });

            completedBookings.sort((a, b) {
              DateTime dateTimeA = DateTime.parse(a[SlectivTexts.bookingDate]);
              DateTime dateTimeB = DateTime.parse(b[SlectivTexts.bookingDate]);
              DateTime timeA = DateTime(
                dateTimeA.year,
                dateTimeA.month,
                dateTimeA.day,
                int.parse(
                  a[SlectivTexts.bookingDetails].split('|')[0].split(':')[0],
                ),
                int.parse(
                  a[SlectivTexts.bookingDetails].split('|')[0].split(':')[1],
                ),
              );
              DateTime timeB = DateTime(
                dateTimeB.year,
                dateTimeB.month,
                dateTimeB.day,
                int.parse(
                  b[SlectivTexts.bookingDetails].split('|')[0].split(':')[0],
                ),
                int.parse(
                  b[SlectivTexts.bookingDetails].split('|')[0].split(':')[1],
                ),
              );
              return timeB.compareTo(timeA);
            });

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              children: [
                // Upcoming Section Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: SlectivColors.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        FluentIcons.calendar_clock_20_regular,
                        color: SlectivColors.primaryBlue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        SlectivTexts.bookingUpcoming,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: SlectivColors.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ...upcomingBookings
                    .take(showMoreUpcoming ? upcomingBookings.length : 3)
                    .map((booking) {
                      return buildBookingList(
                        booking[SlectivTexts.bookingDate],
                        booking[SlectivTexts.bookingDetails],
                      );
                    }),
                if (upcomingBookings.length > 3)
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: TextButton.icon(
                        onPressed: () {
                          setState(() {
                            showMoreUpcoming = !showMoreUpcoming;
                          });
                        },
                        icon: Icon(
                          showMoreUpcoming
                              ? FluentIcons.chevron_up_20_regular
                              : FluentIcons.chevron_down_20_regular,
                          color: SlectivColors.primaryBlue,
                          size: 16,
                        ),
                        label: Text(
                          showMoreUpcoming
                              ? SlectivTexts.bookingShowLess
                              : SlectivTexts.bookingShowMore,
                          style: TextStyle(
                            color: SlectivColors.primaryBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                // Completed Section Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        FluentIcons.checkmark_circle_20_regular,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        SlectivTexts.bookingCompleted,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ...completedBookings
                    .take(showMoreCompleted ? completedBookings.length : 3)
                    .map((booking) {
                      return buildBookingList(
                        booking[SlectivTexts.bookingDate],
                        booking[SlectivTexts.bookingDetails],
                      );
                    }),
                if (completedBookings.length > 3)
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: TextButton.icon(
                        onPressed: () {
                          setState(() {
                            showMoreCompleted = !showMoreCompleted;
                          });
                        },
                        icon: Icon(
                          showMoreCompleted
                              ? FluentIcons.chevron_up_20_regular
                              : FluentIcons.chevron_down_20_regular,
                          color: Colors.grey[600],
                          size: 16,
                        ),
                        label: Text(
                          showMoreCompleted
                              ? SlectivTexts.bookingShowLess
                              : SlectivTexts.bookingShowMore,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }
        }),
      ),
    );
  }

  Widget buildBookingList(String date, String bookingDetails) {
    List<String> details = bookingDetails.split('|');
    String time = details[0];
    String color = details[1];
    String person = details[2];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: SlectivColors.primaryBlue.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: SlectivColors.primaryBlue.withOpacity(0.08),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with date and time
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: SlectivColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    FluentIcons.calendar_20_regular,
                    color: SlectivColors.primaryBlue,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "$date • $time",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: SlectivColors.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Booking details
            _buildDetailRow(
              FluentIcons.clock_20_regular,
              SlectivTexts.bookingTitleTime,
              time,
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              FluentIcons.color_20_regular,
              SlectivTexts.bookingTitle3,
              color,
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              FluentIcons.people_20_regular,
              SlectivTexts.bookingTitle4,
              person,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: SlectivColors.primaryBlue.withOpacity(0.7), size: 18),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: SlectivColors.blackColor,
            ),
          ),
        ),
      ],
    );
  }
}
