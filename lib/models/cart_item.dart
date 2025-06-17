import 'package:shoenew/models/shoe.dart';

class CartItem {
  Shoe shoe;
  int quantity;
  String selectedSize;

  CartItem({required this.shoe, this.quantity = 1, required this.selectedSize});

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