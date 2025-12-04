import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoenew/models/cart.dart';
import 'package:shoenew/models/shoe.dart';
import 'package:shoenew/models/cart_item.dart';
import 'package:shoenew/models/booking_detail.dart';
import 'package:shoenew/pages/my_orders_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Method untuk menghapus item dari keranjang
  void removeItemFromCart(CartItem cartItem) {
    Provider.of<Cart>(context, listen: false).removeItemFromCart(cartItem);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${cartItem.shoe.name} (Size: ${cartItem.selectedSize}) removed from Booking Shoes.'),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.black87,
      ),
    );
  }

  // Method untuk menambah kuantitas
  void incrementItemQuantity(CartItem cartItem) {
    Provider.of<Cart>(context, listen: false).incrementQuantity(cartItem);
  }

  // Method untuk mengurangi kuantitas
  void decrementItemQuantity(CartItem cartItem) {
    if (cartItem.quantity > 1) {
      cartItem.quantity--;
    } else {
      Provider.of<Cart>(context, listen: false).removeItemFromCart(cartItem);
    }
  }

  // Fungsi untuk menampilkan dialog edit ukuran
  void _showSizeEditDialog(CartItem cartItem) {
    String? currentSelectedSize = cartItem.selectedSize;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateInDialog) {
            return AlertDialog(
              title: Text('Change Size for ${cartItem.shoe.name}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Available Sizes:'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: cartItem.shoe.availableSizes.map((size) {
                      final bool isSelected = currentSelectedSize == size;
                      return GestureDetector(
                        onTap: () {
                          setStateInDialog(() {
                            currentSelectedSize = size;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.black : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: Text(
                            size,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
                    if (currentSelectedSize != null && currentSelectedSize != cartItem.selectedSize) {
                      Provider.of<Cart>(context, listen: false)
                          .updateCartItemSize(cartItem, currentSelectedSize!);
                      Navigator.pop(context);
                    } else if (currentSelectedSize == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a size!')),
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showBookingConfirmationDialog(BuildContext context, String totalAmount) {
    String bookingId = 'BKNG-${DateTime.now().millisecondsSinceEpoch % 100000}';
    String bookingDate = DateTime.now().toLocal().toString().split(' ')[0];
    String barcodePath = 'lib/images/Code-128.png';

    final cart = Provider.of<Cart>(context, listen: false);
    List<CartItem> bookedItems = List.from(cart.userCart);

    BookingDetail newBooking = BookingDetail(
      bookingId: bookingId,
      date: bookingDate,
      totalAmount: totalAmount,
      barcodeImagePath: barcodePath,
      bookedItems: bookedItems,
    );

    cart.addBooking(newBooking);
    cart.userCart.clear();
    cart.notifyListeners();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Booking Confirmed!', textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Your booking is confirmed!'),
                const SizedBox(height: 20),
                const Text(
                  'Please present this barcode at the store for pickup.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Image.asset(
                  newBooking.barcodeImagePath,
                  height: 150,
                  width: 250,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                Text('Booking ID: #${newBooking.bookingId}'),
                Text('Date: ${newBooking.date}'),
                Text('Total: \$${newBooking.totalAmount}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MyOrdersPage()),
                );
              },
              child: const Text('OK'),
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
                SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight + 10),

                Expanded(
                  child: cart.userCart.isEmpty
                      ? Center(
                    child: Text(
                      'Your Booking Shoes is empty!',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
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
                              child: Image.asset(
                                cartItem.shoe.imagePath,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 15),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartItem.shoe.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$' + cartItem.shoe.price,
                                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        'Size: ${cartItem.selectedSize}',
                                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                      ),
                                      const SizedBox(width: 5),
                                      GestureDetector(
                                        onTap: () => _showSizeEditDialog(cartItem),
                                        child: Icon(Icons.edit, size: 16, color: Colors.blue[700]),
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
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove, size: 20, color: Colors.grey[800]),
                                        onPressed: () => decrementItemQuantity(cartItem),
                                        constraints: BoxConstraints.tight(const Size(36, 36)),
                                        padding: EdgeInsets.zero,
                                      ),
                                      Text(
                                        cartItem.quantity.toString(),
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.add, size: 20, color: Colors.grey[800]),
                                        onPressed: () => incrementItemQuantity(cartItem),
                                        constraints: BoxConstraints.tight(const Size(36, 36)),
                                        padding: EdgeInsets.zero,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => removeItemFromCart(cartItem),
                                  constraints: BoxConstraints.tight(const Size(36, 36)),
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
                            style: TextStyle(color: Colors.grey[700], fontSize: 16),
                          ),
                          Text(
                            '\$' + cart.calculateTotal(),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (cart.userCart.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Your Booking Shoes is empty. Add items first!'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          _showBookingConfirmationDialog(context, cart.calculateTotal());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Booking Now',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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