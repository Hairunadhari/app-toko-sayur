import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shoenew/models/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await supabase.from('products').select('*');
    // data yang diprint copas ke AI buat bikin modelnya
    debugPrint("$response");
    return response.map<Product>((e) => Product.fromJson(e)).toList();
    } catch (e) {
      if (kDebugMode) {
        print("Error fetch product: $e");
      }
      throw Exception("Gagal mengambil data: $e");
    }
    
  }
}
