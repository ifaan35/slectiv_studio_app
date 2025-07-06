import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slectiv_studio_app/app/modules/gallery/controllers/gallery_controller.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'widgets/gallery_header.dart';
import 'widgets/gallery_introduction_card.dart';
import 'widgets/studio_history_section.dart';
import 'widgets/photo_gallery_section.dart';
import 'widgets/gallery_footer.dart';

class GalleryView extends GetView<GalleryController> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GalleryController());
    return Scaffold(
      backgroundColor: SlectivColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Section with Gradient
              const GalleryHeader(),

              // Content Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),

                    // Gallery Introduction Card
                    const GalleryIntroductionCard(),

                    const SizedBox(height: 32),

                    // Studio History Section
                    const StudioHistorySection(),

                    const SizedBox(height: 32),

                    // Photo Gallery Section
                    PhotoGallerySection(controller: controller),

                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // Footer
              const GalleryFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
