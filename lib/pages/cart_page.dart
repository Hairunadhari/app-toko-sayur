import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoenew/models/cart.dart';
import 'package:shoenew/models/shoe.dart';
import 'package:shoenew/models/cart_item.dart';
import 'package:shoenew/models/booking_detail.dart';
import 'package:shoenew/pages/my_orders_page.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
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

  void removeItemFromCart(CartItem cartItem) {
    Provider.of<Cart>(context, listen: false).removeItemFromCart(cartItem);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${cartItem.shoe.name} (${cartItem.selectedSize}) dihapus dari keranjang.',
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.green,
      ),
    );
  }

  void incrementItemQuantity(CartItem cartItem) {
    Provider.of<Cart>(context, listen: false).incrementQuantity(cartItem);
  }

  void decrementItemQuantity(CartItem cartItem) {
    if (cartItem.quantity > 1) {
      cartItem.quantity--;
      Provider.of<Cart>(context, listen: false).notifyListeners();
    } else {
      Provider.of<Cart>(context, listen: false).removeItemFromCart(cartItem);
    }
  }

  // Mengubah nama fungsi dan logikanya dari Size menjadi Unit/Kuantitas
  void _showUnitEditDialog(CartItem cartItem) {
    String? currentSelectedUnit = cartItem.selectedSize;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateInDialog) {
            return AlertDialog(
              title: Text('Change Unit for ${cartItem.shoe.name}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Available Units:'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: cartItem.shoe.availableSizes.map((unit) {
                      final bool isSelected = currentSelectedUnit == unit;
                      return GestureDetector(
                        onTap: () {
                          setStateInDialog(() {
                            currentSelectedUnit = unit;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.black : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: Text(
                            unit,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (currentSelectedUnit != null &&
                        currentSelectedUnit != cartItem.selectedSize) {
                      // Asumsi Cart model memiliki updateCartItemSize yang fleksibel
                      Provider.of<Cart>(
                        context,
                        listen: false,
                      ).updateCartItemSize(cartItem, currentSelectedUnit!);
                      Navigator.pop(context);
                    } else if (currentSelectedUnit == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a unit!')),
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showBookingConfirmationDialog(
    BuildContext context,
    String totalAmount,
  ) {
    String bookingId = 'BKNG-${DateTime.now().millisecondsSinceEpoch % 100000}';
    String bookingDate = DateFormat('dd MMM yyyy').format(DateTime.now());

    final cart = Provider.of<Cart>(context, listen: false);
    List<CartItem> bookedItems = List.from(cart.userCart);

    BookingDetail newBooking = BookingDetail(
      bookingId: bookingId,
      date: bookingDate,
      totalAmount: totalAmount,
      barcodeImagePath: '', // No longer needed
      bookedItems: bookedItems,
    );

    cart.addBooking(newBooking);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 16),
              const Text(
                'Order Berhasil!',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pesanan Anda telah berhasil dibuat',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Order ID:',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '#${newBooking.bookingId}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tanggal:',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          newBooking.date,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          _formatPrice(newBooking.totalAmount),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Selesai',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return Scaffold(
          backgroundColor: Colors.grey[200],
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height:
                      MediaQuery.of(context).padding.top + kToolbarHeight + 10,
                ),

                Expanded(
                  child: cart.userCart.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Keranjangmu Kosong',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Keranjang Anda kosong. Tambahkan barang terlebih dahulu!',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: cart.userCart.length,
                          itemBuilder: (context, index) {
                            final cartItem = cart.userCart[index];

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
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    // MENGUBAH: Menggunakan Image.network untuk URL
                                    child: Image.network(
                                      cartItem.shoe.imagePath,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 15),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cartItem.shoe.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        // MENGUBAH: Format harga ke Rupiah
                                        Text(
                                          _formatPrice(cartItem.shoe.price),
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            // MENGUBAH: Menampilkan Unit alih-alih Size
                                            Text(
                                              'Unit: ${cartItem.selectedSize}',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            GestureDetector(
                                              onTap: () =>
                                                  _showUnitEditDialog(cartItem),
                                              child: Icon(
                                                Icons.edit,
                                                size: 16,
                                                color: Colors.blue[700],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 15),

                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.remove,
                                                size: 20,
                                                color: Colors.grey[800],
                                              ),
                                              onPressed: () =>
                                                  decrementItemQuantity(
                                                    cartItem,
                                                  ),
                                              constraints: BoxConstraints.tight(
                                                const Size(36, 36),
                                              ),
                                              padding: EdgeInsets.zero,
                                            ),
                                            Text(
                                              cartItem.quantity.toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.add,
                                                size: 20,
                                                color: Colors.grey[800],
                                              ),
                                              onPressed: () =>
                                                  incrementItemQuantity(
                                                    cartItem,
                                                  ),
                                              constraints: BoxConstraints.tight(
                                                const Size(36, 36),
                                              ),
                                              padding: EdgeInsets.zero,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () =>
                                            removeItemFromCart(cartItem),
                                        constraints: BoxConstraints.tight(
                                          const Size(36, 36),
                                        ),
                                        padding: EdgeInsets.zero,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),

                // --- BAGIAN TOTAL DAN TOMBOL BOOKING ---
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Price',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16,
                            ),
                          ),
                          // MENGUBAH: Format Total Harga ke Rupiah
                          Text(
                            _formatPrice(cart.calculateTotal()),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (cart.userCart.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Keranjang Anda kosong. Tambahkan barang terlebih dahulu!',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          // MENGUBAH: Memanggil _formatPrice untuk totalAmount
                          _showBookingConfirmationDialog(
                            context,
                            cart.calculateTotal(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Checkout Now', // Mengubah 'Booking Now' menjadi 'Checkout Now'
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
