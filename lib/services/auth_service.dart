import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:shoenew/models/user_profile.dart'; // Asumsikan Anda memiliki Model UserProfile

class AuthService {
  final supabase = Supabase.instance.client;

  // --- FUNGSI OTENTIKASI UTAMA ---

  Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) async {
    AuthResponse res = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return res;
  }
  
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    // ...
  }) async {
    AuthResponse res = await supabase.auth.signUp(
      email: email,
      password: password,
      // ...
    );
    return res;
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  // --- FUNGSI PROFIL: CREATE (DIPERLUKAN SETELAH SIGN UP) ---

  /// 🆕 Menciptakan entri awal di tabel 'profiles' database.
  /// Ini memisahkan data Auth (email/password) dari data Profil (nama/phone).
  Future<void> createUserProfile({
    required String userId,
    required String name,
    required String email,
    required String phone,
    required String address,
  }) async {
    try {
      // Pastikan nama tabel 'profiles' sudah benar di database Supabase Anda
      await supabase.from('users').insert({
        'id': userId, // PENTING: ID dari Auth akan menjadi ID di tabel profiles
        'name': name,
        'email': email,
        'phone': phone,
        'address': address, // Memberi nilai default
        'created_at': DateTime.now().toIso8601String(),
      });
      // 
    } on PostgrestException catch (e) {
      // Jika terjadi error saat insert, misalnya RLS Policy blocked atau duplicate key
      print('Postgrest Error creating profile for user $userId: ${e.message}');
      // Dalam kasus produksi, Anda mungkin ingin melempar error ini ke Controller
      rethrow; 
    } catch (e) {
      print('Error creating user profile: $e');
      rethrow;
    }
  }


  // --- FUNGSI PROFIL: GET ---

  /// Mengambil objek User Supabase yang sedang login saat ini.
  User? getCurrentUser() {
    return supabase.auth.currentUser;
  }

  /// Mengambil ID (UID) pengguna yang sedang login saat ini.
  String? getUserId() {
    return supabase.auth.currentUser?.id;
  }

  /// Mengambil detail profil (nama, phone, address, dll.) dari tabel 'profiles'
  /// Supabase berdasarkan User ID.
  /// 
  /// Mengembalikan Map<String, dynamic> yang berisi data profil.

  Future<Map<String, dynamic>?> fetchUserProfile(String userId) async {
    try {
      final response = await supabase
          .from('users') 
          .select('name, phone, address')
          .eq('id', userId)
          .single(); 

      print('✅ Supabase Fetch SUCCESS. Data: $response'); // TAMBAHKAN INI

      final data = response as Map<String, dynamic>;
      // ... penanganan null ...
      return data;
    } catch (e) {
      print('❌ Supabase Fetch FAILED. Error: $e'); // TAMBAHKAN INI
      return null;
    }
  }

  Future<void> updateUserProfile({
    required String userId,
    required String name,
    required String phone,
    required String address,
  }) async {
    await supabase.from('users').update({
      'name': name,
      'phone': phone,
      'address': address,
    }).eq('id', userId);
  }

}