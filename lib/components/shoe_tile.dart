import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoenew/models/shoe.dart';
import 'package:shoenew/models/cart.dart';
import 'package:shoenew/pages/product_detail_page.dart';
import 'package:intl/intl.dart'; // Import paket intl untuk format mata uang

// ignore: must_be_immutable
class ShoeTile extends StatelessWidget {
  Shoe shoe;
  final VoidCallback onAddTap;

  ShoeTile({super.key, required this.shoe, required this.onAddTap});

  // Helper function untuk memformat harga ke format Rupiah (misal: 200.000)
  String _formatPrice(dynamic price) {
    // 1. Konversi ke double
    double numericPrice;
    if (price is String) {
      // Hapus karakter non-digit kecuali titik/koma jika ada, lalu konversi
      numericPrice = double.tryParse(price.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0;
    } else if (price is num) {
      numericPrice = price.toDouble();
    } else {
      numericPrice = 0.0;
    }
    
    // 2. Format menggunakan NumberFormat dari paket intl
    final formatter = NumberFormat.currency(
      locale: 'id_ID', // Lokasi Indonesia
      symbol: 'Rp',     // Simbol Rupiah
      decimalDigits: 0, // Tidak ada desimal untuk harga bulat
    );

    return formatter.format(numericPrice);
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    bool isFav = cart.isFavorite(shoe);

    // Mengubah tipe data price menjadi String untuk pemanggilan _formatPrice
    // Jika model Shoe.price Anda sebenarnya double/int, ubah parameter _formatPrice ke tipe yang benar.
    final formattedPrice = _formatPrice(shoe.price); 

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(shoe: shoe),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(left: 25),
        width: 280,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, 
                      vertical: 10.0,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        shoe.imagePath,
                        fit: BoxFit.cover,
                        height: 180,
                        alignment: Alignment.center, 
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return SizedBox(
                            height: 180,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // Icon Favorite (Wishlist)
                Positioned(
                  top: 15,
                  right: 15,
                  child: GestureDetector(
                    onTap: () {
                      if (isFav) {
                        cart.removeFromWishlist(shoe);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${shoe.name} removed from wishlist!'),
                          ),
                        );
                      } else {
                        cart.addToWishlist(shoe);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${shoe.name} added to wishlist!'),
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : Colors.grey,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            // --- BAGIAN DETAIL PRODUK & TOMBOL ADD ---
            Padding(
              padding: const EdgeInsets.only(
                left: 25.0,
                right: 0.0,
                bottom: 0.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shoe.name, // Nama produk (e.g., Paket Sehat Harian)
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        // MENGGUNAKAN FORMAT RUPIAH
                        formattedPrice, 
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),

                  // Tombol ADD
                  GestureDetector(
                    onTap: onAddTap,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                          bottomRight: Radius.circular(25),
                        ),
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}