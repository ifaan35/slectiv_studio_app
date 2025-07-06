import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slectiv_studio_app/app/modules/gallery/controllers/gallery_controller.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'slide_image.dart';
import 'empty_gallery.dart';

class PhotoGallerySection extends StatelessWidget {
  final GalleryController controller;

  const PhotoGallerySection({Key? key, required this.controller})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: SlectivColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.collections_rounded,
                color: SlectivColors.primaryBlue,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Photo Gallery",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: SlectivColors.titleColor,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Text(
          "Discover our stunning photography collections",
          style: GoogleFonts.spaceGrotesk(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: SlectivColors.textGray,
          ),
        ),

        const SizedBox(height: 24),

        // Auto-sliding Photo Gallery
        Obx(() {
          if (controller.imageList.isEmpty) {
            return const EmptyGallery();
          }

          return Column(
            children: [
              // Main Sliding Gallery
              Container(
                height: 470,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // PageView for sliding images
                      PageView.builder(
                        controller: controller.pageController,
                        onPageChanged: controller.onPageChanged,
                        itemCount: controller.virtualItemCount,
                        itemBuilder: (context, virtualIndex) {
                          final imagePath = controller.getImagePath(
                            virtualIndex,
                          );
                          final realIndex =
                              virtualIndex % controller.imageList.length;
                          return SlideImage(
                            imagePath: imagePath,
                            index: realIndex,
                          );
                        },
                      ),

                      // Navigation buttons
                      Positioned(
                        left: 16,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              controller.stopAutoSlide();
                              controller.goToPreviousPage();
                              Future.delayed(const Duration(seconds: 3), () {
                                controller.startAutoSlide();
                              });
                            },
                          ),
                        ),
                      ),

                      Positioned(
                        right: 16,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              controller.stopAutoSlide();
                              controller.goToNextPage();
                              Future.delayed(const Duration(seconds: 3), () {
                                controller.startAutoSlide();
                              });
                            },
                          ),
                        ),
                      ),

                      // Slide indicators
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            controller.imageList.length,
                            (index) => Obx(
                              () => Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                width:
                                    controller.currentSlideIndex.value == index
                                        ? 24
                                        : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color:
                                      controller.currentSlideIndex.value ==
                                              index
                                          ? SlectivColors.primaryBlue
                                          : Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Auto-slide status indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: SlectivColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.play_circle_outline,
                      color: SlectivColors.primaryBlue,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Auto-sliding every 3 seconds",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: SlectivColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
