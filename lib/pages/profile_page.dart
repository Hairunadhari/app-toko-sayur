import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoenew/models/cart.dart';
import 'package:shoenew/pages/edit_profile_page.dart';
// import 'package:shoenew/services/auth_service.dart'; // Ganti dengan path AuthService Anda
import 'package:supabase_flutter/supabase_flutter.dart'; // Tetap diperlukan untuk tipe data Auth dan client
import '../services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // 1. Inisialisasi AuthService
  // Asumsi AuthService berada di tempat yang bisa diakses (Jika di folder services)
  // final AuthService _authService = AuthService(); 
  // Karena Supabase Client sudah ada di AuthService, kita bisa menggunakannya.
  final supabase = Supabase.instance.client; // Tetap gunakan client lokal untuk kemudahan akses Auth object

  // State untuk melacak apakah data profil sudah dimuat
  bool _isProfileLoaded = false; 
  Map<String, dynamic>? profileData;

  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk mengambil ID pengguna saat halaman dibuat
    _loadCurrentUserProfile();
  }

  Future<void> _loadCurrentUserProfile() async {
  final user = supabase.auth.currentUser;

  if (user == null) {
    setState(() => _isProfileLoaded = true);
    return;
  }

  try {
    final cart = Provider.of<Cart>(context, listen: false);

    final data = await AuthService().fetchUserProfile(user.id);

    if (data != null) {
      profileData = data;

      cart.updateProfile(
        name: data['name'],
        email: user.email,
        phone: data['phone'],
        address: data['address'],
      );
    }

    await cart.initializeUser(user.id);

  } catch (e) {
    debugPrint('Gagal memuat profil: $e');
  }

  setState(() => _isProfileLoaded = true);
}



  // Fungsi untuk mengedit profil
  void _editProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfilePage()),
    ).then((_) {
      // Setelah kembali dari EditProfilePage, muat ulang data untuk refresh tampilan
      // Data akan diambil lagi dari service
      _loadCurrentUserProfile(); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        
        // Perbaiki logika loading indicator: tampilkan jika _isProfileLoaded false
        if (!_isProfileLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          backgroundColor: Colors.grey[200],
          body: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),

                // Bagian Info Profil Utama
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: const AssetImage('lib/images/avt.png'),
                      ),
                      const SizedBox(height: 20),
                     Text(
                      profileData?['name']?.isNotEmpty == true
                          ? profileData!['name']
                          : 'Pengguna Baru',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                      const SizedBox(height: 5),
                      Text(
                        // Ambil email yang paling akurat: dari Supabase Auth User (jika ada) atau dari Cart model
                        supabase.auth.currentUser?.email ?? cart.userEmail, 
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton.icon(
                        onPressed: _editProfile,
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit Profile'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // (Account Information)
                const Text(
                  'Informasi Akun',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),

                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.phone),
                        title: const Text('Nomor Telpon'),
                        subtitle: Text(profileData?['phone']?.toString() ?? 'Belum diatur'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: _editProfile,
                      ),

                      ListTile(
                        leading: const Icon(Icons.location_on),
                        title: const Text('Alamat Pengiriman'),
                        subtitle: Text(
                          profileData?['address'] != null && profileData!['address'].toString().isNotEmpty
                              ? profileData!['address']
                              : 'Belum diatur',
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: _editProfile,
                      ),

                    ],
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

// Catatan: Pastikan Anda menambahkan import ke AuthService Anda di bagian atas file ini
// dan bahwa Anda telah memindahkan logika pengambilan data profil ke dalam AuthService.fetchUserProfile.