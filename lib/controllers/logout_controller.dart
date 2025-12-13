import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shoenew/models/cart.dart';
import 'package:shoenew/services/auth_service.dart';

class LogoutController extends GetxController {
  final AuthService authService = AuthService();
  RxBool isLoading = false.obs;

  Future<void> logout(BuildContext context) async {
    try {
      isLoading(true);

      // Clear cart data
      final cart = Provider.of<Cart>(context, listen: false);
      await cart.clearUserData();

      // Sign out from Supabase (this will clear the session)
      await authService.signOut();

      // Navigate to intro page
      Get.offAllNamed('/intro');

      Get.snackbar(
        'Logout Berhasil',
        'Anda telah keluar dari aplikasi',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(10),
        borderRadius: 8,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal logout: ${e.toString()}',
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
