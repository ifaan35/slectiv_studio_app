import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slectiv_studio_app/app/modules/bottom_navigation_bar/views/bottom_navigation_bar_view.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';

class LoginScreenController extends GetxController {
  // -- Variables
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final hidePassword = true.obs;
  final isFormValid = false.obs;

  // final CollectionReference _userCollection =
  //     FirebaseFirestore.instance.collection('user');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    // Listen to text changes in both controllers
    emailController.addListener(_updateFormValidation);
    passwordController.addListener(_updateFormValidation);
  }

  @override
  void onClose() {
    emailController.removeListener(_updateFormValidation);
    passwordController.removeListener(_updateFormValidation);
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void _updateFormValidation() {
    isFormValid.value =
        emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty;
  }

  void clearForm() {
    emailController.clear();
    passwordController.clear();
    isFormValid.value = false;
  }

  Future<bool> checkCredentials(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> loginValidation() async {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        SlectivTexts.snackbarErrorTitle,
        SlectivTexts.snackbarErrorSubtitle,
        backgroundColor: SlectivColors.cancelAndNegatifSnackbarButtonColor,
        colorText: SlectivColors.whiteColor,
      );
      return;
    }

    bool isValidCredentials = await checkCredentials(email, password);

    if (isValidCredentials) {
      Get.snackbar(
        SlectivTexts.snackbarLoginSuccessfulTitle,
        SlectivTexts.snackbarLoginSuccessfulSubtitle,
        backgroundColor: SlectivColors.positifSnackbarColor,
        colorText: SlectivColors.whiteColor,
        duration: const Duration(seconds: 4),
      );

      Get.off(
        () => const BottomNavigationBarView(),
        transition: Transition.cupertinoDialog,
        duration: const Duration(milliseconds: 500),
      );

      clearForm();
    } else {
      Get.snackbar(
        SlectivTexts.snackbarErrorTitle,
        SlectivTexts.snackbarLoginfailedSubtitle,
        backgroundColor: SlectivColors.cancelAndNegatifSnackbarButtonColor,
        colorText: SlectivColors.whiteColor,
      );
    }
  }

  Future<String> getUserRole() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('user').doc(user.uid).get();
      return (userDoc.data() as Map<String, dynamic>)['role'] ?? 'user';
    }
    return 'user';
  }
}
