import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slectiv_studio_app/app/modules/gallery/controllers/gallery_controller.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';

class SlectivPhotoGallery extends StatelessWidget {
  const SlectivPhotoGallery({super.key, required this.controller});

  final GalleryController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
          child: Text(
            "Photo Gallery",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: SlectivColors.titleColor,
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Center(
          child: Text(
            "Discover our stunning photography collections",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: SlectivColors.titleColor,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Obx(() {
          return Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 330,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: PageView.builder(
                      controller: controller.pageController,
                      onPageChanged: (index) {
                        controller.currentSlideIndex.value = index;
                      },
                      itemCount: controller.imageList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              controller.imageList[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                    color: Colors.grey[400],
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    left: 8,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          controller.goToPreviousPage();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          controller.goToNextPage();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Slide indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.imageList.length,
                  (index) => Obx(
                    () => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width:
                          controller.currentSlideIndex.value == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color:
                            controller.currentSlideIndex.value == index
                                ? SlectivColors.primaryBlue
                                : Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
