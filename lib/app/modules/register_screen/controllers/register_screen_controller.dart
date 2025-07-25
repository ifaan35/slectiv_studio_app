import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';

class RegisterScreenController extends GetxController {
  final CollectionReference _userCollection = FirebaseFirestore.instance
      .collection('user');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // -- Variables
  final name = TextEditingController();
  final phoneNumber = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final hidePassword = true.obs;
  final hideConfirmPassword = true.obs;
  final isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to text changes in all controllers
    name.addListener(_updateFormValidation);
    phoneNumber.addListener(_updateFormValidation);
    email.addListener(_updateFormValidation);
    password.addListener(_updateFormValidation);
    confirmPassword.addListener(_updateFormValidation);
  }

  @override
  void onClose() {
    name.removeListener(_updateFormValidation);
    phoneNumber.removeListener(_updateFormValidation);
    email.removeListener(_updateFormValidation);
    password.removeListener(_updateFormValidation);
    confirmPassword.removeListener(_updateFormValidation);
    name.dispose();
    phoneNumber.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.onClose();
  }

  void _updateFormValidation() {
    isFormValid.value =
        name.text.trim().isNotEmpty &&
        phoneNumber.text.trim().isNotEmpty &&
        email.text.trim().isNotEmpty &&
        password.text.trim().isNotEmpty &&
        confirmPassword.text.trim().isNotEmpty;
  }

  void clearForm() {
    name.clear();
    phoneNumber.clear();
    email.clear();
    password.clear();
    confirmPassword.clear();
    isFormValid.value = false;
  }

  Future<bool> isUsernameExists(String email) async {
    QuerySnapshot querySnapshot =
        await _userCollection
            .where(SlectivTexts.profileEmail, isEqualTo: email)
            .get();
    return querySnapshot.docs.isNotEmpty;
  }

  // Fungsi Registrasi User
  Future<void> registerUser(
    String name,
    String phoneNumber,
    String email,
    String password,
  ) async {
    try {
      // Membuat pengguna dengan email dan password
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Mendapatkan userId setelah registrasi berhasil
      String userId = userCredential.user!.uid;

      // Menyimpan data user ke Firestore
      await _userCollection.doc(userId).set({
        SlectivTexts.profileName: name,
        SlectivTexts.profilePhoneNumber: phoneNumber,
        SlectivTexts.profileEmail: email,
        SlectivTexts.profileRole: 'user',
      });

      // Memberikan feedback bahwa registrasi berhasil
      Get.snackbar(
        'Registration Successful',
        'Welcome $name, your account has been created.',
        backgroundColor: SlectivColors.successSnackbarButtonColor,
        colorText: SlectivColors.whiteColor,
      );
    } catch (e) {
      // Menampilkan error jika terjadi masalah
      Get.snackbar(
        SlectivTexts.snackbarErrorTitle,
        SlectivTexts.snackbarErrorRegistrationSubtitle,
        backgroundColor: SlectivColors.cancelAndNegatifSnackbarButtonColor,
        colorText: SlectivColors.whiteColor,
      );
      print("Error: $e"); // Debugging error yang terjadi
    }
  }

  // Validasi Input
  bool validateInputs({
    required String name,
    required String phoneNumber,
    required String email,
    required String password,
  }) {
    if (name.isEmpty ||
        phoneNumber.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      Get.snackbar(
        SlectivTexts.snackbarErrorTitle,
        SlectivTexts.snackbarErrorNotCompleteAllColumnSubtitle,
        backgroundColor: SlectivColors.cancelAndNegatifSnackbarButtonColor,
        colorText: SlectivColors.whiteColor,
      );
      return false;
    } else if (!isValidEmail(email)) {
      Get.snackbar(
        SlectivTexts.snackbarErrorTitle,
        SlectivTexts.snackbarErrorNotValidEmailSubtitle,
        backgroundColor: SlectivColors.cancelAndNegatifSnackbarButtonColor,
        colorText: SlectivColors.whiteColor,
      );
      return false;
    } else if (password.length < 8) {
      Get.snackbar(
        SlectivTexts.snackbarErrorTitle,
        SlectivTexts.snackbarErrorMustConsistsPasswordSubtitle,
        backgroundColor: SlectivColors.cancelAndNegatifSnackbarButtonColor,
        colorText: SlectivColors.whiteColor,
      );
      return false;
    }
    return true;
  }

  // Fungsi untuk Validasi Email
  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(SlectivTexts.regExp);
    return emailRegex.hasMatch(email);
  }
}
