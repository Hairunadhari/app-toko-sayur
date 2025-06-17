import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoenew/models/cart.dart';
import 'package:shoenew/models/shoe.dart'; // untuk detail Shoe
import 'package:shoenew/models/cart_item.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Method untuk menghapus item dari keranjang
  void removeItemFromCart(CartItem cartItem) { // Parameter harus CartItem
    Provider.of<Cart>(context, listen: false).removeItemFromCart(cartItem); // Teruskan CartItem
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${cartItem.shoe.name} (Size: ${cartItem.selectedSize}) dihapus dari keranjang.'),
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
    Provider.of<Cart>(context, listen: false).decrementQuantity(cartItem);
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
                const Text(
                  'My Cart',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28, color: Colors.black),
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: cart.userCart.isEmpty
                      ? Center(
                    child: Text(
                      'Your cart is empty!',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  )
                      : ListView.builder(
                    itemCount: cart.userCart.length,
                    itemBuilder: (context, index) {
                      final cartItem = cart.userCart[index]; // Use final for good practice

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
                          print('Proceed to Checkout! Total: \$${cart.calculateTotal()}');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Checkout feature is not implemented yet!'),
                              backgroundColor: Colors.black87,
                            ),
                          );
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
                          'Checkout',
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