// lib/pages/intro_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoenew/controllers/login_controller.dart';
import 'package:shoenew/pages/register_page.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  // Mendefinisikan warna hijau kustom
  static const Color primaryGreen = Color(0xFF2E7D32);

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

    return Scaffold(
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Form(
            key: controller.formKeys,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               // Menggantikan Widget Padding berisi Image.asset
Padding(
  padding: const EdgeInsets.only(bottom: 50.0),
  child: Column( // Gunakan Column jika ingin menambahkan teks nama toko
    children: [
      Icon(
        Icons.shopping_basket_rounded, // Atau Icons.local_grocery_store
        size: 80,
        color: primaryGreen,
      ),
      const SizedBox(height: 8),
    ],
  ),
),

                const Text(
                  'Selamat Datang Kembali!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    // Mengganti Colors.black87 dengan primaryGreen
                    color: primaryGreen,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Masuk ke akun Anda untuk melanjutkan berbelanja.',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),

                // Email Field with Validation
                TextFormField(
                  controller: controller.emailController,
                  validator: controller.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email, color: Colors.grey[700]),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      // Mengganti const BorderSide(color: Colors.black) dengan primaryGreen
                      borderSide: const BorderSide(color: primaryGreen),
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
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 15),

                // Password Field with Validation and Visibility Toggle
                Obx(
                  () => TextFormField(
                    controller: controller.passwordController,
                    validator: controller.validatePassword,
                    obscureText: !controller.isPasswordVisible.value,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock, color: Colors.grey[700]),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey[700],
                        ),
                        onPressed: () {
                          controller.isPasswordVisible.toggle();
                        },
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        // Mengganti const BorderSide(color: Colors.black) dengan primaryGreen
                        borderSide: const BorderSide(color: primaryGreen),
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
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value:
                              false, // Remember me functionality can be added later
                          onChanged: (bool? newValue) {
                            // Add remember me logic if needed
                          },
                          // Mengganti Colors.black dengan primaryGreen
                          activeColor: primaryGreen, 
                        ),
                        Text(
                          'Remember Me',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        print('Forgot Password clicked');
                      },
                      child: const Text(
                        'Lupa Password?',
                        style: TextStyle(
                          // Mengganti Colors.blue[700] dengan primaryGreen
                          color: primaryGreen, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Login Button with Loading State
                Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.login,
                    style: ElevatedButton.styleFrom(
                      // Mengganti Colors.black dengan primaryGreen
                      backgroundColor: primaryGreen, 
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledBackgroundColor: Colors.grey,
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum mempunyai akun?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const RegisterPage());
                      },
                      child: const Text(
                        'Daftar disini',
                        style: TextStyle(
                          // Mengganti Colors.blue[700] dengan primaryGreen
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
    );
  }
}