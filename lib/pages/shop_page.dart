import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../components/shoe_tile.dart';
import 'package:shoenew/models/cart.dart';
import 'package:shoenew/models/shoe.dart';
import 'dart:async';

import 'package:shoenew/controllers/product_controller.dart';
import 'package:shoenew/models/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Map<String, dynamic>? profileData;

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final ProductController productController = Get.put(ProductController());

  // --- Fungsi ini sekarang dipanggil langsung oleh ShoeTile ---
  void addItemToCart(Shoe item, String quantityUnit) {
    Provider.of<Cart>(context, listen: false).addItemToCart(item, quantityUnit);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${item.name} (${quantityUnit}) Berhasil dimasukkan ke keranjang',
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  final List<String> _categories = [
    'Semua Produk',
    'Sayuran',
    'Buah-buahan',
    'Umbi-umbian',
  ];
  // Perbaiki typo: 'Semaaua Produk' -> 'Semua Produk'
  String _selectedCategory = 'Semua Produk'; 

  String _mapCategoryToType(String category) {
    switch (category) {
      case 'Sayuran':
        return 'Sayur';
      case 'Buah-buahan':
        return 'Buah';
      case 'Umbi-umbian':
        return 'Umbi';
      default:
        return '';
    }
  }

  static const int _flashSaleLimit = 5;

  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;


final List<Map<String, dynamic>> _bannerData = [
  {
    'title': 'Promo Panen!',
    'subtitle': 'Diskon hingga 40% untuk buah segar.',
    // Menggunakan Kuning Keemasan untuk kesan manis
    'color': Colors.black, 
    'icon': Icons.apple,
    'imageUrl': 'lib/images/banner1.jpeg', 
  },
  {
    'title': 'Sayur Segar Hari Ini',
    'subtitle': 'Stok baru, langsung dari petani!',
    // Menggunakan Hijau Kebiruan yang terlihat sejuk
    'color': Colors.black, 
    'icon': Icons.eco,
    'imageUrl': 'lib/images/banner2.jpg', 
  },
  {
    'title': 'Paket Hemat Belanja',
    'subtitle': 'Belanja lebih hemat dengan bundling sayur & buah.',
    // Menggunakan Coklat Tanah untuk kesan "earthy"
    'color': Colors.black, 
    'icon': Icons.shopping_basket,
    'imageUrl': 'lib/images/banner3.jpg', 
  },
];

 final supabase = Supabase.instance.client;
Map<String, dynamic>? userProfile; // Variabel untuk menyimpan data profil
bool isProfileLoading = true;
  @override
  void initState() {
    super.initState();
    productController.fetchProducts();

// Ambil data profil saat inisialisasi
  _loadUserProfile();

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

// Fungsi untuk mendapatkan session dan fetch data
Future<void> _loadUserProfile() async {
  final user = supabase.auth.currentUser;
  if (user != null) {
    final data = await fetchUserProfile(user.id);
    if (mounted) {
      setState(() {
        userProfile = data;
        isProfileLoading = false;
      });
    }
  } else {
    setState(() => isProfileLoading = false);
  }
}

// Tambahkan fungsi fetchUserProfile Anda di sini
Future<Map<String, dynamic>?> fetchUserProfile(String userId) async {
  try {
    final response = await supabase
        .from('users')
        .select('name, phone, address')
        .eq('id', userId)
        .single();

    print('✅ Supabase Fetch SUCCESS. Data: $response');
    return response as Map<String, dynamic>;
  } catch (e) {
    print('❌ Supabase Fetch FAILED. Error: $e');
    return null;
  }
}

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // --- FUNGSI _showUnitSelectionDialog DIHAPUS ---

  Shoe _mapProductToItem(Product product) {
    return Shoe(
      name: product.name,
      price: product.price.toString(),
      imagePath: product.imageUrl,

      gender: _getCategoryFromId(product.categoryId),

      // Satuan unit di Shoe seharusnya tidak diperlukan jika hanya ada satu default
      // Tapi karena struktur data Shoe mengharuskannya, kita biarkan saja.
      availableSizes: const ['1 Kg'], 
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

          // Products are already filtered by the controller
          List<Product> flashSaleRawProducts = allProducts
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
                                      color: Color(0xFF2E7D32),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Alamat Pengriman',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        // Logika tampilan: Cek loading -> Cek data -> Cek address field
                                        isProfileLoading 
                                            ? 'Memuat...' 
                                            : (userProfile != null && userProfile!['address'] != null)
                                                ? userProfile!['address']
                                                : 'Belum diatur',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16, // Ukuran sedikit disesuaikan agar tidak overflow jika alamat panjang
                                          color: Colors.black87, // Ganti dari grey agar lebih terbaca
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
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
                                  color: Color(0xFF2E7D32),
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
                                hintText:
                                    'Cari buah, sayur, atau produk segar...',
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
                              style: const TextStyle(color: Color(0xFF2E7D32)),
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
                            // ... di dalam Widget build() -> PageView.builder -> itemBuilder

                            itemBuilder: (context, index) {
                              final banner = _bannerData[index];
                              
                              return Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  
                                  image: DecorationImage(
                                    image: AssetImage(banner['imageUrl']),
                                    fit: BoxFit.cover, 
                                    
                                    // Gunakan ColorFilter mode 'darken' dengan Black transparan
                                    colorFilter: ColorFilter.mode(
                                      // Hitam dengan opasitas 0.6 (sedikit gelap)
                                      Colors.black.withOpacity(0.6), 
                                      BlendMode.darken, // Mencerahkan gambar untuk efek gelap transparan
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      banner['title'],
                                      style: const TextStyle(
                                        // Teks Putih agar kontras
                                        color: Colors.white, 
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      banner['subtitle'],
                                      style: TextStyle(
                                        // Teks Putih transparan
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
// ...
                          ),
                          
                          // ... (Dot indicators tetap sama)
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
                                        ? const Color(0xFF2E7D32)
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
                              'Kategori Produk',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: const Text(
                                'Lihat Semua',
                                style: TextStyle(
                                  color: Color(0xFF2E7D32),
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
                                  // Fetch products based on selected category
                                  if (category == 'Semua Produk') {
                                    productController.fetchProducts();
                                  } else {
                                    String type = _mapCategoryToType(category);
                                    productController.fetchProductsByType(type);
                                  }
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
                                        ? const Color(0xFF2E7D32)
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
                          'Favorit Pembeli 🥝',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Lihat Semua',
                            style: TextStyle(
                              color: Color(0xFF2E7D32),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),

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
                                      // --- PERUBAHAN UTAMA DI SINI ---
                                      // Panggil addItemToCart langsung dengan unit default
                                      onAddTap: () => addItemToCart(item, '1 Kg'), 
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