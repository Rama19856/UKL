import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ukl1/models/response_data_map.dart';
import 'package:ukl1/models/mata_kuliah.dart';
import 'package:ukl1/services/url.dart' as url;

class MataKuliahService {
  Future<ResponseDataMap> getDaftarMataKuliah() async {
    try {
      final uri = Uri.parse('${url.apiUrl}/getmatkul');
      final response = await http.get(uri);
      return _handleResponse(response);
    } catch (e) {
      return ResponseDataMap(status: false, message: 'Terjadi kesalahan saat mengambil daftar mata kuliah: $e');
    }
  }

  Future<ResponseDataMap> pilihMataKuliah(List<int> selectedIds) async {
    try {
      final uri = Uri.parse('${url.apiUrl}/selectmatkul');
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'list_matkul': selectedIds.map((id) => {'id': id}).toList()}),
      );
      return _handleResponse(response, successMessage: 'Matkul selected successfully');
    } catch (e) {
      return ResponseDataMap(status: false, message: 'Terjadi kesalahan saat memilih mata kuliah: $e');
    }
  }

  ResponseDataMap _handleResponse(http.Response response, {String? successMessage}) {
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ResponseDataMap(
        status: data['status'] ?? true,
        message: data['message'] ?? successMessage ?? 'Sukses',
        data: data['data'],
      );
    } else {
      return ResponseDataMap(status: false, message: 'Gagal dengan kode error ${response.statusCode}');
    }
  }
}