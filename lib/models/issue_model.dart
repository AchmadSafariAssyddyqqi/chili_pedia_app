class IssueModel {
  final String idIssue;
  final String kategori; // 'Penyakit' atau 'Hama'
  final String namaMasalah;
  final String namaLatin;
  final String bagianTerdampak; // 'Daun', 'Buah', 'Akar', 'Batang', 'Bunga'
  final String gejala;
  final String solusi;
  final String pencegahan;
  final String tingkatBahaya; // 'Tinggi', 'Sedang', 'Rendah'
  final bool isPopular;
  final String iconSymbol;

  const IssueModel({
    required this.idIssue,
    required this.kategori,
    required this.namaMasalah,
    required this.namaLatin,
    required this.bagianTerdampak,
    required this.gejala,
    required this.solusi,
    required this.pencegahan,
    this.tingkatBahaya = 'Sedang',
    this.isPopular = false,
    this.iconSymbol = '🌶️',
  });

  Map<String, dynamic> toMap() {
    return {
      'id_issue': idIssue,
      'kategori': kategori,
      'nama_masalah': namaMasalah,
      'nama_latin': namaLatin,
      'bagian_terdampak': bagianTerdampak,
      'gejala': gejala,
      'solusi': solusi,
      'pencegahan': pencegahan,
      'tingkat_bahaya': tingkatBahaya,
      'is_popular': isPopular ? 1 : 0,
      'icon_symbol': iconSymbol,
    };
  }

  factory IssueModel.fromMap(Map<String, dynamic> map) {
    return IssueModel(
      idIssue: map['id_issue'] as String? ?? '',
      kategori: map['kategori'] as String? ?? 'Penyakit',
      namaMasalah: map['nama_masalah'] as String? ?? '',
      namaLatin: map['nama_latin'] as String? ?? '',
      bagianTerdampak: map['bagian_terdampak'] as String? ?? 'Daun',
      gejala: map['gejala'] as String? ?? '',
      solusi: map['solusi'] as String? ?? '',
      pencegahan: map['pencegahan'] as String? ?? '',
      tingkatBahaya: map['tingkat_bahaya'] as String? ?? 'Sedang',
      isPopular: map['is_popular'] == 1 || map['is_popular'] == true,
      iconSymbol: map['icon_symbol'] as String? ?? '🌶️',
    );
  }
}
