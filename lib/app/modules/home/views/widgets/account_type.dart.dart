import 'package:flutter/material.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';

class SlectivTypeAccount extends StatelessWidget {
  final Color? textColor;

  const SlectivTypeAccount({super.key, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      SlectivTexts.oldAccountType,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textColor ?? Colors.grey.shade600,
      ),
    );
  }
}
