import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shoenew/models/cart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    // Wait a bit for UI to show
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final supabase = Supabase.instance.client;
      final session = supabase.auth.currentSession;

      if (session != null) {
        // User is logged in, get user ID and initialize cart
        final userId = session.user.id;

        // Initialize cart with user ID
        if (mounted) {
          final cart = Provider.of<Cart>(context, listen: false);
          await cart.initializeUser(userId);

          // Navigate to home
          Get.offAllNamed('/home');
        }
      } else {
        // No session, go to intro/login page
        if (mounted) {
          Get.offAllNamed('/intro');
        }
      }
    } catch (e) {
      // Error checking session, go to intro page
      print('Error checking session: $e');
      if (mounted) {
        Get.offAllNamed('/intro');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo or Icon
            Icon(Icons.shopping_bag, size: 80, color: Colors.black),
            const SizedBox(height: 24),
            // App Name
            const Text(
              'Toko Sayur',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 40),
            // Loading Indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
