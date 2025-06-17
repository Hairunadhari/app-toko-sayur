import 'package:flutter/material.dart';
import 'package:shoenew/models/shoe.dart';
import 'package:shoenew/models/cart_item.dart';

class Cart extends ChangeNotifier {
  // list of shoes for sale
  // SETIAP Shoe memiliki `availableSizes` yang terdefinisi
  final List<Shoe> _shoeShop = [
    Shoe(
      name: 'Nike Air Jordan 11',
      price: '250',
      imagePath: 'lib/images/AirDunk.png',
      description: 'Step into greatness. The Air Jordan 11 delivers a premium look and unmatched comfort, built for legends on off the court.',
      gender: 'Men',
      availableSizes: ['US 7', 'US 8', 'US 9', 'US 10', 'US 11'],
    ),
    Shoe(
      name: 'Nike Air Jordan 37',
      price: '240',
      imagePath: 'lib/images/AirJordan37.png',
      description: 'The future of flight meets iconic heritage. The Air Jordan 37 blends cutting-edge performance tech with design cues from the legendary AJ7. Experience innovation.',
      gender: 'Women',
      availableSizes: ['US 5', 'US 6', 'US 7', 'US 8', 'US 9'],
    ),
    Shoe(
      name: 'Nike Air Force 1',
      price: '180',
      imagePath: 'lib/images/AirForce.png',
      description: 'Elevate your everyday. The Air Force 1 offers legendary comfort and unmatched versatility, taking you from casual to street-chic with ease.',
      gender: 'Unisex',
      availableSizes: ['US 6', 'US 7', 'US 8', 'US 9', 'US 10', 'US 11'],
    ),
    Shoe(
      name: 'Nike Dunk Low',
      price: '170',
      imagePath: 'lib/images/DunkLow.png',
      description: 'Effortless cool, perfected. The Nike Dunk Low offers classic color-blocking and comfortable wear, ready for any outfit, any day.',
      gender: 'Men',
      availableSizes: ['US 7', 'US 8', 'US 9', 'US 10'],
    ),
    Shoe(
      name: 'Nike Court Low',
      price: '150',
      imagePath: 'lib/images/NikeCourtL.png',
      description: 'Your new go-to. The Nike Court Low offers a sleek, low-profile design and easy-wearing comfort for effortless style, every day.',
      gender: 'Woman',
      availableSizes: ['US 5', 'US 6', 'US 7'],
    ),
    Shoe(
      name: 'Nike Court Women',
      price: '135',
      imagePath: 'lib/images/NikeCourtW.png',
      description: 'Step into heritage style designed for her. Nike Court Women`s shoes deliver plush comfort and timeless court-inspired designs, perfect for a chic yet relaxed vibe.',
      gender: 'Women',
      availableSizes: ['US 5', 'US 6', 'US 7', 'US 8'],
    ),
    Shoe(
      name: 'Nike Dunk',
      price: '180',
      imagePath: 'lib/images/NikeDunk.png',
      description: 'The iconic Nike Dunk. Born on the court, perfected on the streets. A timeless silhouette with unmatched hype. Don`t just wear a shoe, wear a legend.',
      gender: 'Women',
      availableSizes: ['US 6', 'US 7', 'US 8', 'US 9'],
    ),
    Shoe(
      name: 'Nike Dunk High',
      price: '250',
      imagePath: 'lib/images/NikeDunkHigh.png',
      description: 'Step up your game. With its padded high-top collar, the Nike Dunk High offers a secure feel and undeniable retro cool, blending court comfort with street-ready flair.',
      gender: 'Men',
      availableSizes: ['US 8', 'US 9', 'US 10', 'US 11'],
    ),
    Shoe(
      name: 'Nike Revolution 7',
      price: '125',
      imagePath: 'lib/images/NikeKids-black.png',
      description: 'Nike Revolution 7. Smooth comfort. Easy miles. Your essential everyday runner.',
      gender: 'Kids',
      availableSizes: ['K 1', 'K 2', 'K 3'],
    ),
    Shoe(
      name: ' Nike Air Max TW',
      price: '135',
      imagePath: 'lib/images/NikeKids-blue.png',
      description: 'Nike Air Max TW. Max Air. Max Style. Unleash your bold side.',
      gender: 'Kids',
      availableSizes: ['K 1', 'K 2', 'K 3'],
    ),
    Shoe(
      name: 'Nike Air Swoopes II',
      price: '120',
      imagePath: 'lib/images/NikeKids-white.png',
      description: 'Nike Air Swoopes II. Iconic design. Unforgettable style. A true legend.',
      gender: 'Kids',
      availableSizes: ['K 1', 'K 2', 'K 3'],
    ),
    Shoe(
      name: 'Nike Infinity RN 4',
      price: '130',
      imagePath: 'lib/images/NikeRunW.png',
      description: 'Nike Infinity RN 4. Max comfort. Max support. Your everyday run, reimagined.',
      gender: 'Men',
      availableSizes: ['US 6', 'US 7', 'US 8'],
    ),
  ];

  List<CartItem> _userCart = []; // List<CartItem>

  // --- DATA PROFIL DAN ALAMAT PENGIRIMAN ---
  // SEMUA INI NON-NULLABLE DAN PUNYA NILAI DEFAULT
  String _userName = 'Alif Minda';
  String _userEmail = 'alifmind@badassatron.com';
  String _userPhone = '+62 812 3456 7890';
  String _deliveryAddress = '92 High Street, Depok';
  String _userAvatarUrl = 'https://via.placeholder.com/150';

  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userPhone => _userPhone;
  String get deliveryAddress => _deliveryAddress;
  String get userAvatarUrl => _userAvatarUrl;

  void updateProfile({String? name, String? email, String? phone, String? address, String? avatarUrl}) {
    if (name != null) _userName = name;
    if (email != null) _userEmail = email;
    if (phone != null) _userPhone = phone;
    if (address != null) _deliveryAddress = address;
    if (avatarUrl != null) _userAvatarUrl = avatarUrl;
    notifyListeners();
  }

  List<Shoe> get shoeShop => _shoeShop;
  List<CartItem> get userCart => _userCart; // INI List<CartItem>

  void addItemToCart(Shoe shoe, String selectedSize) {
    bool found = false;
    for (var item in _userCart) {
      if (item.shoe == shoe && item.selectedSize == selectedSize) {
        item.quantity++;
        found = true;
        break;
      }
    }
    if (!found) {
      _userCart.add(CartItem(shoe: shoe, quantity: 1, selectedSize: selectedSize));
    }
    notifyListeners();
  }

  void removeItemFromCart(CartItem cartItem) { // PARAMETER CartItem
    _userCart.removeWhere((item) => item.shoe == cartItem.shoe && item.selectedSize == cartItem.selectedSize);
    notifyListeners();
  }

  void incrementQuantity(CartItem cartItem) {
    cartItem.quantity++;
    notifyListeners();
  }

  void decrementQuantity(CartItem cartItem) {
    if (cartItem.quantity > 1) {
      cartItem.quantity--;
    } else {
      _userCart.remove(cartItem);
    }
    notifyListeners();
  }

  void updateCartItemSize(CartItem oldItem, String newSize) {
    if (oldItem.selectedSize == newSize) return;

    CartItem? existingItemWithNewSize;
    for (var item in _userCart) {
      if (item.shoe == oldItem.shoe && item.selectedSize == newSize) {
        existingItemWithNewSize = item;
        break;
      }
    }

    if (existingItemWithNewSize != null) {
      existingItemWithNewSize.quantity += oldItem.quantity;
      _userCart.remove(oldItem);
    } else {
      oldItem.selectedSize = newSize;
    }
    notifyListeners();
  }

  String calculateTotal() {
    double total = 0;
    for (var item in _userCart) {
      total += double.parse(item.shoe.price) * item.quantity;
    }
    return total.toStringAsFixed(2);
  }
}