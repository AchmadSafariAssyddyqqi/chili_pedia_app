class UserModel {
  final int idUser;
  final String namaLengkap;
  final String email;
  final String nomorHp; // Nomor Telepon / WhatsApp
  final String password;
  final String lokasiKebun;
  final String luasLahan;
  final bool isDarkMode;
  final int avatarIndex;

  const UserModel({
    required this.idUser,
    required this.namaLengkap,
    this.email = 'budi.santoso@chilipedia.id',
    this.nomorHp = '08123456789',
    this.password = 'petani123',
    required this.lokasiKebun,
    required this.luasLahan,
    this.isDarkMode = false,
    this.avatarIndex = 0,
  });

  UserModel copyWith({
    int? idUser,
    String? namaLengkap,
    String? email,
    String? nomorHp,
    String? password,
    String? lokasiKebun,
    String? luasLahan,
    bool? isDarkMode,
    int? avatarIndex,
  }) {
    return UserModel(
      idUser: idUser ?? this.idUser,
      namaLengkap: namaLengkap ?? this.namaLengkap,
      email: email ?? this.email,
      nomorHp: nomorHp ?? this.nomorHp,
      password: password ?? this.password,
      lokasiKebun: lokasiKebun ?? this.lokasiKebun,
      luasLahan: luasLahan ?? this.luasLahan,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      avatarIndex: avatarIndex ?? this.avatarIndex,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_user': idUser,
      'nama_lengkap': namaLengkap,
      'email': email,
      'nomor_hp': nomorHp,
      'password': password,
      'lokasi_kebun': lokasiKebun,
      'luas_lahan': luasLahan,
      'is_dark_mode': isDarkMode ? 1 : 0,
      'avatar_index': avatarIndex,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      idUser: (map['id_user'] as num?)?.toInt() ?? 1,
      namaLengkap: map['nama_lengkap'] as String? ?? 'Petani Cabai',
      email: map['email'] as String? ?? 'budi.santoso@chilipedia.id',
      nomorHp: map['nomor_hp'] as String? ?? '08123456789',
      password: map['password'] as String? ?? 'petani123',
      lokasiKebun: map['lokasi_kebun'] as String? ?? 'Indonesia',
      luasLahan: map['luas_lahan'] as String? ?? '500 m²',
      isDarkMode: map['is_dark_mode'] == 1 || map['is_dark_mode'] == true,
      avatarIndex: (map['avatar_index'] as num?)?.toInt() ?? 0,
    );
  }
}
