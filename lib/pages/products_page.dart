import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoenew/models/cart.dart';
import 'package:shoenew/models/shoe.dart';
import 'package:shoenew/pages/product_detail_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  void addShoeToCart(Shoe shoe, String selectedSize) {
    Provider.of<Cart>(context, listen: false).addItemToCart(shoe, selectedSize);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${shoe.name} (Size: $selectedSize) successfully added to Booking!'),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSizeSelectionDialog(Shoe shoe) {
    String? tempSelectedSize = shoe.availableSizes.isNotEmpty ? shoe.availableSizes.first : null;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateInDialog) {
            return AlertDialog(
              title: Text('Select Size for ${shoe.name}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Available Sizes:'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: shoe.availableSizes.map((size) {
                      final bool isSelected = tempSelectedSize == size;
                      return GestureDetector(
                        onTap: () {
                          setStateInDialog(() {
                            tempSelectedSize = size;
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
    if (tempSelectedSize != null) {
    addShoeToCart(shoe, tempSelectedSize!);
    Navigator.pop(context);
    } else {
    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Please select a size!')),
    );
    }
    },
    style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
    child: const Text('Add to Cart'),
    ),
    ],
    );
    },
    );
  },
  );
}

final List<String> _categories = ['All', 'Men', 'Women', 'Kids'];
String _selectedCategory = 'All';

@override
Widget build(BuildContext context) {
  final cart = Provider.of<Cart>(context);
  List<Shoe> allProducts = cart.shoeShop;

  List<Shoe> filteredShoes = allProducts.where((shoe) {
    return (shoe.gender == _selectedCategory) || (_selectedCategory == 'All');
  }).toList();

  // Pastikan `allProducts` tidak kosong sebelum menampilkan widget
  if (allProducts.isEmpty) {
    return const Center(child: Text('No products available locally.'));
  }

  return Scaffold(
    backgroundColor: Colors.grey[200],
    body: Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight + 10),
          const Text(
            'All Products',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                String category = _categories[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: _selectedCategory == category ? Colors.black : Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: _selectedCategory == category ? Colors.white : Colors.grey[800],
                          fontWeight: _selectedCategory == category ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15.0,
                  mainAxisSpacing: 15.0,
                  mainAxisExtent: 300.0,
                ),
                itemCount: filteredShoes.length,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  Shoe shoe = filteredShoes[index];
                  return ProductGridTile(
                    shoe: shoe,
                    onAddTap: () => _showSizeSelectionDialog(shoe),
                    onTileTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(shoe: shoe),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ProductGridTile definition (dalam file yang sama)
class ProductGridTile extends StatelessWidget {
  final Shoe shoe;
  final VoidCallback onAddTap;
  final VoidCallback? onTileTap;

  const ProductGridTile({
    super.key,
    required this.shoe,
    required this.onAddTap,
    this.onTileTap,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    bool isFav = cart.isFavorite(shoe);

    return GestureDetector(
      onTap: onTileTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      shoe.imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
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
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shoe.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$' + shoe.price,
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800]),
                      ),
                      GestureDetector(
                        onTap: onAddTap,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.add, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
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