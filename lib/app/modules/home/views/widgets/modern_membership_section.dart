import 'package:flutter/material.dart';
import 'package:slectiv_studio_app/app/modules/home/views/widgets/membership_banner.dart';

class ModernMembershipSection extends StatelessWidget {
  const ModernMembershipSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: const SlectivMembershipBanner(),
      ),
    );
  }
}
