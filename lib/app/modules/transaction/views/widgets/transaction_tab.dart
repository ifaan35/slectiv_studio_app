import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slectiv_studio_app/app/modules/transaction/views/widgets/completed.dart';
import 'package:slectiv_studio_app/app/modules/transaction/views/widgets/upcoming.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';

class SlectivTransactionTabSection extends StatefulWidget {
  const SlectivTransactionTabSection({super.key});

  @override
  _SlectivTransactionTabSectionState createState() =>
      _SlectivTransactionTabSectionState();
}

class _SlectivTransactionTabSectionState
    extends State<SlectivTransactionTabSection>
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
        SizedBox(
          width: double.infinity,
          height: 50,
          child: TabBar(
            controller: _tabController,
            labelColor: SlectivColors.blackColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: SlectivColors.blackColor,
            tabs: [
              Tab(
                child: Text(
                  SlectivTexts.transactionUpcoming,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  SlectivTexts.transactionCompleted,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: Get.height, // Sesuaikan tinggi konten tab
          child: TabBarView(
            controller: _tabController,
            children: const [Upcoming(), Completed()],
          ),
        ),
      ],
    );
  }
}
