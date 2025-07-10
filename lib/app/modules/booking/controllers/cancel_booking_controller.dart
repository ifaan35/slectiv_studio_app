import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/app/modules/booking/controllers/booking_controller.dart';

class CancelBookingController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var isProcessing = false.obs;

  Future<void> cancelBooking({
    required String bookingDate,
    required String bookingTime,
    required String bookingDetails,
  }) async {
    try {
      isProcessing.value = true;

      // Calculate refund amount
      final refundInfo = _calculateRefundInfo(bookingDate, bookingTime);

      // Remove booking from database
      await _removeBookingFromDatabase(bookingDate, bookingDetails);

      bool needsApproval = false;

      // Process refund if applicable
      if (refundInfo['percentage'] > 0) {
        double refundAmount = _calculateRefundAmountByPercentage(
          refundInfo['percentage'],
          bookingDetails,
        );
        needsApproval = _needsAdminApproval(
          refundAmount,
          refundInfo['percentage'],
        );
        await _processRefund(refundInfo['percentage'], bookingDetails);
      }

      // Show success message with approval info
      _showSuccessMessage(refundInfo, needsApproval: needsApproval);

      // Refresh booking list
      Get.find<BookingController>().fetchBookings();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to cancel booking. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> _removeBookingFromDatabase(
    String date,
    String bookingDetails,
  ) async {
    DocumentReference dateRef = _firestore.collection('booking').doc(date);
    DocumentSnapshot dateSnapshot = await dateRef.get();

    if (dateSnapshot.exists) {
      List<dynamic> bookings = dateSnapshot.data() as List<dynamic>? ?? [];
      bookings.removeWhere((booking) => booking == bookingDetails);

      if (bookings.isEmpty) {
        await dateRef.delete();
      } else {
        await dateRef.update({'bookings': bookings});
      }
    }
  }

  Future<void> _processRefund(int percentage, String bookingDetails) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return;

      // Calculate refund amount (assuming you have pricing logic)
      double refundAmount = _calculateRefundAmountByPercentage(
        percentage,
        bookingDetails,
      );

      // Determine if admin approval is needed
      // For example: refunds > 100k or certain conditions require admin approval
      String status =
          _needsAdminApproval(refundAmount, percentage)
              ? 'pending'
              : 'auto_approved';

      // Store refund record
      DocumentReference refundRef = await _firestore.collection('refunds').add({
        'userId': currentUser.uid,
        'userEmail': currentUser.email,
        'bookingDetails': bookingDetails,
        'refundPercentage': percentage,
        'refundAmount': refundAmount,
        'status': status,
        'refundType': 'bank_transfer', // bank_transfer, store_credit, cash
        'createdAt': FieldValue.serverTimestamp(),
        'processedAt':
            status == 'auto_approved' ? FieldValue.serverTimestamp() : null,
        'autoApproved': status == 'auto_approved',
        'approvalRequired': status == 'pending',
      });

      print('=== REFUND CREATED ===');
      print('Refund ID: ${refundRef.id}');
      print('Status: $status');
      print('Amount: $refundAmount');
      print('User Email: ${currentUser.email}');
      print('Needs Approval: ${status == 'pending'}');
      print('=====================');

      // If auto-approved, immediately remove the booking
      if (status == 'auto_approved') {
        await _removeBookingFromCollection(bookingDetails);
        print('Auto-approved refund: Booking removed from collection');
      }

      // Add to user's refund history
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('refunds')
          .add({
            'bookingDetails': bookingDetails,
            'refundPercentage': percentage,
            'refundAmount': refundAmount,
            'status': status,
            'createdAt': FieldValue.serverTimestamp(),
            'processedAt':
                status == 'auto_approved' ? FieldValue.serverTimestamp() : null,
          });
    } catch (e) {
      print('Error processing refund: $e');
    }
  }

  bool _needsAdminApproval(double refundAmount, int percentage) {
    // TEMPORARY: Force all refunds to need approval for testing
    print(
      'Checking approval need: amount=$refundAmount, percentage=$percentage',
    );

    // Define business rules for when admin approval is needed

    // Rule 1: Large amounts need approval
    if (refundAmount > 100000) {
      print('Approval needed: Large amount');
      return true;
    }

    // Rule 2: Full refunds always need approval for audit purposes
    if (percentage >= 100) {
      print('Approval needed: Full refund');
      return true;
    }

    // TEMPORARY: For testing, make all refunds need approval
    if (refundAmount > 0) {
      print('Approval needed: Testing mode');
      return true;
    }

    // Auto-approve smaller partial refunds
    print('Auto-approved: Small partial refund');
    return false;
  }

  double _calculateRefundAmountByPercentage(
    int percentage,
    String bookingDetails,
  ) {
    // Extract pricing from booking details or use default pricing
    // This is a simplified example - you should implement actual pricing logic
    Map<String, double> servicePrices = {
      'Self Photo': 50000,
      'Wide Photobox': 75000,
      'Photobooth': 30000,
    };

    // Parse booking details to get service type
    List<String> details = bookingDetails.split('|');
    String serviceType = details.length > 4 ? details[4] : 'Self Photo';

    double basePrice = servicePrices[serviceType] ?? 50000;
    return (basePrice * percentage) / 100;
  }

  Map<String, dynamic> _calculateRefundInfo(
    String bookingDate,
    String bookingTime,
  ) {
    try {
      DateTime bookingDateTime = DateTime.parse('$bookingDate $bookingTime:00');
      DateTime now = DateTime.now();
      Duration difference = bookingDateTime.difference(now);

      if (difference.inHours > 24) {
        return {'percentage': 100, 'message': 'Full refund processed'};
      } else if (difference.inHours > 12) {
        return {'percentage': 50, 'message': 'Partial refund processed'};
      } else {
        return {'percentage': 0, 'message': 'No refund applicable'};
      }
    } catch (e) {
      return {'percentage': 0, 'message': 'Error calculating refund'};
    }
  }

  void _showSuccessMessage(
    Map<String, dynamic> refundInfo, {
    bool needsApproval = false,
  }) {
    String message;

    if (refundInfo['percentage'] > 0) {
      if (needsApproval) {
        message =
            'Booking cancelled successfully! Your refund request has been submitted and is pending admin approval. You will be notified once processed.';
      } else {
        message =
            'Booking cancelled successfully! ${refundInfo['message']}. Refund will be processed within 3-5 business days.';
      }
    } else {
      message = 'Booking cancelled successfully. ${refundInfo['message']}.';
    }

    Get.snackbar(
      'Booking Cancelled',
      message,
      backgroundColor: SlectivColors.primary,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  // Method to check if booking can be cancelled
  bool canCancelBooking(String bookingDate, String bookingTime) {
    try {
      DateTime bookingDateTime = DateTime.parse('$bookingDate $bookingTime:00');
      DateTime now = DateTime.now();
      return bookingDateTime.isAfter(now);
    } catch (e) {
      return false;
    }
  }

  // Method to get refund policy info
  Map<String, dynamic> getRefundPolicyInfo(
    String bookingDate,
    String bookingTime,
  ) {
    try {
      DateTime bookingDateTime = DateTime.parse('$bookingDate $bookingTime:00');
      DateTime now = DateTime.now();
      Duration difference = bookingDateTime.difference(now);

      if (difference.inHours > 24) {
        return {
          'percentage': 100,
          'message':
              'Full refund available! Cancel more than 24 hours in advance.',
          'color': Colors.green,
          'icon': FluentIcons.checkmark_circle_24_filled,
        };
      } else if (difference.inHours > 12) {
        return {
          'percentage': 50,
          'message':
              'Partial refund available. 50% will be refunded to your account.',
          'color': Colors.orange,
          'icon': FluentIcons.warning_24_regular,
        };
      } else if (difference.inHours > 0) {
        return {
          'percentage': 0,
          'message':
              'No refund available. Cancellation is less than 12 hours before booking.',
          'color': Colors.red,
          'icon': FluentIcons.dismiss_circle_24_regular,
        };
      } else {
        return {
          'percentage': 0,
          'message': 'Booking time has passed. No refund available.',
          'color': Colors.grey,
          'icon': FluentIcons.clock_24_regular,
        };
      }
    } catch (e) {
      return {
        'percentage': 0,
        'message': 'Unable to calculate refund. Please contact support.',
        'color': Colors.grey,
        'icon': FluentIcons.error_circle_24_regular,
      };
    }
  }

  // Method to remove booking from bookings collection
  Future<void> _removeBookingFromCollection(String bookingDetails) async {
    try {
      print('Attempting to remove booking: $bookingDetails');

      if (bookingDetails.isEmpty) {
        print('Missing booking details, cannot remove booking');
        return;
      }

      // Parse booking details: "time|color|person|email"
      List<String> details = bookingDetails.split('|');
      if (details.length < 4) {
        print('Invalid booking details format: $bookingDetails');
        return;
      }

      String time = details[0];
      String color = details[1];
      String person = details[2];
      String email = details[3];

      // Query to find the exact booking document using correct field names
      QuerySnapshot bookingQuery =
          await _firestore
              .collection('bookings')
              .where('time', isEqualTo: time)
              .where('color', isEqualTo: color)
              .where('person', isEqualTo: person)
              .where('email', isEqualTo: email)
              .get();

      print('Found ${bookingQuery.docs.length} matching bookings to remove');

      // Remove all matching bookings (should typically be just 1)
      for (DocumentSnapshot doc in bookingQuery.docs) {
        await doc.reference.delete();
        print('Removed booking document: ${doc.id}');
      }

      if (bookingQuery.docs.isEmpty) {
        print(
          'No matching booking found to remove. Booking may have already been removed.',
        );
      } else {
        print('Successfully removed ${bookingQuery.docs.length} booking(s)');
      }
    } catch (e) {
      print('Error removing booking after cancellation: $e');
      // Don't throw error here as refund was already processed
      // This is a cleanup operation that shouldn't fail the main process
    }
  }
}
