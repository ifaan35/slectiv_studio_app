import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slectiv_studio_app/app/modules/booking/controllers/booking_controller.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';

class TimeCard extends StatelessWidget {
  final String time;

  const TimeCard({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>();

    return Obx(() {
      final isSelected = controller.selectedTime.value == time;
      final isBooked = controller.isTimeBooked(
        controller.selectedDay.value,
        time,
      );
      final isPassed = controller.isTimePassed(
        controller.selectedDay.value,
        time,
      );

      return GestureDetector(
        onTap: () {
          if (!isBooked && !isPassed) {
            controller.selectedTime.value = time;
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isBooked || isPassed ? Colors.grey : Colors.white,
            gradient:
                isSelected && !isBooked && !isPassed
                    ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        SlectivColors.primaryBlue,
                        SlectivColors.primaryBlue.withOpacity(0.8),
                      ],
                    )
                    : null,
            border: Border.all(
              color:
                  isSelected && !isBooked && !isPassed
                      ? SlectivColors.primaryBlue
                      : Colors.black,
              width: isSelected && !isBooked && !isPassed ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow:
                isSelected && !isBooked && !isPassed
                    ? [
                      BoxShadow(
                        color: SlectivColors.primaryBlue.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                    : null,
          ),
          child: Center(
            child: Text(
              time,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color:
                    isBooked || isPassed
                        ? Colors.white
                        : isSelected
                        ? Colors.white
                        : Colors.black,
              ),
            ),
          ),
        ),
      );
    });
  }
}
