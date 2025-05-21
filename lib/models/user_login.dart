import 'package:shared_preferences/shared_preferences.dart';

class UserLogin {
  String? nama;
  String? gender;
  String? alamat;
  String? noTelp;
  String? image;
  String? username;
  String? password;

  UserLogin({
    this.nama,
    this.gender,
    this.alamat,
    this.noTelp,
    this.image,
    this.username,
    this.password,
  });

  get status => null;

  /// Simpan data login ke SharedPreferences
  Future<void> prefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('nama', nama ?? '');
    prefs.setString('gender', gender ?? '');
    prefs.setString('alamat', alamat ?? '');
    prefs.setString('no_telp', noTelp ?? '');
    prefs.setString('image', image ?? '');
    prefs.setString('username', username ?? '');
    prefs.setString('password', password ?? '');
  }

  /// Ambil data login dari SharedPreferences
  static Future<UserLogin> getUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return UserLogin(
      nama: prefs.getString('nama') ?? '',
      gender: prefs.getString('gender') ?? '',
      alamat: prefs.getString('alamat') ?? '',
      noTelp: prefs.getString('no_telp') ?? '',
      image: prefs.getString('image') ?? '',
      username: prefs.getString('username') ?? '',
      password: prefs.getString('password') ?? '',
    );
  }

  static UserLogin fromJson(Map<String, dynamic> json) {
    return UserLogin(
      nama: json['user']['nama_user'],
      gender: json['user']['gender'],
      alamat: json['user']['alamat'],
      noTelp: json['user']['no_telp'],
      image: json['user']['image'],
      username: json['user']['username'],
      password: json['user']['password'],
    );
  }
}