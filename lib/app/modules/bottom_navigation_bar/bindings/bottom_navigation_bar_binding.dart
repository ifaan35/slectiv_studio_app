import 'package:get/get.dart';
import 'package:slectiv_studio_app/app/controllers/auth_controller.dart';

import '../controllers/bottom_navigation_bar_controller.dart';

class BottomNavigationBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<BottomNavigationBarController>(
      () => BottomNavigationBarController(),
    );
  }
}
