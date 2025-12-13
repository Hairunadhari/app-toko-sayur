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

  
Future<List<Product>> fetchProductsByType(String type) async {
  try {
    final response = await supabase
        .from('products')
        .select('*')
        .eq('type', type); // gunakan .execute() untuk mendapatkan SupabaseResponse

    if (response.error != null) {
      throw response.error!;
    }

    final data = response.data as List<dynamic>;
    debugPrint("$data"); // data yang bisa Anda salin untuk membuat model
    return data.map<Product>((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  } catch (e) {
    if (kDebugMode) print("Error fetch products by type: $e");
    throw Exception("Gagal mengambil data: $e");
  }
}
}

