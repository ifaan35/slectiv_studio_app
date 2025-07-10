import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminRefundController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var isLoading = false.obs;
  var pendingRefunds = <Map<String, dynamic>>[].obs;
  var processedRefunds = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    debugFetchAllRefunds(); // Debug first
    fetchPendingRefunds();
    fetchProcessedRefunds();
  }

  Future<void> fetchPendingRefunds() async {
    try {
      isLoading.value = true;

      // First try with orderBy, if fails, fallback to simple query
      QuerySnapshot snapshot;
      try {
        snapshot =
            await _firestore
                .collection('refunds')
                .where('status', isEqualTo: 'pending')
                .orderBy('createdAt', descending: true)
                .get();
      } catch (e) {
        print('OrderBy failed, using simple query: $e');
        // Fallback to simple query without orderBy
        snapshot =
            await _firestore
                .collection('refunds')
                .where('status', isEqualTo: 'pending')
                .get();
      }

      pendingRefunds.value =
          snapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return data;
          }).toList();

      // Sort manually if orderBy failed
      if (pendingRefunds.isNotEmpty) {
        pendingRefunds.sort((a, b) {
          final aTime = a['createdAt'];
          final bTime = b['createdAt'];
          if (aTime == null || bTime == null) return 0;

          try {
            final aTimestamp = aTime is DateTime ? aTime : aTime.toDate();
            final bTimestamp = bTime is DateTime ? bTime : bTime.toDate();
            return bTimestamp.compareTo(aTimestamp); // descending
          } catch (e) {
            return 0;
          }
        });
      }

      print('Fetched ${pendingRefunds.length} pending refunds');
    } catch (e) {
      print('Error fetching pending refunds: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch pending refunds: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProcessedRefunds() async {
    try {
      // First try with orderBy, if fails, fallback to simple query
      QuerySnapshot snapshot;
      try {
        snapshot =
            await _firestore
                .collection('refunds')
                .where(
                  'status',
                  whereIn: [
                    'approved',
                    'rejected',
                    'processed',
                    'auto_approved',
                  ],
                )
                .orderBy('processedAt', descending: true)
                .limit(20)
                .get();
      } catch (e) {
        print('OrderBy failed for processed refunds, using simple query: $e');
        // Fallback to simple query
        snapshot =
            await _firestore
                .collection('refunds')
                .where(
                  'status',
                  whereIn: [
                    'approved',
                    'rejected',
                    'processed',
                    'auto_approved',
                  ],
                )
                .limit(20)
                .get();
      }

      processedRefunds.value =
          snapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return data;
          }).toList();

      print('Fetched ${processedRefunds.length} processed refunds');
    } catch (e) {
      print('Error fetching processed refunds: $e');
    }
  }

  // Debug method to fetch all refunds
  Future<void> debugFetchAllRefunds() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('refunds').get();

      print('=== DEBUG: All Refunds ===');
      print('Total refunds in database: ${snapshot.docs.length}');

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        print('Refund ID: ${doc.id}');
        print('Status: ${data['status']}');
        print('Amount: ${data['refundAmount']}');
        print('User Email: ${data['userEmail']}');
        print('Created At: ${data['createdAt']}');
        print('---');
      }
      print('========================');
    } catch (e) {
      print('Error in debug fetch: $e');
    }
  }

  // Test method to create a dummy refund for testing
  Future<void> createTestRefund() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        print('No user logged in for test');
        return;
      }

      // Create a test refund
      DocumentReference refundRef = await _firestore.collection('refunds').add({
        'userId': currentUser.uid,
        'userEmail': currentUser.email,
        'bookingDetails': 'TEST|White Background|2 Person|${currentUser.email}',
        'refundPercentage': 100,
        'refundAmount': 50000.0,
        'status': 'pending',
        'refundType': 'bank_transfer',
        'createdAt': FieldValue.serverTimestamp(),
        'processedAt': null,
        'autoApproved': false,
        'approvalRequired': true,
        'reason': 'Test refund request for debugging',
      });

      print('=== TEST REFUND CREATED ===');
      print('Refund ID: ${refundRef.id}');
      print('Status: pending');
      print('Amount: 50000.0');
      print('User Email: ${currentUser.email}');
      print('========================');

      // Refresh the lists
      await fetchPendingRefunds();
      await fetchProcessedRefunds();

      Get.snackbar(
        'Test',
        'Test refund created successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error creating test refund: $e');
      Get.snackbar(
        'Error',
        'Failed to create test refund: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> approveRefund(
    String refundId,
    Map<String, dynamic> refundData,
  ) async {
    try {
      isLoading.value = true;

      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        Get.snackbar('Error', 'Admin not authenticated');
        return;
      }

      // Update refund status to approved
      await _firestore.collection('refunds').doc(refundId).update({
        'status': 'approved',
        'processedAt': FieldValue.serverTimestamp(),
        'processedBy': currentUser.uid,
        'adminNotes': 'Approved by admin',
      });

      // Update user's refund record
      if (refundData['userId'] != null) {
        QuerySnapshot userRefunds =
            await _firestore
                .collection('users')
                .doc(refundData['userId'])
                .collection('refunds')
                .where('refundAmount', isEqualTo: refundData['refundAmount'])
                .where('status', isEqualTo: 'pending')
                .get();

        for (DocumentSnapshot doc in userRefunds.docs) {
          await doc.reference.update({
            'status': 'approved',
            'processedAt': FieldValue.serverTimestamp(),
          });
        }
      }

      // IMPORTANT: Remove the original booking from the bookings collection
      await _removeApprovedBooking(refundData);

      print('=== BOOKING REMOVAL AFTER REFUND APPROVAL ===');
      print('Refund approved for booking: ${refundData['bookingDetails']}');
      print('User: ${refundData['userEmail']}');
      print('Attempting to remove booking from collection...');
      print('============================================');

      // Send notification to user (you can implement push notification here)
      await _sendRefundNotification(
        refundData['userId'],
        'approved',
        refundData['refundAmount'],
      );

      Get.snackbar(
        'Success',
        'Refund approved successfully. User will be notified.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Refresh lists
      await fetchPendingRefunds();
      await fetchProcessedRefunds();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to approve refund: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> rejectRefund(
    String refundId,
    Map<String, dynamic> refundData,
    String reason,
  ) async {
    try {
      isLoading.value = true;

      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        Get.snackbar('Error', 'Admin not authenticated');
        return;
      }

      // Update refund status to rejected
      await _firestore.collection('refunds').doc(refundId).update({
        'status': 'rejected',
        'processedAt': FieldValue.serverTimestamp(),
        'processedBy': currentUser.uid,
        'adminNotes': reason,
        'rejectionReason': reason,
      });

      // Update user's refund record
      if (refundData['userId'] != null) {
        QuerySnapshot userRefunds =
            await _firestore
                .collection('users')
                .doc(refundData['userId'])
                .collection('refunds')
                .where('refundAmount', isEqualTo: refundData['refundAmount'])
                .where('status', isEqualTo: 'pending')
                .get();

        for (DocumentSnapshot doc in userRefunds.docs) {
          await doc.reference.update({
            'status': 'rejected',
            'processedAt': FieldValue.serverTimestamp(),
            'rejectionReason': reason,
          });
        }
      }

      // Send notification to user
      await _sendRefundNotification(
        refundData['userId'],
        'rejected',
        refundData['refundAmount'],
        reason: reason,
      );

      Get.snackbar(
        'Success',
        'Refund rejected. User will be notified.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Refresh lists
      await fetchPendingRefunds();
      await fetchProcessedRefunds();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to reject refund: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _sendRefundNotification(
    String userId,
    String status,
    double amount, {
    String? reason,
  }) async {
    try {
      // Store notification in user's notifications collection
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .add({
            'type': 'refund_update',
            'title':
                status == 'approved' ? 'Refund Approved' : 'Refund Rejected',
            'message':
                status == 'approved'
                    ? 'Your refund of Rp ${amount.toStringAsFixed(0)} has been approved and will be processed within 3-5 business days.'
                    : 'Your refund request has been rejected. ${reason ?? ''}',
            'status': status,
            'amount': amount,
            'isRead': false,
            'createdAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  // Method to remove booking from bookings collection when refund is approved
  Future<void> _removeApprovedBooking(Map<String, dynamic> refundData) async {
    try {
      String bookingDetails = refundData['bookingDetails'] ?? '';
      String userEmail = refundData['userEmail'] ?? '';

      print('Attempting to remove booking: $bookingDetails');
      print('For user: $userEmail');

      if (bookingDetails.isEmpty || userEmail.isEmpty) {
        print('Missing booking details or user email, cannot remove booking');
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
      print('Error removing booking after refund approval: $e');
      // Don't throw error here as refund was already approved
      // This is a cleanup operation that shouldn't fail the main process
    }
  }

  String formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  String getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'orange';
      case 'approved':
        return 'green';
      case 'rejected':
        return 'red';
      case 'processed':
        return 'blue';
      default:
        return 'grey';
    }
  }

  Color getStatusColorValue(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'processed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
