import 'package:flutter/material.dart';
import 'package:shoenew/models/shoe.dart';
import 'package:shoenew/models/cart_item.dart';
import 'package:shoenew/models/booking_detail.dart';

class Cart extends ChangeNotifier {
  // list of shoes for sale
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
      name: 'Nike Kids - Black',
      price: '125',
      imagePath: 'lib/images/NikeKids-black.png',
      description: 'Vintage Look',
      gender: 'Kids',
      availableSizes: ['K 1', 'K 2', 'K 3'],
    ),
    Shoe(
      name: 'Nike Kids - Blue',
      price: '135',
      imagePath: 'lib/images/NikeKids-blue.png',
      description: 'Vintage Look',
      gender: 'Kids',
      availableSizes: ['K 1', 'K 2', 'K 3'],
    ),
    Shoe(
      name: 'Nike Kids - White',
      price: '120',
      imagePath: 'lib/images/NikeKids-white.png',
      description: 'Vintage Look',
      gender: 'Kids',
      availableSizes: ['K 1', 'K 2', 'K 3'],
    ),
    Shoe(
      name: 'Nike Run',
      price: '130',
      imagePath: 'lib/images/NikeRunW.png',
      description: 'Vintage Look',
      gender: 'Women',
      availableSizes: ['US 6', 'US 7', 'US 8'],
    ),
  ];

  List<CartItem> _userCart = [];

  // --- WISHLIST RELATED PROPERTIES & METHODS ---
  List<Shoe> _wishlist = [];

  // --- DATA PROFIL DAN ALAMAT PENGIRIMAN ---
  String _userName = 'Alif Minda';
  String _userEmail = 'alifmind@badassatron.com';
  String _userPhone = '+62 812 3456 7890';
  String _deliveryAddress = '92 High Street, Depok';
  String _userAvatarUrl = 'https://via.placeholder.com/150';

  // --- NEW: PAST BOOKINGS ---
  List<BookingDetail> _pastBookings = [];

  // --- GETTERS YANG BENAR ---
  List<Shoe> get shoeShop => _shoeShop;
  List<CartItem> get userCart => _userCart;
  List<Shoe> get wishlist => _wishlist;
  List<BookingDetail> get pastBookings => _pastBookings;

  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userPhone => _userPhone;
  String get deliveryAddress => _deliveryAddress;
  String get userAvatarUrl => _userAvatarUrl;

  // --- METODE WISHLIST ---
  void addToWishlist(Shoe shoe) {
    if (!_wishlist.contains(shoe)) {
      _wishlist.add(shoe);
      notifyListeners();
    }
  }

  void removeFromWishlist(Shoe shoe) {
    _wishlist.remove(shoe);
    notifyListeners();
  }

  bool isFavorite(Shoe shoe) {
    return _wishlist.contains(shoe);
  }
  // --- AKHIR WISHLIST ---

  // --- METODE PROFIL ---
  void updateProfile({String? name, String? email, String? phone, String? address, String? avatarUrl}) {
    if (name != null) _userName = name;
    if (email != null) _userEmail = email;
    if (phone != null) _userPhone = phone;
    if (address != null) _deliveryAddress = address;
    if (avatarUrl != null) _userAvatarUrl = avatarUrl;
    notifyListeners();
  }
  // --- AKHIR PROFIL ---

  // --- METODE KERANJANG UTAMA ---
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

  void removeItemFromCart(CartItem cartItem) {
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
  // --- AKHIR METODE KERANJANG UTAMA ---

  // --- METODE BOOKING ---
  void addBooking(BookingDetail booking) {
    _pastBookings.add(booking);
    notifyListeners();
  }

  String calculateTotal() {
    double total = 0;
    for (var item in _userCart) {
      total += double.parse(item.shoe.price) * item.quantity;
    }
    return total.toStringAsFixed(2);
  }
// --- AKHIR METHOD BOOKING ---
}