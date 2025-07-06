import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:slectiv_studio_app/app/modules/booking/controllers/booking_controller.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class SlectivCalendarReservation extends StatelessWidget {
  const SlectivCalendarReservation({
    super.key,
    required this.controller,
    required this.now,
  });

  final BookingController controller;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    DateTime lastDay = DateTime.utc(2026, 12, 31);
    DateTime firstDay =
        now.isBefore(lastDay) ? now : lastDay.subtract(const Duration(days: 1));

    return Obx(
      () => TableCalendar(
        focusedDay:
            controller.focusedDay.value.isBefore(lastDay)
                ? controller.focusedDay.value
                : lastDay,
        firstDay: firstDay,
        lastDay: lastDay,
        selectedDayPredicate: (day) {
          return isSameDay(controller.selectedDay.value, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (selectedDay.isAfter(
            DateTime.now().subtract(const Duration(days: 1)),
          )) {
            controller.selectedDay.value = selectedDay;
            controller.focusedDay.value =
                focusedDay.isBefore(lastDay) ? focusedDay : lastDay;
            controller.selectedTime.value = '';
          }
        },
        enabledDayPredicate: (day) {
          return day.isAfter(DateTime.now().subtract(const Duration(days: 1)));
        },
        calendarStyle: CalendarStyle(
          // Modern styling for today
          todayTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          todayDecoration: BoxDecoration(
            color: SlectivColors.secondaryBlue,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: SlectivColors.secondaryBlue.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),

          // Default day styling
          defaultTextStyle: const TextStyle(
            color: SlectivColors.blackColor,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          defaultDecoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),

          // Weekend styling
          weekendTextStyle: TextStyle(
            color: SlectivColors.textGray,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          weekendDecoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),

          // Outside month styling
          outsideTextStyle: TextStyle(
            color: SlectivColors.textGray.withOpacity(0.4),
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),

          // Selected day styling - modern blue theme
          selectedTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          selectedDecoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [SlectivColors.primaryBlue, SlectivColors.secondaryBlue],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: SlectivColors.primaryBlue.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          // Modern cell padding
          cellPadding: const EdgeInsets.all(6),
          cellMargin: const EdgeInsets.all(2),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          // Modern header styling
          weekendStyle: TextStyle(
            color: SlectivColors.primaryBlue,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          weekdayStyle: TextStyle(
            color: SlectivColors.blackColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          leftChevronVisible: true,
          rightChevronVisible: true,
          // Modern header styling
          titleTextStyle: TextStyle(
            color: SlectivColors.blackColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: SlectivColors.primaryBlue,
            size: 28,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: SlectivColors.primaryBlue,
            size: 28,
          ),
          headerPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onFormatChanged: (format) {},
        onPageChanged: (focusedDay) {
          controller.focusedDay.value =
              focusedDay.isBefore(lastDay) ? focusedDay : lastDay;
        },
        calendarBuilders: CalendarBuilders(
          // Modern available days
          defaultBuilder: (context, day, focusedDay) {
            if (day.isBefore(DateTime.now())) {
              return null; // Let default styling handle past days
            } else {
              return Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: SlectivColors.lightBlueBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: SlectivColors.primaryBlue.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: SlectivColors.blackColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }
          },

          // Modern today styling
          todayBuilder: (context, day, focusedDay) {
            return Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: SlectivColors.secondaryBlue,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: SlectivColors.secondaryBlue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '${day.day}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          },

          // Modern selected day styling
          selectedBuilder: (context, day, focusedDay) {
            return Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    SlectivColors.primaryBlue,
                    SlectivColors.secondaryBlue,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: SlectivColors.primaryBlue.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '${day.day}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          },

          // Disabled days (past dates)
          disabledBuilder: (context, day, focusedDay) {
            return Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '${day.day}',
                  style: TextStyle(
                    color: Colors.grey.withOpacity(0.4),
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
