class MataKuliah {
  final int id;
  final String namaMatkul;
  final int sks;
  bool isSelected;

  MataKuliah({
    required this.id,
    required this.namaMatkul,
    required this.sks,
    this.isSelected = false,
  });

  factory MataKuliah.fromJson(Map<String, dynamic> json) {
    return MataKuliah(
      id: int.parse(json['id'].toString()),
      namaMatkul: json['nama_matkul'] as String,
      sks: int.parse(json['sks'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_matkul': namaMatkul,
      'sks': sks,
    };
  }
}