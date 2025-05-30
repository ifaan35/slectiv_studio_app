import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slectiv_studio_app/app/modules/gallery/views/gallery_view.dart';
import 'package:slectiv_studio_app/app/modules/home/views/home_view.dart';
import 'package:slectiv_studio_app/app/modules/profile/views/profile_view.dart';

class BottomNavigationBarController extends GetxController {
  var selectedIndex = 0.obs;
  var isUser = true.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> getUserRole() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('user').doc(user.uid).get();
      String role = (userDoc.data() as Map<String, dynamic>)['role'] ?? 'user';
      // Set isUser sesuai dengan role
      isUser.value = role != 'admin';
    }
  }

  List<Widget> screens = [
    const HomeView(),
    const CircularProgressIndicator(),
    const GalleryView(),
    ProfileView(),
  ];

  @override
  void onInit() {
    super.onInit();
    getUserRole().then((_) {
      // Pastikan screens diupdate setelah role di-fetch
      update(); // Force refresh setelah role diterima
    });
  }
}
