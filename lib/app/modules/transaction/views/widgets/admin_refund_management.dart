import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:slectiv_studio_app/app/modules/transaction/controllers/admin_refund_controller.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';

class AdminRefundManagement extends StatelessWidget {
  const AdminRefundManagement({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminRefundController controller = Get.put(AdminRefundController());

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          // Header

          // Tab Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: TabBar(
              indicator: BoxDecoration(
                color: SlectivColors.primaryBlue,
                borderRadius: BorderRadius.circular(6),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[600],
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              tabs: [
                Obx(
                  () => Tab(
                    text: 'Pending (${controller.pendingRefunds.length})',
                  ),
                ),
                Obx(
                  () => Tab(
                    text: 'Processed (${controller.processedRefunds.length})',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Tab Views
          Expanded(
            child: TabBarView(
              children: [
                _buildPendingRefundsTab(controller),
                _buildProcessedRefundsTab(controller),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingRefundsTab(AdminRefundController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.pendingRefunds.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FluentIcons.checkmark_circle_24_regular,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No pending refunds',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.fetchPendingRefunds,
        child: ListView.builder(
          itemCount: controller.pendingRefunds.length,
          itemBuilder: (context, index) {
            final refund = controller.pendingRefunds[index];
            return _buildPendingRefundCard(controller, refund);
          },
        ),
      );
    });
  }

  Widget _buildProcessedRefundsTab(AdminRefundController controller) {
    return Obx(() {
      if (controller.processedRefunds.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FluentIcons.history_24_regular,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No processed refunds yet',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.fetchProcessedRefunds,
        child: ListView.builder(
          itemCount: controller.processedRefunds.length,
          itemBuilder: (context, index) {
            final refund = controller.processedRefunds[index];
            return _buildProcessedRefundCard(controller, refund);
          },
        ),
      );
    });
  }

  Widget _buildPendingRefundCard(
    AdminRefundController controller,
    Map<String, dynamic> refund,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3), width: 1),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      FluentIcons.clock_24_regular,
                      size: 16,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'PENDING APPROVAL',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange[700],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                _formatDate(refund['createdAt']),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Refund details
          _buildDetailRow('Customer Email', refund['userEmail'] ?? 'N/A'),
          _buildDetailRow('Booking Details', refund['bookingDetails'] ?? 'N/A'),
          _buildDetailRow(
            'Refund Percentage',
            '${refund['refundPercentage'] ?? 0}%',
          ),
          _buildDetailRow(
            'Refund Amount',
            controller.formatCurrency(refund['refundAmount']?.toDouble() ?? 0),
            isHighlight: true,
          ),
          _buildDetailRow(
            'Refund Type',
            refund['refundType'] ?? 'bank_transfer',
          ),

          const SizedBox(height: 16),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showRejectDialog(controller, refund),
                  icon: Icon(
                    FluentIcons.dismiss_24_regular,
                    size: 18,
                    color: Colors.red[600],
                  ),
                  label: Text(
                    'Reject',
                    style: TextStyle(color: Colors.red[600]),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red[600]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showApproveDialog(controller, refund),
                  icon: const Icon(
                    FluentIcons.checkmark_24_regular,
                    size: 18,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Approve',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProcessedRefundCard(
    AdminRefundController controller,
    Map<String, dynamic> refund,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: controller
              .getStatusColorValue(refund['status'] ?? 'unknown')
              .withOpacity(0.3),
          width: 1,
        ),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: controller
                      .getStatusColorValue(refund['status'] ?? 'unknown')
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  (refund['status'] ?? 'unknown').toString().toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: controller.getStatusColorValue(
                      refund['status'] ?? 'unknown',
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                _formatDate(refund['processedAt'] ?? refund['createdAt']),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Refund details
          _buildDetailRow('Customer Email', refund['userEmail'] ?? 'N/A'),
          _buildDetailRow('Booking Details', refund['bookingDetails'] ?? 'N/A'),
          _buildDetailRow(
            'Refund Amount',
            controller.formatCurrency(refund['refundAmount']?.toDouble() ?? 0),
            isHighlight: true,
          ),
          if (refund['adminNotes'] != null &&
              refund['adminNotes'].toString().isNotEmpty)
            _buildDetailRow('Admin Notes', refund['adminNotes']),
          if (refund['rejectionReason'] != null &&
              refund['rejectionReason'].toString().isNotEmpty)
            _buildDetailRow('Rejection Reason', refund['rejectionReason']),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isHighlight ? FontWeight.w600 : FontWeight.w400,
                color: isHighlight ? SlectivColors.primaryBlue : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showApproveDialog(
    AdminRefundController controller,
    Map<String, dynamic> refund,
  ) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(FluentIcons.checkmark_circle_24_regular, color: Colors.green),
            const SizedBox(width: 8),
            const Text('Approve Refund'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to approve this refund?'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Customer: ${refund['userEmail']}'),
                  Text(
                    'Amount: ${controller.formatCurrency(refund['refundAmount']?.toDouble() ?? 0)}',
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.approveRefund(refund['id'], refund);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Approve', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(
    AdminRefundController controller,
    Map<String, dynamic> refund,
  ) {
    final TextEditingController reasonController = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(FluentIcons.dismiss_circle_24_regular, color: Colors.red),
            const SizedBox(width: 8),
            const Text('Reject Refund'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Please provide a reason for rejecting this refund:'),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter rejection reason...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Customer: ${refund['userEmail']}'),
                  Text(
                    'Amount: ${controller.formatCurrency(refund['refundAmount']?.toDouble() ?? 0)}',
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.trim().isEmpty) {
                Get.snackbar('Error', 'Please provide a rejection reason');
                return;
              }
              Get.back();
              controller.rejectRefund(
                refund['id'],
                refund,
                reasonController.text.trim(),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reject', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'N/A';

    try {
      DateTime date;
      if (timestamp is DateTime) {
        date = timestamp;
      } else {
        date = timestamp.toDate();
      }
      return DateFormat('dd MMM yyyy, HH:mm').format(date);
    } catch (e) {
      return 'N/A';
    }
  }
}
