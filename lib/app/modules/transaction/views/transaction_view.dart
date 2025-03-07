import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:slectiv_studio_app/app/modules/transaction/views/widgets/transaction_hearder.dart';
import 'package:slectiv_studio_app/app/modules/transaction/views/widgets/transaction_tab.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';

import '../controllers/transaction_controller.dart';

class TransactionView extends GetView<TransactionController> {
  const TransactionView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SlectivColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -- Header
                const SizedBox(height: 24),
                const SlectivTransactionHeader(),
                const SizedBox(height: 10),

                // -- Transaction tabbar
                const SizedBox(height: 10),
                const SlectivTransactionTabSection(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
