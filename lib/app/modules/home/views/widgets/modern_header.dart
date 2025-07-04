import 'package:flutter/material.dart';
import 'package:slectiv_studio_app/app/modules/login_screen/views/widgets/authentication_header.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';

class ModernHeader extends StatelessWidget {
  const ModernHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            SlectivColors.lightBlueBackground,
            SlectivColors.whiteColor.withOpacity(0.9),
          ],
        ),
      ),
      child: const SlectivAuthenticationHeader(),
    );
  }
}
