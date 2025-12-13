import 'package:shoenew/models/shoe.dart';

class CartItem {
  Shoe shoe;
  int quantity;
  String selectedSize;

  CartItem({required this.shoe, this.quantity = 1, required this.selectedSize});

  // Convert CartItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'shoe': shoe.toJson(),
      'quantity': quantity,
      'selectedSize': selectedSize,
    };
  }

  // Create CartItem from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      shoe: Shoe.fromJson(json['shoe']),
      quantity: json['quantity'] ?? 1,
      selectedSize: json['selectedSize'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          shoe == other.shoe &&
          selectedSize == other.selectedSize;

  @override
  int get hashCode => shoe.hashCode ^ selectedSize.hashCode;
}
