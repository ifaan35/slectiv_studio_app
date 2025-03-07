import 'package:flutter/material.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';

class SlectivTransactionHeader extends StatelessWidget {
  const SlectivTransactionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      SlectivTexts.transactionTitle,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: SlectivColors.blackColor,
      ),
    );
  }
}
