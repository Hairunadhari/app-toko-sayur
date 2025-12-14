import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/registrasi_controller.dart'; 
// Pastikan path ke RegisterController sudah benar

class RegisterPage extends StatelessWidget {
const RegisterPage({super.key});

// Warna kustom
static const Color primaryGreen = Color(0xFF2E7D32);

@override
Widget build(BuildContext context) {
 // 1. Inisialisasi Controller (Get.put)
 final RegisterController controller = Get.put(RegisterController());
 const Color primaryGreen = RegisterPage.primaryGreen;

 // 2. Gunakan Obx untuk Reaktivitas
 return Obx(
 () => Scaffold(
  backgroundColor: Colors.grey[200],
  appBar: AppBar(
  backgroundColor: Colors.transparent,
  elevation: 0,
  leading: IconButton(
   icon: const Icon(Icons.arrow_back_ios, color: primaryGreen),
   // Kembali ke halaman sebelumnya (Login/Intro)
   onPressed: () => Navigator.pop(context),
  ),
  ),
  body: Center(
  child: SingleChildScrollView(
   padding: const EdgeInsets.symmetric(horizontal: 25.0),
   // Menggunakan Form untuk validasi input secara kolektif
   child: Form(
   key: controller.formKey,
   child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    // --- Logo/Branding (Tidak Berubah) ---
    Padding(
     padding: const EdgeInsets.only(bottom: 30.0),
     child: Column(
     children: [
      Icon(
      Icons.local_florist_rounded, 
      size: 70,
      color: primaryGreen,
      ),
      const SizedBox(height: 8),
     ],
     ),
    ),
    
    // --- Judul dan Deskripsi (Tidak Berubah) ---
    const Text(
     'Buat Akun Anda!', 
     style: TextStyle(
     fontWeight: FontWeight.bold,
     fontSize: 24,
     color: primaryGreen, 
     ),
    ),
    const SizedBox(height: 10),
    Text(
     'Temukan dan beli sayur serta buah paling segar hanya di sini.', 
     style: TextStyle(
     fontSize: 16,
     color: Colors.grey[700],
     ),
     textAlign: TextAlign.center,
    ),
    const SizedBox(height: 50),
        
         // --- Field Nama Lengkap ---
    _buildTextFormField(
     controller: controller.nameController,
     validator: (value) {
     if (value == null || value.isEmpty) {
      return 'Nama lengkap wajib diisi';
     }
     return null;
     },
     hintText: 'Nama Lengkap',
     prefixIcon: Icons.person,
     keyboardType: TextInputType.name,
     primaryColor: primaryGreen,
    ),
    const SizedBox(height: 15),

    // --- Field Nomor Telepon ---
    _buildTextFormField(
     controller: controller.phoneController,
     validator: (value) {
     if (value == null || value.isEmpty) {
      return 'Nomor telepon wajib diisi';
     }
     return null;
     },
     hintText: 'Nomor Telepon',
     prefixIcon: Icons.phone,
     keyboardType: TextInputType.phone,
     primaryColor: primaryGreen,
    ),
    const SizedBox(height: 15),
           
           // 🆕 --- Field ALAMAT LENGKAP ---
    _buildTextFormField(
     controller: controller.addressController,
     validator: (value) {
     if (value == null || value.isEmpty) {
      return 'Alamat wajib diisi';
     }
     return null;
     },
     hintText: 'Alamat Lengkap',
     prefixIcon: Icons.location_on,
           maxLines: 1, // Agar pengguna bisa memasukkan alamat yang lebih panjang
     keyboardType: TextInputType.streetAddress,
     primaryColor: primaryGreen,
    ),
    const SizedBox(height: 15), // Spasi setelah Alamat

    // --- Field Email ---
    _buildTextFormField(
     controller: controller.emailController,
     validator: controller.validateEmail,
     hintText: 'Email',
     prefixIcon: Icons.email,
     keyboardType: TextInputType.emailAddress,
     primaryColor: primaryGreen,
    ),
    const SizedBox(height: 15),

    // --- Field Kata Sandi ---
    _buildPasswordFormField(
     controller: controller.passwordController,
     validator: controller.validatePassword,
     hintText: 'Kata Sandi',
     prefixIcon: Icons.lock,
     primaryColor: primaryGreen,
     // isObscure menggunakan Obx
     isObscure: !controller.isPasswordVisible.value,
     toggleVisibility: controller.isPasswordVisible.toggle,
    ),
    const SizedBox(height: 15),

    // --- Field Konfirmasi Kata Sandi ---
    _buildPasswordFormField(
     controller: controller.confirmPasswordController,
     validator: (value) {
     // Validasi ganda: memastikan tidak kosong dan cocok dengan password
     if (value == null || value.isEmpty) {
      return 'Konfirmasi sandi tidak boleh kosong';
     }
     if (value != controller.passwordController.text) {
      return 'Kata sandi tidak cocok';
     }
     return null;
     },
     hintText: 'Konfirmasi Kata Sandi',
     prefixIcon: Icons.lock_reset,
     primaryColor: primaryGreen,
     isObscure: !controller.isPasswordVisible.value,
     toggleVisibility: controller.isPasswordVisible.toggle,
    ),
    const SizedBox(height: 30),

    // --- Tombol Daftar (Tidak Berubah) ---
    ElevatedButton(
     onPressed: controller.isLoading.value ? null : () {
     if (controller.formKey.currentState!.validate()) {
      controller.register(); // Panggil fungsi register di Controller
     }
     },
     style: ElevatedButton.styleFrom(
     backgroundColor: primaryGreen,
     foregroundColor: Colors.white,
     minimumSize: const Size(double.infinity, 55),
     shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
     ),
     ),
     child: controller.isLoading.value
      ? const CircularProgressIndicator(color: Colors.white) // Tampilkan loading
      : const Text(
       'Daftar',
       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ),
    const SizedBox(height: 40),

    // --- Teks 'Sudah punya akun?' (Tidak Berubah) ---
    Row(
     mainAxisAlignment: MainAxisAlignment.center,
     children: [
     Text(
      'Sudah punya akun?', 
      style: TextStyle(color: Colors.grey[700]),
     ),
     const SizedBox(width: 4),
     GestureDetector(
      onTap: () {
      Navigator.pop(context); // Kembali ke halaman login
      },
      child: const Text(
      'Masuk Sekarang', 
      style: TextStyle(
       color: primaryGreen, 
       fontWeight: FontWeight.bold,
      ),
      ),
     ),
     ],
    ),
    const SizedBox(height: 50),
    ],
   ),
   ),
  ),
  ),
 ),
 );
}

// --- Widget Pembantu untuk TextFormField Biasa ---
Widget _buildTextFormField({
 required TextEditingController controller,
 required String? Function(String?) validator,
 required String hintText,
 required IconData prefixIcon,
 required Color primaryColor,
 TextInputType keyboardType = TextInputType.text,
   int maxLines = 1, // Parameter baru untuk mengizinkan input multiline (khusus alamat)
}) {
 return TextFormField(
 controller: controller,
 validator: validator,
 keyboardType: keyboardType,
    maxLines: maxLines, // Terapkan maxLines
 decoration: _buildInputDecoration(
  hintText: hintText,
  prefixIcon: prefixIcon,
  primaryColor: primaryColor,
 ),
 style: const TextStyle(color: Colors.black),
 );
}

// --- Widget Pembantu untuk TextFormField Password (Tidak Berubah) ---
Widget _buildPasswordFormField({
 required TextEditingController controller,
 required String? Function(String?) validator,
 required String hintText,
 required IconData prefixIcon,
 required Color primaryColor,
 required bool isObscure,
 required Function() toggleVisibility,
}) {
 return TextFormField(
 controller: controller,
 validator: validator,
 obscureText: isObscure,
 decoration: _buildInputDecoration(
  hintText: hintText,
  prefixIcon: prefixIcon,
  primaryColor: primaryColor,
  suffixIcon: IconButton(
  icon: Icon(
   isObscure ? Icons.visibility_off : Icons.visibility,
   color: Colors.grey[700],
  ),
  onPressed: toggleVisibility,
  ),
 ),
 style: const TextStyle(color: Colors.black),
 );
}

// --- Fungsi Pembantu untuk Dekorasi Input (Tidak Berubah) ---
InputDecoration _buildInputDecoration({
 required String hintText,
 required IconData prefixIcon,
 required Color primaryColor,
 Widget? suffixIcon,
}) {
 return InputDecoration(
 hintText: hintText,
 prefixIcon: Icon(prefixIcon, color: Colors.grey[700]),
 suffixIcon: suffixIcon,
 enabledBorder: OutlineInputBorder(
  borderSide: BorderSide(color: Colors.grey.shade400),
  borderRadius: BorderRadius.circular(12),
 ),
 focusedBorder: OutlineInputBorder(
  borderSide: BorderSide(color: primaryColor),
  borderRadius: BorderRadius.circular(12),
 ),
 errorBorder: OutlineInputBorder(
  borderSide: const BorderSide(color: Colors.red),
  borderRadius: BorderRadius.circular(12),
 ),
 focusedErrorBorder: OutlineInputBorder(
  borderSide: const BorderSide(color: Colors.red),
  borderRadius: BorderRadius.circular(12),
 ),
 fillColor: Colors.white,
 filled: true,
 );
}
}