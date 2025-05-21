import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:ukl1/models/response_data_map.dart';
import 'package:ukl1/models/user_login.dart';
import 'package:ukl1/services/url.dart' as url;

class UserService {
  Future registerUser(datas) async {
    try {
      final uri = Uri.parse('${url.apiUrl}/register_admin');
      final response = await http.post(uri, body: datas);
      return _handleResponse(response, "Sukses menambah user");
    } catch (e) {
      return ResponseDataMap(status: false, message: "Terjadi kesalahan: $e");
    }
  }

  Future loginUser(data) async {
    final uri = Uri.parse('${url.apiUrl}/auth/login');
    final response = await http.post(uri, body: data);
    return _handleLoginResponse(response);
  }

  Future<ResponseDataMap> registerNasabahWithPhoto({
    required Map<String, String> data,
    required File photoFile,
  }) async {
    try {
      final uri = Uri.parse('${url.apiUrl}/register_nasabah');
      final request = http.MultipartRequest('POST', uri);
      request.fields.addAll(data);

      final mimeType = lookupMimeType(photoFile.path);
      if (mimeType == null) throw Exception("Format file tidak didukung");
      final fileExtension = mimeType.split('/').last;

      final multipartFile = await http.MultipartFile.fromPath(
        'foto',
        photoFile.path,
        contentType: MediaType('image', fileExtension),
        filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.$fileExtension',
      );
      request.files.add(multipartFile);

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      return _handleResponse(responseData, "Pendaftaran berhasil");
    } catch (e) {
      return ResponseDataMap(status: false, message: "Terjadi kesalahan: $e");
    }
  }

  Future<ResponseDataMap> registerNasabah({
    required Map<String, String> data,
  }) async {
    try {
      final uri = Uri.parse('${url.apiUrl}/register_nasabah');
      final response = await http.post(uri, body: data);
      return _handleResponse(response, "Pendaftaran berhasil");
    } catch (e) {
      return ResponseDataMap(status: false, message: "Terjadi kesalahan: $e");
    }
  }

  Future<ResponseDataMap> updateProfile(Map<String, String> data) async {
    try {
      final uri = Uri.parse('${url.apiUrl}/api/update'); // Endpoint sesuai soal
      final response = await http.post(uri, body: data);
      return _handleResponse(response, "Profil berhasil diupdate");
    } catch (e) {
      return ResponseDataMap(status: false, message: "Terjadi kesalahan saat update profil: $e");
    }
  }

  ResponseDataMap _handleResponse(http.Response response, String successMessage) {
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == true) {
        return ResponseDataMap(
          status: true,
          message: data["message"] ?? successMessage,
          data: data,
        );
      } else {
        String message = '';
        if (data["message"] != null && data["message"] is Map) {
          for (final key in data["message"].keys) {
            message += '${data["message"][key][0]}\n';
          }
        } else if (data["message"] != null) {
          message = data["message"].toString();
        }
        return ResponseDataMap(
          status: false,
          message: message,
        );
      }
    } else {
      return ResponseDataMap(
        status: false,
        message: "Gagal dengan kode error ${response.statusCode}",
      );
    }
  }

  ResponseDataMap _handleLoginResponse(http.Response response) {
    print("Login Response Status Code: ${response.statusCode}");
    print("Login Response Body: ${response.body}");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == true) {
        final userLogin = UserLogin.fromJson(data);
        userLogin.prefs();
        return ResponseDataMap(status: true, message: "Sukses login user", data: data);
      } else {
        return ResponseDataMap(status: false, message: data["message"] ?? 'Username dan password salah');
      }
    } else {
      return ResponseDataMap(
        status: false,
        message: "Gagal login dengan kode error ${response.statusCode}",
      );
    }
  }
}