import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:slectiv_studio_app/app/modules/booking/controllers/booking_controller.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';

class SlectivColorDropdown extends StatelessWidget {
  const SlectivColorDropdown({super.key, required this.controller});

  final BookingController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(
        () => Container(
          width: double.infinity,
          height: 48.65,
          decoration: BoxDecoration(
            color: SlectivColors.primaryBlue.withOpacity(0.05),
            border: Border.all(
              color: SlectivColors.primaryBlue.withOpacity(0.3),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: SlectivColors.primaryBlue.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            underline: const SizedBox(), // Remove default underline
            dropdownColor: SlectivColors.whiteColor,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: SlectivColors.primaryBlue,
            ),
            hint: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                SlectivTexts.selectAnOption,
                style: TextStyle(
                  color: SlectivColors.primaryBlue.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ),
            value:
                controller.selectedOption.value.isEmpty
                    ? null
                    : controller.selectedOption.value,
            onChanged: (String? newValue) {
              controller.selectedOption.value = newValue!;
            },
            items:
                <String>[
                  'White Background',
                  'Dark Grey Background',
                  'Sage Background',
                  'Wide Blue',
                  'Spotlight',
                  'American Yearbook',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        value,
                        style: TextStyle(
                          color: SlectivColors.primaryBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }
}
