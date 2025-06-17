import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Contoh data notifikasi
  final List<String> _notifications = [
    'Order #12345 has been shipped!',
    'Your favorite shoe is now on sale!',
    'New collection has arrived!',
    'Welcome to ShoeNew app!',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading Halaman Notifikasi
            const Text(
              'Notifications',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),

            // Daftar Notifikasi
            Expanded(
              child: _notifications.isEmpty
                  ? Center(
                child: Text(
                  'No new notifications.',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              )
                  : ListView.builder(
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 15),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.notifications_active, color: Colors.blueAccent),
                      title: Text(_notifications[index]),
                      subtitle: const Text('Just now'),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Notification clicked: ${_notifications[index]}')),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}