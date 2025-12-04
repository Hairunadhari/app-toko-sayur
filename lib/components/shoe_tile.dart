import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoenew/models/shoe.dart';
import 'package:shoenew/models/cart.dart';
import 'package:shoenew/pages/product_detail_page.dart';

// ignore: must_be_immutable
class ShoeTile extends StatelessWidget {
  Shoe shoe;
  final VoidCallback onAddTap;

  ShoeTile({
    super.key,
    required this.shoe,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    bool isFav = cart.isFavorite(shoe);

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
                    padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        shoe.imagePath,
                        fit: BoxFit.cover,
                        height: 180,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 15,
                  right: 15,
                  child: GestureDetector(
                    onTap: () {
                      if (isFav) {
                        cart.removeFromWishlist(shoe);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${shoe.name} removed from wishlist!')),
                        );
                      } else {
                        cart.addToWishlist(shoe);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${shoe.name} added to wishlist!')),
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

            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 0.0, bottom: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shoe.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '\$' + shoe.price,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),

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