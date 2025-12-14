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

  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk mengambil ID pengguna saat halaman dibuat
    _loadCurrentUserProfile();
  }

  Future<void> _loadCurrentUserProfile() async {
    // Ambil User ID dan Email dari objek Supabase Auth yang sedang aktif
    final user = supabase.auth.currentUser;

    if (user != null) {
      final cart = Provider.of<Cart>(context, listen: false);
      
      // Ambil data profil dari database menggunakan fungsi fetch yang baru di AuthService
      // ASUMSI: Anda memindahkan fungsi fetchUserProfile ke AuthService (seperti yang kita bahas sebelumnya)
      
      // Ganti logika fetch ke Cart dengan logika fetch dari Service (jika Cart model tidak lagi melakukan fetching)
      try {
        // Ambil data profil (Nama, Phone, Address, Avatar) dari Supabase via AuthService
        final profileData = await AuthService().fetchUserProfile(user.id);
        
        if (profileData != null) {
          // 3. Gunakan updateProfile di model Cart untuk menyimpan data yang sudah di-fetch
          // Data ini akan digunakan oleh Consumer
          cart.updateProfile(
            name: profileData['name'],
            // Email selalu di-update dari user.email Supabase Auth untuk keandalan
            email: user.email, 
            phone: profileData['phone'],
            address: profileData['address'],
            avatarUrl: profileData['avatar_url'],
          );
        }
        
        // PENTING: Anda harus tetap memanggil `cart.initializeUser(user.id)` 
        // jika ingin memuat keranjang dan riwayat pesanan dari local storage!
        await cart.initializeUser(user.id);

        setState(() {
          _isProfileLoaded = true;
        });

      } catch (e) {
        print('Gagal memuat profil: $e');
        // Tetap set loaded agar loading indicator hilang
        setState(() {
          _isProfileLoaded = true;
        });
      }
    } else {
      print('Tidak ada pengguna yang sedang login.');
      // Jika tidak ada user, pastikan state loading berhenti
      setState(() {
        _isProfileLoaded = true;
      });
    }
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

  // Fungsi untuk Logout (Menggunakan signOut dari AuthService)
  void _handleLogout() async {
      try {
        await AuthService().signOut(); // Panggil fungsi signOut dari service
        
        // Clear data di Cart model setelah logout
        if (mounted) {
            Provider.of<Cart>(context, listen: false).clearUserData();
        }

        // Navigasi ke halaman Login/Intro setelah logout
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/intro', (route) => false); 
        }
      } catch (e) {
        print('Gagal Logout: $e');
      }
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
                        backgroundImage: NetworkImage(
                           cart.userAvatarUrl.isNotEmpty ? cart.userAvatarUrl : 'https://i.pravatar.cc/150', 
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        // Ambil dari Cart model yang sudah di-update oleh Service
                        cart.userName.isNotEmpty ? cart.userName : 'Pengguna Baru', 
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
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
                        subtitle: Text(cart.userPhone.isNotEmpty ? cart.userPhone : 'Belum diatur'), 
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: _editProfile,
                      ),
                      ListTile(
                        leading: const Icon(Icons.location_on),
                        title: const Text('Alamat Pengiriman'),
                        subtitle: Text(cart.deliveryAddress.isNotEmpty ? cart.deliveryAddress : 'Belum diatur'), 
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: _editProfile,
                      ),
                      // Tombol Logout
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text('Logout', style: TextStyle(color: Colors.red)),
                        onTap: _handleLogout,
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