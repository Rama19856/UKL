import 'package:flutter/material.dart';
import 'package:ukl1/widgets/bottom_nav.dart';
import 'package:ukl1/widgets/alert.dart';

class MataKuliah {
  final int id;
  final String nama;
  final int sks;
  bool isSelected;

  MataKuliah({
    required this.id,
    required this.nama,
    required this.sks,
    this.isSelected = false,
  });
}

class MataKuliahPage extends StatefulWidget {
  const MataKuliahPage({super.key});

  @override
  State<MataKuliahPage> createState() => _MataKuliahPageState();
}

class _MataKuliahPageState extends State<MataKuliahPage> {
  final List<MataKuliah> _matkulList = [
    MataKuliah(id: 1, nama: 'Matematika', sks: 3),
    MataKuliah(id: 2, nama: 'Bahasa Inggris', sks: 2),
    MataKuliah(id: 3, nama: 'Pemrograman Web', sks: 2),
    MataKuliah(id: 4, nama: 'Basis Data', sks: 3),
  ];

  bool _isLoading = false;

  void _togglePilihan(int id, bool? value) {
    setState(() {
      final matkul = _matkulList.firstWhere((m) => m.id == id);
      matkul.isSelected = value ?? false;
    });
  }

  void _simpanPilihan() {
    final terpilih = _matkulList.where((m) => m.isSelected).toList();

    if (terpilih.isEmpty) {
      AlertMessage().showAlert(context, 'Pilih minimal satu mata kuliah!', false);
    } else {
      final namaMatkul = terpilih.map((m) => m.nama).join(', ');
      AlertMessage().showAlert(context, 'Berhasil disimpan: $namaMatkul', true);
    }
  }

  Icon _getIcon(String nama) {
    switch (nama) {
      case 'Matematika':
        return const Icon(Icons.calculate, color: Colors.blue);
      case 'Bahasa Inggris':
        return const Icon(Icons.language, color: Colors.blue);
      case 'Pemrograman Web':
        return const Icon(Icons.web, color: Colors.blue);
      case 'Basis Data':
        return const Icon(Icons.storage, color: Colors.blue);
      default:
        return const Icon(Icons.book, color: Colors.blue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('Pilih Mata Kuliah'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: _matkulList.length,
        itemBuilder: (context, index) {
          final matkul = _matkulList[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: CheckboxListTile(
              activeColor: Colors.blue,
              secondary: _getIcon(matkul.nama),
              title: Text(
                matkul.nama,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text('SKS: ${matkul.sks}'),
              value: matkul.isSelected,
              onChanged: (val) => _togglePilihan(matkul.id, val),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _simpanPilihan,
        icon: const Icon(Icons.save),
        label: const Text('Simpan'),
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: const BottomNav(1),
    );
  }
}