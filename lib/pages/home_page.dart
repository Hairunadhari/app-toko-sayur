import 'package:flutter/material.dart';
import 'package:shoenew/components/bottom_nav_bar.dart';
import 'package:shoenew/pages/shop_page.dart';
import 'package:shoenew/pages/cart_page.dart';
import 'package:shoenew/pages/products_page.dart';
import 'package:shoenew/pages/settings_page.dart';
import 'package:shoenew/pages/profile_page.dart';
import 'package:shoenew/pages/intro_page.dart';
import 'package:shoenew/pages/wishlist_page.dart';
import 'package:shoenew/pages/my_orders_page.dart';

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

  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Shop';
      case 1:
        return 'My Cart';
      case 2:
        return 'All Products';
      case 3:
        return 'Settings';
      case 4:
        return 'Profile';
      default:
        return 'ShoeNew App';
    }
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
        backgroundColor: Colors.grey[100],
        elevation: 1,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(Icons.menu, color: Colors.black),
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: Text(
          _getAppBarTitle(),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey[900],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                DrawerHeader(
                  child: Image.asset(
                    'lib/images/Logo.png',
                    color: Colors.white,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Divider(color: Colors.grey[800]),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    leading: const Icon(
                      Icons.receipt_long,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'My Orders',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyOrdersPage(),
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    leading: const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'My Wishlist',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WishlistPage(),
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    leading: const Icon(
                      Icons.help_outline,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Help & Support',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pop(context);

                      print('Help & Support clicked');
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    leading: const Icon(Icons.info, color: Colors.white),
                    title: const Text(
                      'About',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pop(context);

                      print('About clicked');
                    },
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(left: 25.0, bottom: 25),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: signOut,
              ),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
