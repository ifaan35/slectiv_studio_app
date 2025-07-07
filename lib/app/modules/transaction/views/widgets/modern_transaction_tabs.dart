import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slectiv_studio_app/app/modules/transaction/views/widgets/modern_upcoming_view.dart';
import 'package:slectiv_studio_app/app/modules/transaction/views/widgets/modern_completed_view.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';

class ModernTransactionTabs extends StatefulWidget {
  const ModernTransactionTabs({super.key});

  @override
  State<ModernTransactionTabs> createState() => _ModernTransactionTabsState();
}

class _ModernTransactionTabsState extends State<ModernTransactionTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Modern Tab Bar
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: SlectivColors.lightBlueBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: SlectivColors.primaryBlue.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: SlectivColors.primaryBlue.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            labelColor: SlectivColors.primaryBlue,
            unselectedLabelColor: Colors.grey.shade600,
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(
                height: 44,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.schedule, size: 18),
                    SizedBox(width: 8),
                    Text(SlectivTexts.transactionUpcoming),
                  ],
                ),
              ),
              Tab(
                height: 44,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, size: 18),
                    SizedBox(width: 8),
                    Text(SlectivTexts.transactionCompleted),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Tab Content
        SizedBox(
          height: Get.height * 0.6, // Sesuaikan dengan kebutuhan
          child: TabBarView(
            controller: _tabController,
            children: [ModernUpcomingView(), ModernCompletedView()],
          ),
        ),
      ],
    );
  }
}
