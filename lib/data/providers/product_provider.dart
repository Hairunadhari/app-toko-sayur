// // lib/data/providers/product_provider.dart
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Import Cloud Firestore
// import 'package:shoenew/models/shoe.dart'; // Import model Shoe
//
// class ProductProvider extends ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Inisialisasi Firestore
//   List<Shoe> _availableShoes = []; // Daftar sepatu yang tersedia
//   bool _isLoading = false; // Status loading
//   String? _errorMessage; // Pesan error jika ada
//
//   // Getters untuk state
//   List<Shoe> get availableShoes => _availableShoes;
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;
//
//   ProductProvider() {
//     fetchShoes(); // Panggil fetchShoes saat provider diinisialisasi
//   }
//
//   // Metode untuk mengambil data sepatu dari Firestore
//   Future<void> fetchShoes() async {
//     _isLoading = true; // Set loading ke true
//     _errorMessage = null; // Reset pesan error
//     notifyListeners(); // Beri tahu listener bahwa state berubah (mulai loading)
//
//     try {
//       // Ambil snapshot dari koleksi 'products' di Firestore
//       QuerySnapshot snapshot = await _firestore.collection('products').get();
//
//       // Petakan dokumen-dokumen Firestore ke dalam objek Shoe
//       _availableShoes = snapshot.docs.map((doc) {
//         // Pastikan nama field di Firestore (misal: 'name', 'price') sesuai
//         // dengan properti di model Shoe Anda.
//         return Shoe(
//           name: doc['name'] as String,
//           price: doc['price'] as String, // Atau sesuaikan tipe data jika di Firestore bukan String
//           imagePath: doc['imagePath'] as String, // Ini harus URL gambar publik
//           description: doc['description'] as String,
//           gender: doc['gender'] as String,
//         );
//       }).toList();
//     } catch (e) {
//       // Tangani error jika gagal mengambil data
//       _errorMessage = 'Failed to load products: $e';
//       print('Error fetching shoes: $e'); // Log error untuk debugging
//     } finally {
//       _isLoading = false; // Set loading ke false setelah selesai (baik sukses/gagal)
//       notifyListeners(); // Beri tahu listener bahwa state berubah (loading selesai)
//     }
//   }
// }