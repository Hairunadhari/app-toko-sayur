import 'package:shoenew/models/cart_item.dart';

class BookingDetail {
  final String bookingId;
  final String date;
  final String totalAmount;
  final String barcodeImagePath;
  final List<CartItem> bookedItems;

  BookingDetail({
    required this.bookingId,
    required this.date,
    required this.totalAmount,
    required this.barcodeImagePath,
    required this.bookedItems,
  });
}