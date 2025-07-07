import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slectiv_studio_app/app/modules/transaction/views/widgets/modern_transaction_header.dart';
import 'package:slectiv_studio_app/app/modules/transaction/views/widgets/modern_transaction_stats.dart';
import 'package:slectiv_studio_app/app/modules/transaction/views/widgets/modern_transaction_tabs.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import '../controllers/transaction_controller.dart';

class TransactionView extends GetView<TransactionController> {
  const TransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SlectivColors.lightBlueBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Modern Header
              const ModernTransactionHeader(),
              const SizedBox(height: 24),

              // Statistics Cards
              const ModernTransactionStats(),
              const SizedBox(height: 24),

              // Modern Tabs with Content
              const ModernTransactionTabs(),
            ],
          ),
        ),
      ),
    );
  }
}
