import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/app/modules/booking/controllers/cancel_booking_controller.dart';

class CancelBookingDialog extends StatelessWidget {
  final String bookingDate;
  final String bookingTime;
  final String bookingDetails;
  final VoidCallback onConfirmCancel;

  const CancelBookingDialog({
    super.key,
    required this.bookingDate,
    required this.bookingTime,
    required this.bookingDetails,
    required this.onConfirmCancel,
  });

  @override
  Widget build(BuildContext context) {
    final CancelBookingController controller = Get.put(
      CancelBookingController(),
    );
    final refundInfo = controller.getRefundPolicyInfo(bookingDate, bookingTime);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                FluentIcons.warning_24_regular,
                color: Colors.orange,
                size: 30,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Cancel Booking',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: SlectivColors.dark,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Are you sure you want to cancel this booking?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: SlectivColors.darkGrey),
            ),

            const SizedBox(height: 20),

            // Booking Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: SlectivColors.lightBlueBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: SlectivColors.primary.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        FluentIcons.calendar_24_regular,
                        color: SlectivColors.primary,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$bookingDate • $bookingTime',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: SlectivColors.dark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    bookingDetails,
                    style: TextStyle(
                      fontSize: 13,
                      color: SlectivColors.darkGrey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Refund Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: refundInfo['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: refundInfo['color'].withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        refundInfo['icon'],
                        color: refundInfo['color'],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Refund Policy',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: refundInfo['color'],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    refundInfo['message'],
                    style: TextStyle(
                      fontSize: 13,
                      color: SlectivColors.darkGrey,
                    ),
                  ),
                  if (refundInfo['percentage'] > 0) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: refundInfo['color'],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${refundInfo['percentage']}% Refund',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: SlectivColors.darkGrey,
                      side: BorderSide(color: SlectivColors.lightGrey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Keep Booking',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(
                    () => ElevatedButton(
                      onPressed:
                          controller.isProcessing.value
                              ? null
                              : () async {
                                await controller.cancelBooking(
                                  bookingDate: bookingDate,
                                  bookingTime: bookingTime,
                                  bookingDetails: bookingDetails,
                                );
                                Get.back();
                                onConfirmCancel();
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child:
                          controller.isProcessing.value
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                              : const Text(
                                'Cancel Booking',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
