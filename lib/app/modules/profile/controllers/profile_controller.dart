import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';

class ProfileController extends GetxController {
  final CollectionReference _userCollection = FirebaseFirestore.instance
      .collection(SlectivTexts.profileUser);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var name = ''.obs;
  var email = ''.obs;
  var phoneNumber = ''.obs;
  var profileImageUrl = ''.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  @override
  void onReady() {
    super.onReady();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      isLoading.value = true;
      User? user = _auth.currentUser;
      if (user != null) {
        // Juga ambil email dari FirebaseAuth
        email.value = user.email ?? '';

        DocumentSnapshot userSnapshot =
            await _userCollection.doc(user.uid).get();
        if (userSnapshot.exists) {
          var userData = userSnapshot.data() as Map<String, dynamic>;
          name.value = userData[SlectivTexts.profileName] ?? '';
          // Update email dari Firestore jika ada, jika tidak gunakan dari Auth
          if (userData[SlectivTexts.profileEmail] != null &&
              userData[SlectivTexts.profileEmail].toString().isNotEmpty) {
            email.value = userData[SlectivTexts.profileEmail];
          }
          phoneNumber.value = userData[SlectivTexts.profilePhoneNumber] ?? '';
          profileImageUrl.value = userData[SlectivTexts.profileImageUrl] ?? '';
        } else {
          print(SlectivTexts.profileNoUserDataFound);
          // Create initial user data if it doesn't exist
          await _createInitialUserData(user);
        }
      } else {
        print(SlectivTexts.profileNoUserLoggedIn);
      }
    } catch (e) {
      print("${SlectivTexts.profileErrorFetchingUserData} $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _createInitialUserData(User user) async {
    try {
      await _userCollection.doc(user.uid).set({
        SlectivTexts.profileName: user.displayName ?? '',
        SlectivTexts.profileEmail: user.email ?? '',
        SlectivTexts.profilePhoneNumber: '',
        SlectivTexts.profileImageUrl: '',
        'createdAt': FieldValue.serverTimestamp(),
      });
      // Refresh data after creation
      await fetchUserData();
    } catch (e) {
      print("Error creating initial user data: $e");
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File image = File(pickedFile.path);
      await uploadImage(image);
      Get.back();
      Get.snackbar(
        SlectivTexts.profileSuccessFotoChangedTitle,
        SlectivTexts.profileSuccessFotoChangedSubtitle,
        backgroundColor: SlectivColors.positifSnackbarColor,
        colorText: SlectivColors.whiteColor,
      );
    } else {
      print(SlectivTexts.profileNoImageSelected);
    }
  }

  void deleteImage() {
    profileImageUrl.value = '';
    Get.back();
    Get.snackbar(
      SlectivTexts.profileSuccessFotoDeletedTitle,
      SlectivTexts.profileSuccessFotoDeletedSubtitle,
      backgroundColor: SlectivColors.cancelAndNegatifSnackbarButtonColor,
      colorText: SlectivColors.whiteColor,
    );
  }

  Future<void> uploadImage(File image) async {
    try {
      Get.dialog(
        const Center(
          child: SizedBox(
            height: 100,
            width: 100,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                SlectivColors.circularProgressColor,
              ),
              strokeWidth: 5,
            ),
          ),
        ),
        barrierDismissible: false,
      );

      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child(SlectivTexts.profileImages)
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      await ref.putFile(image);

      String imageUrl = await ref.getDownloadURL();

      profileImageUrl.value = imageUrl;

      User? user = _auth.currentUser;
      if (user != null) {
        await _userCollection.doc(user.uid).update({
          SlectivTexts.profileImageUrl: imageUrl,
        });
      }

      Get.back();
    } catch (e) {
      print('${SlectivTexts.profileErrorUploadingImage} $e');
    }
  }

  Future<void> updateName(String newName) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        isLoading.value = true;
        await _userCollection.doc(user.uid).update({
          SlectivTexts.profileName: newName,
        });
        name.value = newName;
        update(); // Force UI update
        Get.snackbar(
          SlectivTexts.profileSuccess,
          "Name updated successfully",
          backgroundColor: SlectivColors.positifSnackbarColor,
          colorText: SlectivColors.whiteColor,
        );
      } catch (e) {
        Get.snackbar(
          SlectivTexts.snackbarErrorTitle,
          "Failed to update name: $e",
          backgroundColor: SlectivColors.cancelAndNegatifSnackbarButtonColor,
          colorText: SlectivColors.whiteColor,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> updatePhoneNumber(String newPhoneNumber) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        isLoading.value = true;
        await _userCollection.doc(user.uid).update({
          SlectivTexts.profilePhoneNumber: newPhoneNumber,
        });
        phoneNumber.value = newPhoneNumber;
        update(); // Force UI update
        Get.snackbar(
          SlectivTexts.profileSuccess,
          SlectivTexts.profileUpdatePhoneNumberSubtitle,
          backgroundColor: SlectivColors.positifSnackbarColor,
          colorText: SlectivColors.whiteColor,
        );
      } catch (e) {
        Get.snackbar(
          SlectivTexts.snackbarErrorTitle,
          "${SlectivTexts.snackbarErrorUpdateNameSubtitle} $e",
          backgroundColor: SlectivColors.cancelAndNegatifSnackbarButtonColor,
          colorText: SlectivColors.whiteColor,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Get.offAllNamed('/login-screen'); // Navigate to login screen
      Get.snackbar(
        "Success",
        "Signed out successfully",
        backgroundColor: SlectivColors.positifSnackbarColor,
        colorText: SlectivColors.whiteColor,
      );
    } catch (e) {
      Get.snackbar(
        SlectivTexts.snackbarErrorTitle,
        "Failed to sign out: $e",
        backgroundColor: SlectivColors.cancelAndNegatifSnackbarButtonColor,
        colorText: SlectivColors.whiteColor,
      );
    }
  }

  Future<void> refreshProfileData() async {
    await fetchUserData();
  }

  // Method to ensure user data exists
  Future<void> ensureUserDataExists() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userSnapshot = await _userCollection.doc(user.uid).get();
      if (!userSnapshot.exists) {
        await _createInitialUserData(user);
      }
    }
  }
}
