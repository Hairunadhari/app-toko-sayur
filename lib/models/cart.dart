import 'package:flutter/material.dart';
import 'package:shoenew/models/shoe.dart';
import 'package:shoenew/models/cart_item.dart';
import 'package:shoenew/models/booking_detail.dart';
import 'package:shoenew/services/local_storage_service.dart';

class Cart extends ChangeNotifier {
  final LocalStorageService _storageService = LocalStorageService();
  
  // 1. Pastikan ID pengguna dapat null sebelum login
  String? _currentUserId; 
  
  // list of shoes for sale (Data statis ini sudah bagus)
  final List<Shoe> _shoeShop = [
    
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

  // 2. Hapus nilai dummy (Alif Minda, dll.) agar data yang ditampilkan
  // di profile page benar-benar berasal dari hasil fetch atau string kosong/null
  String _userName = ''; 
  String _userEmail = '';
  String _userPhone = '';
  String _deliveryAddress = '';
  String _userAvatarUrl = ''; // Supaya placeholder di ProfilePage muncul jika kosong

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
  String? get currentUserId => _currentUserId; // Tambahkan getter untuk ID

  // --- METODE WISHLIST (Tidak ada perubahan, sudah benar) ---
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

  // --- METODE PROFIL (Sudah bagus dan aman) ---
  void updateProfile({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? avatarUrl,
  }) {
    if (name != null) _userName = name;
    if (email != null) _userEmail = email;
    if (phone != null) _userPhone = phone;
    if (address != null) _deliveryAddress = address;
    if (avatarUrl != null) _userAvatarUrl = avatarUrl;
    notifyListeners();
  }

  // 3. Tambahkan metode untuk mereset profil (berguna saat logout/clearUserData)
  void _resetProfile() {
    _userName = '';
    _userEmail = '';
    _userPhone = '';
    _deliveryAddress = '';
    _userAvatarUrl = '';
  }
  // --- AKHIR PROFIL ---

  // --- METODE INISIALISASI USER ---
  Future<void> initializeUser(String userId) async {
    _currentUserId = userId;

    // Load cart from storage
    _userCart = await _storageService.loadCart(userId);

    // Load orders from storage
    _pastBookings = await _storageService.loadOrders(userId);

    // CATATAN: Data Profil tidak dimuat di sini,
    // Melainkan di LoginController dan ProfilePage via AuthService.
    // Ini adalah pola yang tepat untuk memisahkan data Auth/Profile dari Cart logic.

    notifyListeners();
  }

  // Clear user data on logout
  Future<void> clearUserData() async {
    if (_currentUserId != null) {
      // 4. Clear data lokal pengguna yang tersimpan (keranjang & pesanan)
      await _storageService.clearUserData(_currentUserId!);
    }
    
    // Reset semua state lokal
    _currentUserId = null;
    _userCart = [];
    _pastBookings = [];
    _wishlist = []; // Reset wishlist juga
    _resetProfile(); // Reset data profil

    notifyListeners();
  }

  // Save cart to storage
  Future<void> _saveCartToStorage() async {
    // 5. Penanganan jika _currentUserId null (belum login)
    if (_currentUserId != null) {
      await _storageService.saveCart(_currentUserId!, _userCart);
    }
  }

  // Save orders to storage
  Future<void> _saveOrdersToStorage() async {
    // 5. Penanganan jika _currentUserId null (belum login)
    if (_currentUserId != null) {
      await _storageService.saveOrders(_currentUserId!, _pastBookings);
    }
  }
  // --- AKHIR INISIALISASI USER ---

  // --- METODE KERANJANG UTAMA (Sudah benar) ---
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
      _userCart.add(
        CartItem(shoe: shoe, quantity: 1, selectedSize: selectedSize),
      );
    }
    _saveCartToStorage();
    notifyListeners();
  }

  void removeItemFromCart(CartItem cartItem) {
    _userCart.removeWhere(
      (item) =>
          item.shoe == cartItem.shoe &&
          item.selectedSize == cartItem.selectedSize,
    );
    _saveCartToStorage();
    notifyListeners();
  }

  void incrementQuantity(CartItem cartItem) {
    cartItem.quantity++;
    _saveCartToStorage();
    notifyListeners();
  }

  void decrementQuantity(CartItem cartItem) {
    if (cartItem.quantity > 1) {
      cartItem.quantity--;
    } else {
      _userCart.remove(cartItem);
    }
    _saveCartToStorage();
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
    _saveCartToStorage();
    notifyListeners();
  }
  // --- AKHIR METODE KERANJANG UTAMA ---

  // --- METODE BOOKING (Sudah benar) ---
  void addBooking(BookingDetail booking) {
    _pastBookings.add(booking);
    _saveOrdersToStorage();

    // Clear cart after successful booking
    _userCart.clear();
    _saveCartToStorage();

    notifyListeners();
  }

  String calculateTotal() {
    double total = 0;
    for (var item in _userCart) {
      // Pastikan harga adalah string yang valid
      total += double.tryParse(item.shoe.price) ?? 0 * item.quantity;
    }
    return total.toStringAsFixed(2);
  }

  // --- AKHIR METHOD BOOKING ---
}