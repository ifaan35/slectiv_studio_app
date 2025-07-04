import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slectiv_studio_app/app/modules/home/views/widgets/Tab/potrait.dart';
import 'package:slectiv_studio_app/app/modules/home/views/widgets/Tab/photobooth.dart';
import 'package:slectiv_studio_app/app/modules/home/views/widgets/Tab/self_photo.dart';
import 'package:slectiv_studio_app/app/modules/home/views/widgets/Tab/wide_photobox.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';

class SlectivTabSection extends StatefulWidget {
  const SlectivTabSection({super.key});

  @override
  _TabSectionState createState() => _TabSectionState();
}

class _TabSectionState extends State<SlectivTabSection>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        // Modern Tab Bar with custom design
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: SlectivColors.lightBlueBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: SlectivColors.primaryBlue.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    SlectivColors.primaryBlue,
                    SlectivColors.secondaryBlue,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: SlectivColors.primaryBlue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              indicatorPadding: const EdgeInsets.all(4),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelPadding: const EdgeInsets.symmetric(
                horizontal: 4,
              ), // Increased padding
              labelColor: SlectivColors.whiteColor,
              unselectedLabelColor: SlectivColors.textGray,
              isScrollable: false,
              tabAlignment:
                  TabAlignment.fill, // Ensure tabs fill the available width
              tabs: [
                _buildModernTab(SlectivTexts.selfPhotoTitle),
                _buildModernTab(SlectivTexts.widePhotoboxTitle),
                _buildModernTab(SlectivTexts.photoboothTitle),
                _buildModernTab(SlectivTexts.potraitTitle),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Tab Content with modern container
        Container(
          height: 1250,
          decoration: BoxDecoration(
            color: SlectivColors.whiteColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                SlectivSelfPhoto(),
                SlectivWidePhotobox(),
                SlectivPhotobooth(),
                SlectivPortrait(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernTab(String title) {
    return Container(
      height: 64, // Increased height for better text visibility
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.spaceGrotesk(
              textStyle: const TextStyle(
                fontSize: 12, // Slightly increased font size
                fontWeight: FontWeight.w600,
                height: 1.2, // Better line height for readability
              ),
            ),
          ),
        ),
      ),
    );
  }
}
