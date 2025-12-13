import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoenew/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController extends GetxController {
  final AuthService authService = AuthService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKeys = GlobalKey<FormState>();
  RxBool isLoading = false.obs;
  RxBool isPasswordVisible = false.obs;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  Future<void> login() async {
    if (formKeys.currentState!.validate()) {
      try {
        isLoading(true);
        final AuthResponse res = await authService.signInWithPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Check if login was successful
        if (res.user != null) {
          // Show success toast
          Get.snackbar(
            'Login Berhasil',
            'Selamat datang kembali!',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.all(10),
            borderRadius: 8,
          );

          // Navigate to home page
          Get.offAllNamed('/home');
        }
      } on AuthException catch (e) {
        // Handle Supabase auth specific errors
        String errorMessage;

        switch (e.statusCode) {
          case '400':
            errorMessage = 'Email atau password salah';
            break;
          case '422':
            errorMessage = 'Format email tidak valid';
            break;
          default:
            errorMessage = e.message;
        }

        Get.snackbar(
          'Login Gagal',
          errorMessage,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(10),
          borderRadius: 8,
        );
      } catch (e) {
        // Handle other errors
        Get.snackbar(
          'Error',
          'Terjadi kesalahan: ${e.toString()}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(10),
          borderRadius: 8,
        );
      } finally {
        isLoading(false);
      }
    }
  }
}
