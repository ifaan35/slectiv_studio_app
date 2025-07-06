import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:slectiv_studio_app/app/modules/booking/controllers/booking_controller.dart';
import 'package:slectiv_studio_app/app/modules/booking/views/widgets/time_card.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';

class SlectivTimeReservation extends StatelessWidget {
  const SlectivTimeReservation({
    super.key,
    required this.controller,
    required this.now,
  });

  final BookingController controller;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedDay = controller.selectedDay.value;
      if (selectedDay.isBefore(DateTime(now.year, now.month, now.day))) {
        return const SizedBox();
      } else {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: SlectivColors.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.access_time,
                        color: SlectivColors.primaryBlue,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Available Time Slots',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: SlectivColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),

              // All Time Slots Container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: SlectivColors.primaryBlue.withOpacity(0.1),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: SlectivColors.primaryBlue.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(children: _buildTimeRows()),
              ),
            ],
          ),
        );
      }
    });
  }

  List<String> _getAllTimeSlots() {
    return [
      '10:00',
      '10:30',
      '11:00',
      '11:30',
      '12:00',
      '12:30',
      '14:00',
      '14:30',
      '15:00',
      '15:30',
      '16:00',
      '16:30',
      '17:00',
      '17:30',
      '18:00',
      '18:30',
      '19:00',
      '19:30',
      '20:00',
      '20:30',
      '21:00',
      '21:30',
      '22:00',
      '22:30',
      '23:00',
    ];
  }

  List<Widget> _buildTimeRows() {
    final timeSlots = _getAllTimeSlots();
    final rows = <Widget>[];

    for (int i = 0; i < timeSlots.length; i += 4) {
      final rowItems = <Widget>[];

      for (int j = 0; j < 4; j++) {
        if (i + j < timeSlots.length) {
          rowItems.add(
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: TimeCard(time: timeSlots[i + j]),
              ),
            ),
          );
        } else {
          // Fill empty spaces with invisible containers
          rowItems.add(const Expanded(child: SizedBox()));
        }
      }

      rows.add(Row(children: rowItems));

      // Add spacing between rows except for the last row
      if (i + 4 < timeSlots.length) {
        rows.add(const SizedBox(height: 4));
      }
    }

    return rows;
  }
}
