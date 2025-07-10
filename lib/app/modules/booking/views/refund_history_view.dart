import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';

class RefundHistoryView extends StatelessWidget {
  const RefundHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

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
          'Refund History',
          style: GoogleFonts.spaceGrotesk(
            textStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: SlectivColors.primaryBlue,
            ),
          ),
        ),
      ),
      body:
          currentUser == null
              ? const Center(child: Text('Please login to view refund history'))
              : StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(currentUser.uid)
                        .collection('refunds')
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: SlectivColors.primaryBlue,
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error loading refund history'),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FluentIcons.receipt_20_regular,
                            size: 64,
                            color: SlectivColors.primaryBlue.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No Refund History',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: SlectivColors.darkGrey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your refund history will appear here',
                            style: TextStyle(
                              fontSize: 14,
                              color: SlectivColors.darkGrey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final refund = snapshot.data!.docs[index];
                      final data = refund.data() as Map<String, dynamic>;

                      return _buildRefundCard(data);
                    },
                  );
                },
              ),
    );
  }

  Widget _buildRefundCard(Map<String, dynamic> refundData) {
    final String status = refundData['status'] ?? 'pending';
    final int percentage = refundData['refundPercentage'] ?? 0;
    final double amount = refundData['refundAmount']?.toDouble() ?? 0.0;
    final String bookingDetails = refundData['bookingDetails'] ?? '';
    final Timestamp? createdAt = refundData['createdAt'];

    Color statusColor = _getStatusColor(status);
    IconData statusIcon = _getStatusIcon(status);
    String statusText = _getStatusText(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, color: statusColor, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (createdAt != null)
                Text(
                  DateFormat('MMM dd, yyyy').format(createdAt.toDate()),
                  style: TextStyle(fontSize: 12, color: SlectivColors.darkGrey),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Refund amount
          Row(
            children: [
              Icon(
                FluentIcons.money_20_regular,
                color: SlectivColors.primaryBlue,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Refund Amount',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: SlectivColors.darkGrey,
                ),
              ),
              const Spacer(),
              Text(
                'Rp ${NumberFormat('#,###').format(amount)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: SlectivColors.dark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Refund percentage
          Row(
            children: [
              Icon(
                FluentIcons.calculator_20_regular,
                color: SlectivColors.primaryBlue,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Refund Rate',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: SlectivColors.darkGrey,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getPercentageColor(percentage).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$percentage%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _getPercentageColor(percentage),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Booking details
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: SlectivColors.lightBlueBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Original Booking',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: SlectivColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatBookingDetails(bookingDetails),
                  style: TextStyle(fontSize: 13, color: SlectivColors.darkGrey),
                ),
              ],
            ),
          ),

          // Processing info
          if (status == 'pending') ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    FluentIcons.clock_20_regular,
                    color: Colors.blue,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Refund will be processed within 3-5 business days',
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'processed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'processed':
        return FluentIcons.checkmark_circle_20_filled;
      case 'pending':
        return FluentIcons.clock_20_regular;
      case 'failed':
        return FluentIcons.dismiss_circle_20_filled;
      default:
        return FluentIcons.question_circle_20_regular;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'processed':
        return 'Processed';
      case 'pending':
        return 'Processing';
      case 'failed':
        return 'Failed';
      default:
        return 'Unknown';
    }
  }

  Color _getPercentageColor(int percentage) {
    if (percentage >= 100) return Colors.green;
    if (percentage >= 50) return Colors.orange;
    return Colors.red;
  }

  String _formatBookingDetails(String bookingDetails) {
    List<String> details = bookingDetails.split('|');
    if (details.length >= 3) {
      return '${details[0]} • ${details[1]} • ${details[2]} people';
    }
    return bookingDetails;
  }
}
