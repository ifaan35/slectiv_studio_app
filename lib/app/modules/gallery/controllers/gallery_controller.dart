import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slectiv_studio_app/utils/constants/image_strings.dart';

class GalleryController extends GetxController {
  // Observable list to store image paths
  final imageList = <String>[].obs;
  late PageController pageController;
  final currentSlideIndex = 0.obs;
  Timer? _autoSlideTimer;

  // For infinite scrolling
  static const int _virtualItemCount =
      1000000; // Large number for infinite scroll
  int get _actualItemCount => imageList.length;
  int get _initialPage => _virtualItemCount ~/ 2;

  @override
  void onInit() {
    super.onInit();
    // Initialize image list
    imageList.addAll([
      SlectivImages.galeryImage,
      SlectivImages.galeryImage1,
      SlectivImages.galeryImage2,
      SlectivImages.galeryImage3,
      SlectivImages.galeryImage4,
      SlectivImages.galeryImage5,
      SlectivImages.galeryImage6,
      SlectivImages.galeryImage7,
      SlectivImages.galeryImage8,
      SlectivImages.galeryImage9,
      SlectivImages.galeryImage10,
    ]);

    // Initialize PageController with initial page in the middle
    pageController = PageController(
      initialPage: _initialPage,
      viewportFraction: 1.0,
    );

    // Start auto slide
    startAutoSlide();
  }

  // Get real index from virtual index
  int _getRealIndex(int virtualIndex) {
    return virtualIndex % _actualItemCount;
  }

  void startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (imageList.isNotEmpty && pageController.hasClients) {
        final currentPage = pageController.page ?? _initialPage;
        pageController.animateToPage(
          (currentPage + 1).round(),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void stopAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = null;
  }

  void goToPreviousPage() {
    if (imageList.isNotEmpty && pageController.hasClients) {
      final currentPage = pageController.page ?? _initialPage;
      pageController.animateToPage(
        (currentPage - 1).round(),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void goToNextPage() {
    if (imageList.isNotEmpty && pageController.hasClients) {
      final currentPage = pageController.page ?? _initialPage;
      pageController.animateToPage(
        (currentPage + 1).round(),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void onPageChanged(int virtualIndex) {
    currentSlideIndex.value = _getRealIndex(virtualIndex);
  }

  // Get virtual item count for PageView
  int get virtualItemCount => _virtualItemCount;

  // Get real image path from virtual index
  String getImagePath(int virtualIndex) {
    final realIndex = _getRealIndex(virtualIndex);
    return imageList[realIndex];
  }

  @override
  void onClose() {
    _autoSlideTimer?.cancel();
    pageController.dispose();
    super.onClose();
  }
}
