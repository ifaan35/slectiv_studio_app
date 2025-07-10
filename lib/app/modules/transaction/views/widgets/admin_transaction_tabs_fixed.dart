import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:slectiv_studio_app/app/modules/transaction/views/widgets/modern_upcoming_view.dart';
import 'package:slectiv_studio_app/app/modules/transaction/views/widgets/modern_completed_view.dart';
import 'package:slectiv_studio_app/app/modules/transaction/views/widgets/admin_refund_management.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';

class AdminTransactionTabs extends StatefulWidget {
  const AdminTransactionTabs({super.key});

  @override
  State<AdminTransactionTabs> createState() => _AdminTransactionTabsState();
}

class _AdminTransactionTabsState extends State<AdminTransactionTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isAdmin = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance
                .collection('user')
                .doc(user.uid)
                .get();

        if (userDoc.exists) {
          String role =
              (userDoc.data() as Map<String, dynamic>)['role'] ?? 'user';
          setState(() {
            isAdmin = role == 'admin';
            isLoading = false;
          });
        }
      }

      // Initialize tab controller after role check
      _tabController = TabController(length: isAdmin ? 3 : 2, vsync: this);
    } catch (e) {
      setState(() {
        isLoading = false;
        isAdmin = false;
      });
      _tabController = TabController(length: 2, vsync: this);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Modern Tab Bar with Better Design
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 2),
                spreadRadius: 0,
              ),
            ],
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
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 1),
                  spreadRadius: 0,
                ),
              ],
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: SlectivColors.primaryBlue,
            unselectedLabelColor: Colors.grey.shade600,
            labelStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
            tabs: [
              Tab(
                height: 40,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(FluentIcons.clock_24_filled, size: 16),
                    const SizedBox(width: 4),
                    const Text('Upcoming'),
                  ],
                ),
              ),
              Tab(
                height: 40,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(FluentIcons.checkmark_circle_24_filled, size: 16),
                    const SizedBox(width: 4),
                    const Text('Completed'),
                  ],
                ),
              ),
              if (isAdmin)
                Tab(
                  height: 40,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(FluentIcons.money_24_regular, size: 16),
                      const SizedBox(width: 4),
                      const Text('Refunds'),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Tab Content
        SizedBox(
          height: Get.height * 0.6,
          child: TabBarView(
            controller: _tabController,
            children: [
              const ModernUpcomingView(),
              const ModernCompletedView(),
              if (isAdmin) const AdminRefundManagement(),
            ],
          ),
        ),
      ],
    );
  }
}
