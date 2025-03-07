import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slectiv_studio_app/app/modules/booking/controllers/booking_controller.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';
import 'package:slectiv_studio_app/app/modules/profile/controllers/profile_controller.dart';

class Completed extends StatefulWidget {
  const Completed({super.key});

  @override
  _CompletedState createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  @override
  Widget build(BuildContext context) {
    final BookingController bookingController = Get.put(BookingController());
    final ProfileController profileController = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: SlectivColors.backgroundColor,

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
            List<String> sortedDates = bookingController.bookings.keys.toList();
            DateTime now = DateTime.now();

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

                    if (bookingTime.isBefore(now)) {
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
              padding: const EdgeInsets.symmetric(),
              children: [
                const SizedBox(height: 8),
                ...completedBookings.map((booking) {
                  return buildBookingList(
                    booking[SlectivTexts.bookingDate],
                    booking[SlectivTexts.bookingDetails],
                  );
                }),
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
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
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          ],
        ),
      ),
    );
  }
}
