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

  // Convert BookingDetail to JSON
  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'date': date,
      'totalAmount': totalAmount,
      'barcodeImagePath': barcodeImagePath,
      'bookedItems': bookedItems.map((item) => item.toJson()).toList(),
    };
  }

  // Create BookingDetail from JSON
  factory BookingDetail.fromJson(Map<String, dynamic> json) {
    return BookingDetail(
      bookingId: json['bookingId'] ?? '',
      date: json['date'] ?? '',
      totalAmount: json['totalAmount'] ?? '0',
      barcodeImagePath: json['barcodeImagePath'] ?? '',
      bookedItems:
          (json['bookedItems'] as List<dynamic>?)
              ?.map((item) => CartItem.fromJson(item))
              .toList() ??
          [],
    );
  }
}
