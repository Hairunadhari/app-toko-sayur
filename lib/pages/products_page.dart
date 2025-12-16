import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoenew/models/cart.dart';
import 'package:shoenew/models/shoe.dart';
import 'package:shoenew/pages/product_detail_page.dart';
import 'package:get/get.dart';
import 'package:shoenew/controllers/product_controller.dart';
import 'package:intl/intl.dart';
import 'package:shoenew/models/product.dart';

class ProductsPage extends StatefulWidget {
 const ProductsPage({super.key});

 @override
 State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
 final ProductController productController = Get.put(ProductController());

 // --- Definisi Warna Kustom (Burnt Orange) ---
 // Ini diambil dari diskusi sebelumnya untuk warna tombol Add
 static const Color burntOrange = Color(0xFFCC5500);

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
  final formattedString = formatter.format(numericPrice); 

  // KEMUDIAN, tambahkan '/kg' di belakangnya
  return '$formattedString / kg';
 }

 void addItemToCart(Shoe item, String selectedUnit) {
  Provider.of<Cart>(context, listen: false).addItemToCart(item, selectedUnit);

  ScaffoldMessenger.of(context).showSnackBar(
   SnackBar(
    content: Text(
     '${item.name} (Satuan: $selectedUnit) berhasil ditambahkan ke Keranjang!',
    ),
    duration: const Duration(seconds: 1),
    backgroundColor: Colors.green, // Warna konfirmasi hijau
    behavior: SnackBarBehavior.floating,
   ),
  );
 }

 // Menghapus pop-up karena permintaan Anda adalah menghilangkan dialog satuan.
 // Namun, saya biarkan fungsi ini (sebagai cadangan) jika sewaktu-waktu Anda ingin menggunakannya
 // Misalnya, saat user menekan tile, bukan tombol '+'.
 void _showUnitSelectionDialog(Shoe item) {
  String? tempSelectedUnit = item.availableSizes.isNotEmpty
    ? item.availableSizes.first
    : null;

  showDialog(
   context: context,
   builder: (context) {
    return StatefulBuilder(
     builder: (context, setStateInDialog) {
      return AlertDialog(
       title: Text('Pilih satuan untuk produk ${item.name}'),
       content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         const Text('Satuan yang tersedia:'),
         const SizedBox(height: 10),
         Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: item.availableSizes.map((unit) {
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
         child: const Text('Batal'),
        ),
        ElevatedButton(
         onPressed: () {
          if (tempSelectedUnit != null) {
           addItemToCart(item, tempSelectedUnit!);
           Navigator.pop(context);
          } else {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Silakan pilih satuan!')),
           );
          }
         },
         style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E7D32),
         ),
         child: const Text(
          '+ Masukkan ke keranjang',
          style: TextStyle(
           color: Colors.white, 
          ),
         ),
        ),
       ],
      );
     },
    );
   },
  );
 }

 final List<String> _categories = [
  'Semua Produk',
  'Sayuran',
  'Buah-buahan',
  'Umbi-umbian',
 ];
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

 String _getCategoryFromId(int categoryId) {
  switch (categoryId) {
   case 9:
    return 'Sayuran';
   case 10:
    return 'Buah-buahan';
   case 11:
    return 'Umbi-umbian';
   default:
    return 'Semua Produk';
  }
 }

 Shoe _mapProductToShoe(Product product) {
  return Shoe(
   name: product.name,
   price: product.price.toString(),
   imagePath: product.imageUrl,
   gender: _getCategoryFromId(product.categoryId),

   availableSizes: const ['1 Kg'],
   description: product.description,
  );
 }

 @override
 void initState() {
  super.initState();
  productController.fetchProducts();
 }

 @override
 Widget build(BuildContext context) {
  return Obx(() {
   if (productController.isLoading.value &&
     productController.products.isEmpty) {
    return const Center(child: CircularProgressIndicator());
   }

   List<Product> rawProducts = productController.products.toList();

   List<Shoe> allProducts = rawProducts.map(_mapProductToShoe).toList();

   if (allProducts.isEmpty) {
    return const Center(child: Text('Tidak ada produk tersedia.'));
   }

   return Scaffold(
    backgroundColor: Colors.grey[200],
    body: Padding(
     padding: const EdgeInsets.all(25.0),
     child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       SizedBox(
        height:
          MediaQuery.of(context).padding.top,
       ),
       const Text(
        'Semua Produk',
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
       const SizedBox(height: 20),

       Expanded(
        child: GridView.builder(
         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15.0,
          mainAxisSpacing: 15.0,

          mainAxisExtent: 350.0,
         ),
         itemCount: allProducts.length,
         shrinkWrap: true,
         physics: const AlwaysScrollableScrollPhysics(),
         itemBuilder: (context, index) {
          Shoe shoe = allProducts[index];
                    
                    // --- LOGIKA BARU UNTUK onAddTap ---
                    String defaultUnit = shoe.availableSizes.isNotEmpty 
                        ? shoe.availableSizes.first 
                        : '1 Pcs'; // Default aman

          return ProductGridTile(
           shoe: shoe,
           // Sekarang memanggil addItemToCart langsung dengan satuan default
           onAddTap: () => addItemToCart(shoe, defaultUnit), // <-- PERUBAHAN UTAMA
           onTileTap: () {
            Navigator.push(
             context,
             MaterialPageRoute(
              builder: (context) => ProductDetailPage(shoe: shoe),
             ),
            );
           },
           formatPrice: _formatPrice,
          );
         },
        ),
       ),
      ],
     ),
    ),
   );
  });
 }
}

class ProductGridTile extends StatelessWidget {
 final Shoe shoe;
 final VoidCallback onAddTap;
 final VoidCallback? onTileTap;
 final String Function(dynamic) formatPrice;

 const ProductGridTile({
  super.key,
  required this.shoe,
  required this.onAddTap,
  required this.formatPrice,
  this.onTileTap,
 });

 // --- Definisi Warna Kustom (Burnt Orange) ---
 static const Color burntOrange = Color(0xFFCC5500);

 @override
 Widget build(BuildContext context) {
  final cart = Provider.of<Cart>(context);
  bool isFav = cart.isFavorite(shoe);

  return GestureDetector(
   onTap: onTileTap,
   child: Container(
    decoration: BoxDecoration(
     color: Colors.white, // Diubah ke putih untuk hasil yang lebih baik
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
      ClipRRect(
       borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
       ),
       child: Stack(
        children: [
         SizedBox(
          height: 250,
          width: double.infinity,
          child: Image.network(
           shoe.imagePath,
           fit: BoxFit.cover,
           loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
             child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                   loadingProgress.expectedTotalBytes!
                : null,
             ),
            );
           },
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
              SnackBar(
               content: Text(
                '${shoe.name} dihapus dari daftar favorit!',
               ),
              ),
             );
            } else {
             cart.addToWishlist(shoe);
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
               content: Text('${shoe.name} ditambahkan ke daftar favorit!'),
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
             size: 20,
            ),
           ),
          ),
         ),
        ],
       ),
      ),

      Padding(
       padding: const EdgeInsets.all(10.0),
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(
          shoe.name,
          style: const TextStyle(
           fontWeight: FontWeight.bold,
           fontSize: 16,
           color: Colors.black,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
         ),
         const SizedBox(height: 8),
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
           Text(
            formatPrice(shoe.price),
            style: TextStyle(
             fontWeight: FontWeight.bold,
             color: Colors.grey[800],
            ),
           ),
           GestureDetector(
            onTap: onAddTap,
            child: Container(
             padding: const EdgeInsets.all(8),
             decoration: BoxDecoration(
              color: burntOrange, // Menggunakan warna Burnt Orange
              borderRadius: BorderRadius.circular(8),
             ),
             child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 20,
             ),
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