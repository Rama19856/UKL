import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ukl1/models/response_data_map.dart';
import 'package:ukl1/services/user.dart';
import 'package:ukl1/widgets/alert.dart';
import 'login_view.dart';

class RegisterUserView extends StatefulWidget {
  const RegisterUserView({super.key});

  @override
  State<RegisterUserView> createState() => _RegisterNasabahViewState();
}

class _RegisterNasabahViewState extends State<RegisterUserView> {
  final UserService _userService = UserService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final List<String> _genderOptions = ["Laki-laki", "Perempuan"];
  String? _selectedGender;
  File? _selectedPhoto;

  Future<void> _pickPhoto() async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _selectedPhoto = File(pickedImage.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
      if (mounted) {
        AlertMessage().showAlert(context, "Gagal memilih foto", false);
      }
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      Map<String, String> data = {
        "nama_nasabah": _namaController.text,
        "gender": _selectedGender!,
        "alamat": _alamatController.text,
        "telepon": _teleponController.text,
        "username": _usernameController.text,
        "password": _passwordController.text,
      };

      ResponseDataMap response;
      if (_selectedPhoto != null) {
        response = await _userService.registerNasabahWithPhoto(
          data: data,
          photoFile: _selectedPhoto!,
        );
      } else {
        response = await _userService.registerNasabah(data: data);
      }

      if (response.status && mounted) {
        _clearFormAndNavigateToLogin(response.message);
      } else if (mounted) {
        AlertMessage().showAlert(context, response.message, false);
      }
    } catch (e) {
      debugPrint("Registration error: $e");
      if (mounted) {
        AlertMessage().showAlert(
         context,
          "Gagal mendaftar. Periksa koneksi internet atau coba lagi nanti.",
          false,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _clearFormAndNavigateToLogin(String message) async {
    _namaController.clear();
    _alamatController.clear();
    _teleponController.clear();
    _usernameController.clear();
    _passwordController.clear();
    setState(() {
      _selectedGender = null;
      _selectedPhoto = null;
    });
    await AlertMessage().showAlert(context, message, true);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.login, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Bank Sinar Jaya",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Daftar sekarang dan nikmati kemudahan dalam menabung!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 25),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Nama Nasabah
                      TextFormField(
                        controller: _namaController,
                        decoration: InputDecoration(
                          labelText: "Nama Lengkap",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.person),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Nama tidak boleh kosong" : null,
                      ),
                      const SizedBox(height: 15),

                      // Gender Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        items: _genderOptions
                            .map((gender) => DropdownMenuItem(
                                  value: gender,
                                  child: Text(gender),
                                ))
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _selectedGender = value),
                        decoration: InputDecoration(
                          labelText: "Jenis Kelamin",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.people),
                        ),
                        validator: (value) =>
                            value == null ? "Pilih jenis kelamin" : null,
                      ),
                      const SizedBox(height: 15),

                      // Alamat
                      TextFormField(
                        controller: _alamatController,
                        decoration: InputDecoration(
                          labelText: "Alamat",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.home),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Alamat tidak boleh kosong" : null,
                      ),
                      const SizedBox(height: 15),

                      // Telepon
                      TextFormField(
                        controller: _teleponController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "Nomor Telepon",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.phone),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) return "Nomor telepon harus diisi";
                          if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                            return "Hanya boleh angka";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      // Foto (Opsional)
                      InkWell(
                        onTap: _pickPhoto,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.camera_alt, color: Colors.blue),
                              const SizedBox(width: 10),
                              Text(
                                _selectedPhoto == null
                                    ? "Pilih Foto Profil (Opsional)"
                                    : "Foto terpilih: ${_selectedPhoto!.path.split('/').last}",
                                style: TextStyle(
                                  color: _selectedPhoto == null
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Username
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: "Username",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.account_circle),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Username harus diisi" : null,
                      ),
                      const SizedBox(height: 15),

                      // Password
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.lock),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) return "Password harus diisi";
                          if (value.length < 6) {
                            return "Password minimal 6 karakter";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 25),

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                )
                              : const Text(
                                  "DAFTAR SEKARANG",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}