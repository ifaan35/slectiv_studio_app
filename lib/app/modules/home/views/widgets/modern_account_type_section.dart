import 'package:flutter/material.dart';
import 'package:slectiv_studio_app/app/modules/home/views/widgets/account_type.dart.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';

class ModernAccountTypeSection extends StatelessWidget {
  const ModernAccountTypeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: SlectivColors.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.account_circle_outlined,
              color: SlectivColors.primaryBlue,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(child: SlectivTypeAccount()),
        ],
      ),
    );
  }
}
