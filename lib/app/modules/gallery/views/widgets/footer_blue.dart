import 'package:flutter/material.dart';
import 'package:slectiv_studio_app/utils/constants/image_strings.dart';

class SlectivFooterBlue2 extends StatelessWidget {
  const SlectivFooterBlue2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          SizedBox(
            height: 45.22,
            width: 120,
            child: Image(
              image: AssetImage(SlectivImages.applogoBlue2),
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
