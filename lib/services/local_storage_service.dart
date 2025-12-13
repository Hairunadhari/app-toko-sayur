import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoenew/models/cart_item.dart';
import 'package:shoenew/models/booking_detail.dart';

class LocalStorageService {
  static const String _cartPrefix = 'cart_';
  static const String _ordersPrefix = 'orders_';

  // Save cart items for a specific user
  Future<void> saveCart(String userId, List<CartItem> cartItems) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = cartItems.map((item) => item.toJson()).toList();
      final cartString = jsonEncode(cartJson);
      await prefs.setString('$_cartPrefix$userId', cartString);
    } catch (e) {
      print('Error saving cart: $e');
    }
  }

  // Load cart items for a specific user
  Future<List<CartItem>> loadCart(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartString = prefs.getString('$_cartPrefix$userId');

      if (cartString == null || cartString.isEmpty) {
        return [];
      }

      final List<dynamic> cartJson = jsonDecode(cartString);
      return cartJson.map((item) => CartItem.fromJson(item)).toList();
    } catch (e) {
      print('Error loading cart: $e');
      return [];
    }
  }

  // Save orders for a specific user
  Future<void> saveOrders(String userId, List<BookingDetail> orders) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersJson = orders.map((order) => order.toJson()).toList();
      final ordersString = jsonEncode(ordersJson);
      await prefs.setString('$_ordersPrefix$userId', ordersString);
    } catch (e) {
      print('Error saving orders: $e');
    }
  }

  // Load orders for a specific user
  Future<List<BookingDetail>> loadOrders(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersString = prefs.getString('$_ordersPrefix$userId');

      if (ordersString == null || ordersString.isEmpty) {
        return [];
      }

      final List<dynamic> ordersJson = jsonDecode(ordersString);
      return ordersJson.map((order) => BookingDetail.fromJson(order)).toList();
    } catch (e) {
      print('Error loading orders: $e');
      return [];
    }
  }

  // Clear all data for a specific user (used on logout)
  Future<void> clearUserData(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('$_cartPrefix$userId');
      await prefs.remove('$_ordersPrefix$userId');
    } catch (e) {
      print('Error clearing user data: $e');
    }
  }

  // Clear all cart and order data (for all users)
  Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      for (String key in keys) {
        if (key.startsWith(_cartPrefix) || key.startsWith(_ordersPrefix)) {
          await prefs.remove(key);
        }
      }
    } catch (e) {
      print('Error clearing all data: $e');
    }
  }
}
