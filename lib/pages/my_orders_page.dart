import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoenew/models/cart.dart';
import 'package:shoenew/models/booking_detail.dart';
import 'package:shoenew/models/cart_item.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  void _showBookingDetailsDialog(BuildContext context, BookingDetail booking) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Booking Details', textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  booking.barcodeImagePath,
                  height: 150,
                  width: 250,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                Text('Booking ID: #${booking.bookingId}'),
                Text('Date: ${booking.date}'),
                Text('Total: \$${booking.totalAmount}'),
                const SizedBox(height: 20),
                const Text('Items Booked:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: booking.bookedItems.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text('${item.quantity}x ${item.shoe.name} (Size: ${item.selectedSize})'),
                  )).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        List<BookingDetail> bookings = cart.pastBookings;

        return Scaffold(
          backgroundColor: Colors.grey[200],
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight + 10),
                const Text(
                  'My Orders',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: bookings.isEmpty
                      ? Center(
                    child: Text(
                      'You have no past bookings!',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  )
                      : ListView.builder(
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 15),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: const Icon(Icons.receipt, color: Colors.black),
                          title: Text('Booking ID: ${booking.bookingId}'),
                          subtitle: Text('Total: \$${booking.totalAmount} on ${booking.date}'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () => _showBookingDetailsDialog(context, booking),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}