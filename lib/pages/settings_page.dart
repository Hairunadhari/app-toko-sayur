import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkModeEnabled = false;
  bool _notificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading Halaman Pengaturan
            const Text(
              'Settings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),

            // Opsi Pengaturan Umum
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: _darkModeEnabled,
                onChanged: (value) {
                  setState(() {
                    _darkModeEnabled = value;
                    // TODO: Implementasi logika untuk mengganti tema aplikasi
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Dark Mode: ${value ? "On" : "Off"}')),
                    );
                  });
                },
              ),
              onTap: () {
                // Toggle switch saat ListTile diklik
                setState(() {
                  _darkModeEnabled = !_darkModeEnabled;
                  // TODO: Implementasi logika untuk mengganti tema aplikasi
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Dark Mode: ${_darkModeEnabled ? "On" : "Off"}')),
                  );
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Enable Notifications'),
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                    // TODO: Implementasi logika untuk mengelola notifikasi
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Notifications: ${value ? "Enabled" : "Disabled"}')),
                    );
                  });
                },
              ),
              onTap: () {
                setState(() {
                  _notificationsEnabled = !_notificationsEnabled;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Notifications: ${_notificationsEnabled ? "Enabled" : "Disabled"}')),
                  );
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Language'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Navigasi ke halaman pemilihan bahasa
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navigate to Language Settings')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Tampilkan Privacy Policy
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Show Privacy Policy')),
                );
              },
            ),
            const Divider(),
            const Divider(),

            // Opsi Akun
            ListTile(
              leading: const Icon(Icons.password),
              title: const Text('Change Password'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Navigasi ke halaman ganti password
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navigate to Change Password')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}