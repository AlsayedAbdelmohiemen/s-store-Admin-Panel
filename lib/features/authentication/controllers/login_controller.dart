import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/repositories/authentication_repository.dart';
import '../../../routes/routes.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final rememberMe = true.obs;
  final hidePassword = true.obs;
  final isLoading = false.obs;

  final email = TextEditingController();
  final password = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();

  final localStorage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    final savedEmail = localStorage.read('REMEMBER_ME_EMAIL');
    final savedPassword = localStorage.read('REMEMBER_ME_PASSWORD');
    if (savedEmail != null && savedEmail.isNotEmpty) {
      email.text = savedEmail;
    }
    if (savedPassword != null && savedPassword.isNotEmpty) {
      password.text = savedPassword;
    }
  }

  Future<void> login() async {
    try {
      if (!loginFormKey.currentState!.validate()) return;

      isLoading.value = true;

      // 1. Authenticate with Supabase
      await AuthenticationRepository.instance.loginWithEmailAndPassword(
        email.text.trim(),
        password.text.trim(),
      );

      // 2. Remember Me
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      } else {
        localStorage.remove('REMEMBER_ME_EMAIL');
        localStorage.remove('REMEMBER_ME_PASSWORD');
      }

      isLoading.value = false;

      // 3. Success Notification & Navigate to Dashboard
      Get.snackbar(
        'Welcome Back',
        'Signed in successfully as Admin',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.8),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );

      Get.offAllNamed(SRoutes.dashboard);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Login Error',
        e.toString().replaceAll('Exception:', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  /// Quick 1-Click Demo Login for Testing & Development
  Future<void> quickDemoLogin() async {
    try {
      isLoading.value = true;
      const demoEmail = 'admin@sstore.com';
      const demoPassword = 'AdminPassword123!';
      email.text = demoEmail;
      password.text = demoPassword;

      try {
        // Attempt sign in first
        await AuthenticationRepository.instance.loginWithEmailAndPassword(
          demoEmail,
          demoPassword,
        );
      } catch (_) {
        // If not registered yet, auto-register the demo admin via Supabase
        await AuthenticationRepository.instance.signUpAdmin(demoEmail, demoPassword);
      }

      isLoading.value = false;

      Get.snackbar(
        'Admin Access',
        'Signed in successfully as Demo Admin',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.8),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );

      Get.offAllNamed(SRoutes.dashboard);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Login Notice',
        'Direct login notice: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withValues(alpha: 0.8),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }
}
