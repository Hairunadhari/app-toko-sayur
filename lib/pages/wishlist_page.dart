import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoenew/models/cart.dart';
import 'package:shoenew/models/shoe.dart';
import 'package:shoenew/pages/product_detail_page.dart';
import 'package:intl/intl.dart'; // Import intl

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  
  // Helper function untuk memformat harga ke format Rupiah
  String _formatPrice(dynamic price) {
    double numericPrice;
    if (price is String) {
      numericPrice =
          double.tryParse(price.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0;
    } else if (price is num) {
      numericPrice = price.toDouble();
    } else {
      numericPrice = 0.0;
    }

    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatter.format(numericPrice);
  }

  void removeFromWishlist(Shoe shoe) {
    Provider.of<Cart>(context, listen: false).removeFromWishlist(shoe);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${shoe.name} removed from wishlist.'),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.black87,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        List<Shoe> wishlistItems = cart.wishlist;

        return Scaffold(
          backgroundColor: Colors.grey[200],
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight + 10),

                // Judul "My Wishlist"
                const Text(
                  'My Wishlist',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28, color: Colors.black),
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: wishlistItems.isEmpty
                      ? Center(
                          child: Text(
                            'Your wishlist is empty!',
                            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                          ),
                        )
                      : ListView.builder(
                          itemCount: wishlistItems.length,
                          itemBuilder: (context, index) {
                            final item = wishlistItems[index];

                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              margin: const EdgeInsets.only(bottom: 15),
                              padding: const EdgeInsets.all(12),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  // MENGUBAH: Menggunakan Image.network untuk URL gambar
                                  child: Image.network(
                                    item.imagePath, 
                                    width: 60, 
                                    height: 60, 
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                // MENGUBAH: Menampilkan harga dalam Rupiah
                                subtitle: Text(_formatPrice(item.price)), 
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => removeFromWishlist(item),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailPage(shoe: item),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}