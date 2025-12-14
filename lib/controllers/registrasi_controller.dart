import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shoenew/services/auth_service.dart'; 

class RegisterController extends GetxController {
 // Inisialisasi Service
 final AuthService authService = AuthService();

 // 🆕 Text Editing Controllers BARU
 final nameController = TextEditingController();
 final phoneController = TextEditingController(); 
 final addressController = TextEditingController(); // ✨ PERBAIKAN 1: Gunakan nama Controller yang konsisten
 
 // Text Editing Controllers LAMA
 final emailController = TextEditingController();
 final passwordController = TextEditingController();
 final confirmPasswordController = TextEditingController();

 // Global Key untuk form (opsional, jika Anda menggunakan Form widget)
 final formKey = GlobalKey<FormState>();

 // State Reaktif
 RxBool isLoading = false.obs;
 RxBool isPasswordVisible = false.obs;
 
 @override
 void onClose() {
  // Memastikan controller dibuang saat tidak digunakan
  nameController.dispose(); 
  phoneController.dispose(); 
  addressController.dispose(); // ✨ PERBAIKAN 2: Gunakan addressController.dispose()
  emailController.dispose();
  passwordController.dispose();
  confirmPasswordController.dispose();
  super.onClose();
 }

 // --- Fungsi Validasi (Tambahkan validasi untuk Name & Phone jika diperlukan) ---
 
 String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
   return 'Email tidak boleh kosong';
  }
  if (!GetUtils.isEmail(value)) {
   return 'Format email tidak valid';
  }
  return null;
 }

 String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
   return 'Kata sandi tidak boleh kosong';
  }
  if (value.length < 8) {
   return 'Kata sandi minimal 8 karakter';
  }
  return null;
 }
 
 // --- Fungsi Utama Registrasi (Diperbarui) ---

 Future<void> register() async {
  // 1. Validasi Password
  if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
   Get.snackbar(
    'Pendaftaran Gagal',
    'Kata sandi dan Konfirmasi Kata sandi tidak cocok!',
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.red,
    colorText: Colors.white,
    duration: const Duration(seconds: 3),
    margin: const EdgeInsets.all(10),
    borderRadius: 8,
   );
   return;
  }

  // 2. Proses Registrasi
  try {
   isLoading(true);
   
   // Panggil AuthService untuk mendaftar di Supabase (Auth)
   final AuthResponse res = await authService.signUp(
    email: emailController.text.trim(),
    password: passwordController.text.trim(),
   );

   // 3. Penanganan Hasil
   if (res.user != null) {
    final String userId = res.user!.id;
    final String name = nameController.text.trim();
    final String email = emailController.text.trim();
    final String phone = phoneController.text.trim();
    final String addressValue = addressController.text.trim(); // ✨ PERBAIKAN 3: Ambil nilai dari Controller yang benar

    // 🆕 LANGKAH BARU: Buat entri profil di tabel database
    await authService.createUserProfile(
        userId: userId,
        name: name,
        email: email,
        phone: phone,
        address: addressValue, // Kirim nilai address yang benar
    );
        
    // Tampilkan sukses
    Get.snackbar(
     'Registrasi Berhasil',
     'Akun Anda berhasil dibuat! Silahkan login.',
     snackPosition: SnackPosition.TOP,
     backgroundColor: Colors.green,
     colorText: Colors.white,
     duration: const Duration(seconds: 3),
     margin: const EdgeInsets.all(10),
     borderRadius: 8,
    );
    
    // Navigasi ke halaman Home (menggantikan semua rute sebelumnya)
    Get.offAllNamed('/intro'); 
   }
  } on AuthException catch (e) {
   // 4. Penanganan Supabase Auth Error
   String errorMessage;

   if (e.message.contains('User already registered')) {
    errorMessage = 'Email sudah terdaftar. Silakan Masuk.';
   } else {
    errorMessage = e.message;
   }

   Get.snackbar(
    'Pendaftaran Gagal',
    errorMessage,
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.red,
    colorText: Colors.white,
    duration: const Duration(seconds: 3),
    margin: const EdgeInsets.all(10),
    borderRadius: 8,
   );
  } catch (e) {
   // 5. Penanganan Error Umum
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