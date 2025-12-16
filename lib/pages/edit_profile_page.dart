import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // ================= CONTROLLER =================
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  // ================= SERVICE =================
  final AuthService _authService = AuthService();

  // ================= STATE =================
  bool _isLoading = true;

  // ================= INIT =================
  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // ================= LOAD OLD DATA =================
  Future<void> _loadProfile() async {
    final user = _authService.getCurrentUser();

    if (user == null) {
      setState(() => _isLoading = false);
      return;
    }

    final profile = await _authService.fetchUserProfile(user.id);

    if (profile != null) {
      _nameController.text = profile['name'] ?? '';
      _phoneController.text = profile['phone']?.toString() ?? '';
      _addressController.text = profile['address'] ?? '';
    }

    setState(() => _isLoading = false);
  }

  // ================= SAVE =================
  Future<void> _saveProfile() async {
    final user = _authService.getCurrentUser();
    if (user == null) return;

    try {
      await _authService.updateUserProfile(
        userId: user.id,
        name: _nameController.text,
        phone: _phoneController.text,
        address: _addressController.text,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile berhasil diperbarui'),
            backgroundColor: Color(0xFF2E7D32),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: $e')),
      );
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Edit Akun',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: ListView(
          children: [
            // ================= NAME =================
            TextField(
              controller: _nameController,
              decoration: _inputDecoration('Full Name'),
            ),
            const SizedBox(height: 20),

            // ================= PHONE =================
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: _inputDecoration('Phone Number'),
            ),
            const SizedBox(height: 20),

            // ================= ADDRESS =================
            TextField(
              controller: _addressController,
              maxLines: 3,
              decoration: _inputDecoration('Pesanan dikirim ke'),
            ),
            const SizedBox(height: 30),

            // ================= SAVE BUTTON =================
            ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Simpan Perubahan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= HELPER =================
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[700]),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(12),
      ),
      fillColor: Colors.white,
      filled: true,
    );
  }
}
