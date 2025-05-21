import 'package:flutter/material.dart';
import 'package:ukl1/services/user.dart';
import 'package:ukl1/widgets/alert.dart';
import 'package:ukl1/widgets/bottom_nav.dart';
import 'package:ukl1/models/user_login.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  String? _selectedGender;
  final _teleponController = TextEditingController();
  final UserService _userService = UserService();
  bool _isLoading = false;
  UserLogin? _user;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = await UserLogin.getUserLogin();
    setState(() {
      _user = user;
      _namaController.text = user.nama ?? '';
      _alamatController.text = user.alamat ?? '';
      final gender = user.gender?.toLowerCase().trim();
      if (gender == 'laki-laki' || gender == 'perempuan') {
        _selectedGender = gender;
      } else {
        _selectedGender = null;
      }
      _teleponController.text = user.noTelp ?? '';
    });
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final data = {
        'nama_pelanggan': _namaController.text,
        'alamat': _alamatController.text,
        'gender': _selectedGender!,
        'telepon': _teleponController.text,
      };

      final response = await _userService.updateProfile(data);
      setState(() => _isLoading = false);

      if (response.status) {
        AlertMessage().showAlert(context, response.message, true);
        _loadUserProfile();
      } else {
        AlertMessage().showAlert(context, response.message, false);
      }
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.blue.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: const Text('Update Profil'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _namaController,
                    decoration: _inputDecoration('Nama Pelanggan', Icons.person),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Nama tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _alamatController,
                    decoration: _inputDecoration('Alamat', Icons.home),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Alamat tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: _inputDecoration('Jenis Kelamin', Icons.wc),
                    value: _selectedGender,
                    items: const [
                      DropdownMenuItem(value: 'laki-laki', child: Text('Laki-laki')),
                      DropdownMenuItem(value: 'perempuan', child: Text('Perempuan')),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedGender = value);
                    },
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Pilih jenis kelamin' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _teleponController,
                    decoration: _inputDecoration('Telepon', Icons.phone),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Telepon tidak boleh kosong';
                      }
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Hanya angka yang diperbolehkan';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _updateProfile,
                      icon: const Icon(Icons.save),
                      label: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Simpan Perubahan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(2),
    );
  }
}