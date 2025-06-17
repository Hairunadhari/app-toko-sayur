import 'package:flutter/material.dart';
import 'package:shoenew/components/bottom_nav_bar.dart';
import 'package:shoenew/pages/shop_page.dart';
import 'package:shoenew/pages/cart_page.dart';
import 'package:shoenew/pages/products_page.dart';
import 'package:shoenew/pages/settings_page.dart';
import 'package:shoenew/pages/profile_page.dart';
import 'package:shoenew/pages/intro_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const ShopPage(),
    const CartPage(),
    const ProductsPage(),
    const SettingsPage(),
    const ProfilePage(),
  ];

  void signOut() async {
    print('User signed out (placeholder)');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const IntroPage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      bottomNavigationBar: MyBottomNavBar(
        onTabChange: (index) => navigateBottomBar(index),
        selectedIndex: _selectedIndex,
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Icon(
                Icons.menu,
                color: Colors.black,
              ),
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
          backgroundColor: Colors.grey[900],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column( // Bagian atas Drawer
                children: [
                  // Logo Nike
                  DrawerHeader(
                    child: Image.asset(
                        'lib/images/Logo.png',
                        color: Colors.white
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Divider(
                      color: Colors.grey[800],
                    ),
                  ),

                  // Pesanan Saya
                  Padding( // <-- HAPUS 'const' DI SINI
                    padding: const EdgeInsets.only(left: 25.0),
                    child: ListTile( // <-- HAPUS 'const' DI SINI
                      leading: const Icon(Icons.receipt_long, color: Colors.white),
                      title: const Text('My Orders', style: TextStyle(color: Colors.white)),
                      onTap: () { // Fungsi literal ini tidak konstan
                        // TODO: Navigasi ke halaman Pesanan Saya
                        Navigator.pop(context); // Tutup drawer
                        print('My Orders clicked');
                      },
                    ),
                  ),

                  // Daftar Keinginan
                  Padding( // <-- HAPUS 'const' DI SINI
                    padding: const EdgeInsets.only(left: 25.0),
                    child: ListTile( // <-- HAPUS 'const' DI SINI
                      leading: const Icon(Icons.favorite_border, color: Colors.white),
                      title: const Text('My Wishlist', style: TextStyle(color: Colors.white)),
                      onTap: () { // Fungsi literal ini tidak konstan
                        // TODO: Navigasi ke halaman Daftar Keinginan
                        Navigator.pop(context); // Tutup drawer
                        print('My Wishlist clicked');
                      },
                    ),
                  ),

                  // Bantuan & Dukungan
                  Padding( // <-- HAPUS 'const' DI SINI
                    padding: const EdgeInsets.only(left: 25.0),
                    child: ListTile( // <-- HAPUS 'const' DI SINI
                      leading: const Icon(Icons.help_outline, color: Colors.white),
                      title: const Text('Help & Support', style: TextStyle(color: Colors.white)),
                      onTap: () { // Fungsi literal ini tidak konstan
                        // TODO: Navigasi ke halaman Bantuan & Dukungan
                        Navigator.pop(context); // Tutup drawer
                        print('Help & Support clicked');
                      },
                    ),
                  ),

                  // Tentang Kami
                  Padding( // <-- HAPUS 'const' DI SINI
                    padding: const EdgeInsets.only(left: 25.0),
                    child: ListTile( // <-- HAPUS 'const' DI SINI
                      leading: const Icon(
                        Icons.info,
                        color: Colors.white,
                      ),
                      title: const Text(
                        'About',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () { // Fungsi literal ini tidak konstan
                        // TODO: Navigasi ke halaman Tentang Kami
                        Navigator.pop(context); // Tutup drawer
                        print('About clicked');
                      },
                    ),
                  ),
                ],
              ),

              // Tombol Logout di paling bawah
              Padding( // <-- HAPUS 'const' DI SINI
                padding: const EdgeInsets.only(left: 25.0, bottom: 25),
                child: ListTile( // <-- HAPUS 'const' DI SINI
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: signOut,
                ),
              ),
            ],
          )
      ),
      body: _pages[_selectedIndex],
    );
  }
}