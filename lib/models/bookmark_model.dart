class BookmarkModel {
  final int idBookmark;
  final int idUser;
  final String idIssue;
  final DateTime tanggalSimpan;

  const BookmarkModel({
    required this.idBookmark,
    required this.idUser,
    required this.idIssue,
    required this.tanggalSimpan,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_bookmark': idBookmark,
      'id_user': idUser,
      'id_issue': idIssue,
      'tanggal_simpan': tanggalSimpan.toIso8601String(),
    };
  }

  factory BookmarkModel.fromMap(Map<String, dynamic> map) {
    return BookmarkModel(
      idBookmark: (map['id_bookmark'] as num?)?.toInt() ?? 0,
      idUser: (map['id_user'] as num?)?.toInt() ?? 1,
      idIssue: map['id_issue'] as String? ?? '',
      tanggalSimpan: map['tanggal_simpan'] != null
          ? DateTime.tryParse(map['tanggal_simpan'].toString()) ??
              DateTime.now()
          : DateTime.now(),
    );
  }
}
