import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/shoe_tile.dart';
import 'package:shoenew/models/cart.dart';
import 'package:shoenew/models/shoe.dart';
import 'dart:async';
import 'package:shoenew/pages/products_page.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  // Method untuk menambahkan sepatu ke keranjang
  void addShoeToCart(Shoe shoe, String selectedSize) {
    Provider.of<Cart>(context, listen: false).addItemToCart(shoe, selectedSize);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${shoe.name} (Size: $selectedSize) berhasil ditambahkan ke keranjang!'),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  final List<String> _categories = ['All', 'Men', 'Women', 'Kids'];
  String _selectedCategory = 'All';

  // Batasan jumlah produk untuk Flash Sale
  static const int _flashSaleLimit = 5;

  // --- SLIDESHOW RELATED VARIABLES ---
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
  // --- END SLIDESHOW RELATED VARIABLES ---


  // Metode untuk menampilkan pop-up pemilihan ukuran
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

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        List<Shoe> allAvailableShoes = cart.shoeShop;

        List<Shoe> filteredShoes = allAvailableShoes.where((shoe) {
          if (_selectedCategory == 'All') {
            return true;
          }
          return shoe.gender == _selectedCategory;
        }).toList();

        List<Shoe> flashSaleShoes = [];
        if (filteredShoes.isNotEmpty) {
          flashSaleShoes = filteredShoes.take(_flashSaleLimit).toList();
        }

        if (allAvailableShoes.isEmpty) {
          return const Center(child: Text('No products available locally.'));
        }

        return Scaffold(
          backgroundColor: Colors.grey[200],
          body: CustomScrollView(
            slivers: [
              // --- APP BAR DENGAN LOKASI DAN SEARCH BAR ---
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
                        // Delivery Address & Notification Icon
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
                                  child: const Icon(Icons.location_on_outlined, color: Colors.black),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Delivery address',
                                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
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
                              child: const Icon(Icons.notifications_none, color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Search Bar
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search the entire shop',
                              hintStyle: TextStyle(color: Colors.grey[600]),
                              prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                            ),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // --- SLIDESHOW SECTION ---
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
                sliver: SliverToBoxAdapter(
                  child: SizedBox(
                    height: 150, // Tinggi PageView banner
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  Icon(banner['icon'] as IconData, color: Colors.white, size: 40),
                                ],
                              ),
                            );
                          },
                        ),
                        // Indikator Halaman (Dots)
                        Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(_bannerData.length, (index) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                height: 8.0,
                                width: _currentPage == index ? 24.0 : 8.0,
                                decoration: BoxDecoration(
                                  color: _currentPage == index ? Colors.black : Colors.grey[400],
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

              // --- Categories Section ---
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Categories',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Aksi untuk "See All" Categories
                            },
                            child: const Text(
                              'See All',
                              style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
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
                    ],
                  ),
                ),
              ),

              // --- Flash Sale / Hot Picks Heading ---
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0.0),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Flash Sale 🔥',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Aksi untuk "See All" Flash Sale
                        },
                        child: const Text(
                          'See All',
                          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(child: const SizedBox(height: 20)),

              // --- SHOE TILES LIST (Flash Sale Section) ---
              SliverPadding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 25.0),
                sliver: SliverToBoxAdapter(
                  child: SizedBox(
                    height: 380,
                    child: flashSaleShoes.isEmpty
                        ? Center(
                      child: Text(
                        'No shoes available for Flash Sale in this category.',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    )
                        : ListView.builder(
                      itemCount: flashSaleShoes.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        Shoe shoe = flashSaleShoes[index];
                        return ShoeTile(
                          shoe: shoe,
                          onAddTap: () => _showSizeSelectionDialog(shoe),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}