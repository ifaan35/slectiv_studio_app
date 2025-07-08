import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var isLoggedIn = false.obs;
  var currentUser = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) {
      currentUser.value = user;
      isLoggedIn.value = user != null;
    });
  }

  bool get isUserLoggedIn => currentUser.value != null;

  User? get user => currentUser.value;

  String get userId => currentUser.value?.uid ?? '';

  String get userEmail => currentUser.value?.email ?? '';

  void checkAuthState() {
    final user = _auth.currentUser;
    currentUser.value = user;
    isLoggedIn.value = user != null;
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      currentUser.value = null;
      isLoggedIn.value = false;
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
