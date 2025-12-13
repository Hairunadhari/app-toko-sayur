import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shoenew/models/product.dart';
import 'package:shoenew/services/supabase_service.dart';

class ProductController extends GetxController {
  final SupabaseService supabaseService = SupabaseService();

  final RxBool isLoading = false.obs;
  var products = <Product>[].obs;

  Future<void> fetchProducts() async {
    isLoading.value = true;

    try {
      final data = await supabaseService.fetchProducts();
      products.value = data;
    } catch (e) {
      if (kDebugMode) {
        print("Fetch Product Error: $e");
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProductsByType(String type) async {
    isLoading.value = true;

    try {
      final data = await supabaseService.fetchProductsByType(type);
      products.value = data;
    } catch (e) {
      if (kDebugMode) {
        print("Fetch Product By Type Error: $e");
      }
    } finally {
      isLoading.value = false;
    }
  }
}
