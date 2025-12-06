import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../components/shoe_tile.dart';
import 'package:shoenew/models/cart.dart';
import 'package:shoenew/models/shoe.dart';
import 'dart:async';

import 'package:shoenew/controllers/product_controller.dart';
import 'package:shoenew/models/product.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final ProductController productController = Get.put(ProductController());

  void addItemToCart(Shoe item, String quantityUnit) {
    Provider.of<Cart>(context, listen: false).addItemToCart(item, quantityUnit);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${item.name} (${quantityUnit}) Successfully added to Cart',
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  final List<String> _categories = [
    'All',
    'Vegetables',
    'Fruits',
    'Spices',
    'Root Crops',
  ];
  String _selectedCategory = 'All';

  static const int _flashSaleLimit = 5;

  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, dynamic>> _bannerData = [
    {
      'title': 'Limited Time Offer',
      'subtitle': 'Delivery is 50% cheaper',
      'color': Colors.black87,
      'icon': Icons.discount,
    },
    {
      'title': 'New Arrivals',
      'subtitle': 'Explore the latest collection!',
      'color': Colors.blueGrey[800],
      'icon': Icons.fiber_new,
    },
    {
      'title': 'Member Exclusive',
      'subtitle': 'Extra 10% off for members!',
      'color': Colors.grey[800],
      'icon': Icons.loyalty,
    },
  ];

  @override
  void initState() {
    super.initState();
    productController.fetchProducts();

    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_pageController.hasClients) {
        if (_currentPage < _bannerData.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _showUnitSelectionDialog(Shoe item) {
    const List<String> availableUnits = ['1 Kg', '500 g', '1 Pc'];
    String? tempSelectedUnit = availableUnits.first;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateInDialog) {
            return AlertDialog(
              title: Text('Select Unit for ${item.name}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Available Units:'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: availableUnits.map((unit) {
                      final bool isSelected = tempSelectedUnit == unit;
                      return GestureDetector(
                        onTap: () {
                          setStateInDialog(() {
                            tempSelectedUnit = unit;
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
                    if (tempSelectedUnit != null) {
                      addItemToCart(item, tempSelectedUnit!);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a unit!')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Text('Add to Cart'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Shoe _mapProductToItem(Product product) {
    return Shoe(
      name: product.name,
      price: product.price.toString(),
      imagePath: product.imageUrl,

      gender: _getCategoryFromId(product.categoryId),

      availableSizes: const ['1 Kg', '500 g', '1 Pc'],
      description: product.description,
    );
  }

  String _getCategoryFromId(int categoryId) {
    switch (categoryId) {
      case 9:
        return 'Vegetables';
      case 10:
        return 'Fruits';
      case 11:
        return 'Spices';
      case 12:
        return 'Root Crops';
      default:
        return 'All';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return Obx(() {
          if (productController.isLoading.value &&
              productController.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Product> allProducts = productController.products.toList();

          if (allProducts.isEmpty) {
            return const Center(child: Text('No products available.'));
          }

          List<Product> filteredProducts = allProducts.where((product) {
            final String productCategory = _getCategoryFromId(
              product.categoryId,
            );
            if (_selectedCategory == 'All') {
              return true;
            }

            return productCategory == _selectedCategory;
          }).toList();

          List<Product> flashSaleRawProducts = filteredProducts
              .take(_flashSaleLimit)
              .toList();

          List<Shoe> flashSaleItems = flashSaleRawProducts
              .map(_mapProductToItem)
              .toList();

          return Scaffold(
            backgroundColor: Colors.grey[200],
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  pinned: true,
                  leading: const SizedBox.shrink(),
                  toolbarHeight: 0,
                  collapsedHeight: 0,
                  expandedHeight: 200,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Padding(
                      padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Delivery address',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        cart.deliveryAddress,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.notifications_none,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search for Fresh Produce',
                                hintStyle: TextStyle(color: Colors.grey[600]),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey[600],
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12.0,
                                ),
                              ),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25.0,
                    vertical: 20.0,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: SizedBox(
                      height: 150,
                      child: Stack(
                        children: [
                          PageView.builder(
                            controller: _pageController,
                            itemCount: _bannerData.length,
                            onPageChanged: (int page) {
                              setState(() {
                                _currentPage = page;
                              });
                            },
                            itemBuilder: (context, index) {
                              final banner = _bannerData[index];
                              return Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: banner['color'] as Color,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          banner['title'] as String,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          banner['subtitle'] as String,
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              0.8,
                                            ),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      banner['icon'] as IconData,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          Positioned(
                            bottom: 10,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(_bannerData.length, (
                                index,
                              ) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                  ),
                                  height: 8.0,
                                  width: _currentPage == index ? 24.0 : 8.0,
                                  decoration: BoxDecoration(
                                    color: _currentPage == index
                                        ? Colors.black
                                        : Colors.grey[400],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25.0,
                    vertical: 20.0,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Product Categories',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: const Text(
                                'See All',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 8,
                                  ),
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: _selectedCategory == category
                                        ? Colors.black
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    category,
                                    style: TextStyle(
                                      color: _selectedCategory == category
                                          ? Colors.white
                                          : Colors.grey[800],
                                      fontWeight: _selectedCategory == category
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25.0,
                    vertical: 0.0,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Hot Picks 🔥',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'See All',
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: const SizedBox(height: 20)),

                SliverPadding(
                  padding: const EdgeInsets.only(
                    left: 25.0,
                    right: 25.0,
                    bottom: 25.0,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: SizedBox(
                      height: 380,
                      child: productController.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : flashSaleItems.isEmpty
                          ? Center(
                              child: Text(
                                'No products available in this category.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: flashSaleItems.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                Shoe item = flashSaleItems[index];
                                return ShoeTile(
                                  shoe: item,
                                  onAddTap: () =>
                                      _showUnitSelectionDialog(item),
                                );
                              },
                            ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
