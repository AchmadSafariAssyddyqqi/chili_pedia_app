import 'dart:convert';
import 'dart:io';
import '../models/user_model.dart';
import '../models/issue_model.dart';
import '../models/bookmark_model.dart';
import 'initial_issues_data.dart';

/// DatabaseService merepresentasikan implementasi Database Lokal Relasional (ERD)
/// 100% Offline sesuai spesifikasi:
/// - Tabel 1: Users (Data Petani, Akun Login & Registrasi)
/// - Tabel 2: Issues (Data Ensiklopedia Hama & Penyakit)
/// - Tabel 3: Bookmarks (Relasi One-to-Many antara Users dan Issues)
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  bool _isInitialized = false;

  // In-memory tables (simulasi tabel relasional lokal)
  final List<UserModel> _tableUsers = [];
  UserModel? _currentUser;
  final List<IssueModel> _tableIssues = [];
  final List<BookmarkModel> _tableBookmarks = [];
  int _nextUserId = 1;
  int _nextBookmarkId = 1;

  File? _storageFile;

  Future<void> init() async {
    if (_isInitialized) return;

    // Load static issues table
    _tableIssues.clear();
    _tableIssues.addAll(initialIssuesData);

    // Coba load persistence data dari local file jika tersedia
    try {
      final Directory docDir = Directory.current;
      _storageFile = File('${docDir.path}/chilipedia_local_db.json');

      if (await _storageFile!.exists()) {
        final content = await _storageFile!.readAsString();
        if (content.isNotEmpty) {
          final Map<String, dynamic> data = jsonDecode(content);

          // Restore All Registered Users
          if (data['users_list'] != null) {
            final List uList = data['users_list'] as List;
            _tableUsers.clear();
            for (var item in uList) {
              final u = UserModel.fromMap(item as Map<String, dynamic>);
              _tableUsers.add(u);
              if (u.idUser >= _nextUserId) {
                _nextUserId = u.idUser + 1;
              }
            }
          }

          // Restore Active Session
          final activeId = data['active_user_id'] as num?;
          if (activeId != null) {
            _currentUser = _tableUsers.firstWhere(
              (u) => u.idUser == activeId.toInt(),
              orElse: () => _tableUsers.isNotEmpty ? _tableUsers.first : _createDefaultDemoUser(),
            );
          } else if (data['users'] != null) {
            _currentUser = UserModel.fromMap(data['users'] as Map<String, dynamic>);
            if (!_tableUsers.any((u) => u.idUser == _currentUser!.idUser)) {
              _tableUsers.add(_currentUser!);
            }
          }

          // Restore Table Bookmarks
          if (data['bookmarks'] != null) {
            final List list = data['bookmarks'] as List;
            _tableBookmarks.clear();
            for (var item in list) {
              final b = BookmarkModel.fromMap(item as Map<String, dynamic>);
              _tableBookmarks.add(b);
              if (b.idBookmark >= _nextBookmarkId) {
                _nextBookmarkId = b.idBookmark + 1;
              }
            }
          }
        }
      }
    } catch (_) {
      // Fallback aman untuk platform yang tidak mengizinkan direct file write
    }

    // Jika tabel user masih kosong, sediakan 1 akun demo petani bawaan (tanpa auto-login)
    if (_tableUsers.isEmpty) {
      final defaultUser = _createDefaultDemoUser();
      _tableUsers.add(defaultUser);
      _nextUserId = 2;
    }

    _isInitialized = true;
  }

  UserModel _createDefaultDemoUser() {
    return const UserModel(
      idUser: 1,
      namaLengkap: 'Budi Santoso',
      email: 'budi.santoso@chilipedia.id',
      nomorHp: '08123456789',
      password: 'petani123',
      lokasiKebun: 'Desa Pamekasan, Jawa Timur',
      luasLahan: '500 meter persegi',
      isDarkMode: false,
      avatarIndex: 0,
    );
  }

  Future<void> _persist() async {
    try {
      if (_storageFile != null) {
        final payload = {
          'active_user_id': _currentUser?.idUser,
          'users_list': _tableUsers.map((u) => u.toMap()).toList(),
          'users': _currentUser?.toMap(),
          'bookmarks': _tableBookmarks.map((b) => b.toMap()).toList(),
        };
        await _storageFile!.writeAsString(jsonEncode(payload));
      }
    } catch (_) {
      // Abaikan jika persistensi file terkendala
    }
  }

  // ==========================================
  // TABEL 1: USERS (Data Petani & Auth) - CRUD
  // ==========================================

  UserModel? getCurrentUser() => _currentUser;

  bool hasActiveSession() => _currentUser != null;

  List<UserModel> getAllUsers() => List.unmodifiable(_tableUsers);

  /// Login Akun Petani (via Email ATAU Nomor HP)
  Future<String?> login({
    required String nomorHpOrEmail,
    required String password,
  }) async {
    final cleanInput = nomorHpOrEmail.trim().toLowerCase();
    final cleanPassword = password.trim();

    try {
      final user = _tableUsers.firstWhere(
        (u) =>
            (u.nomorHp.trim().toLowerCase() == cleanInput ||
             u.email.trim().toLowerCase() == cleanInput) &&
            u.password.trim() == cleanPassword,
      );

      _currentUser = user;
      await _persist();
      return null; // Sukses tanpa error
    } catch (_) {
      return 'Email/Nomor HP atau Password salah. Silakan periksa kembali.';
    }
  }

  /// Pendaftaran Akun Baru Petani
  Future<String?> register({
    required String namaLengkap,
    required String email,
    required String nomorHp,
    required String password,
    required String lokasiKebun,
    required String luasLahan,
    int avatarIndex = 0,
    bool autoLogin = false,
  }) async {
    final cleanHp = nomorHp.trim();
    final cleanEmail = email.trim().toLowerCase();

    // Cek apakah nomor HP atau Email sudah terdaftar
    final exists = _tableUsers.any((u) =>
        u.nomorHp.trim() == cleanHp ||
        (cleanEmail.isNotEmpty && u.email.trim().toLowerCase() == cleanEmail));
    if (exists) {
      return 'Nomor HP atau Email ini sudah terdaftar. Silakan login ke akun Anda.';
    }

    final newUser = UserModel(
      idUser: _nextUserId++,
      namaLengkap: namaLengkap.trim(),
      email: cleanEmail.isNotEmpty ? cleanEmail : 'petani$_nextUserId@chilipedia.id',
      nomorHp: cleanHp,
      password: password.trim(),
      lokasiKebun: lokasiKebun.trim(),
      luasLahan: luasLahan.trim(),
      isDarkMode: false,
      avatarIndex: avatarIndex,
    );

    _tableUsers.add(newUser);
    if (autoLogin) {
      _currentUser = newUser;
    }
    await _persist();
    return null; // Sukses
  }

  /// 1-Click Login Akun Demo Petani untuk Ujian/Dosen
  Future<void> loginAsDemo() async {
    if (_tableUsers.isEmpty) {
      final def = _createDefaultDemoUser();
      _tableUsers.add(def);
      _currentUser = def;
    } else {
      _currentUser = _tableUsers.first;
    }
    await _persist();
  }

  /// Logout Akun
  Future<void> logout() async {
    _currentUser = null;
    await _persist();
  }

  Future<void> updateUser(UserModel updatedUser) async {
    final index = _tableUsers.indexWhere((u) => u.idUser == updatedUser.idUser);
    if (index >= 0) {
      _tableUsers[index] = updatedUser;
    }
    if (_currentUser?.idUser == updatedUser.idUser) {
      _currentUser = updatedUser;
    }
    await _persist();
  }

  Future<void> setDarkMode(bool isDark) async {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(isDarkMode: isDark);
      final index = _tableUsers.indexWhere((u) => u.idUser == _currentUser!.idUser);
      if (index >= 0) {
        _tableUsers[index] = _currentUser!;
      }
      await _persist();
    }
  }

  // ==========================================
  // TABEL 2: ISSUES (Katalog Masalah Cabai) - READ
  // ==========================================

  List<IssueModel> getAllIssues() {
    return List.unmodifiable(_tableIssues);
  }

  IssueModel? getIssueById(String idIssue) {
    try {
      return _tableIssues.firstWhere((issue) => issue.idIssue == idIssue);
    } catch (_) {
      return null;
    }
  }

  List<IssueModel> getPopularIssues() {
    return _tableIssues.where((issue) => issue.isPopular).toList();
  }

  List<IssueModel> searchIssues({
    String query = '',
    String? category,
    String? affectedPart,
  }) {
    final cleanQuery = query.toLowerCase().trim();

    return _tableIssues.where((issue) {
      if (category != null && category != 'Semua' && category.isNotEmpty) {
        if (issue.kategori.toLowerCase() != category.toLowerCase()) {
          return false;
        }
      }

      if (affectedPart != null &&
          affectedPart != 'Semua' &&
          affectedPart.isNotEmpty) {
        if (!issue.bagianTerdampak
            .toLowerCase()
            .contains(affectedPart.toLowerCase())) {
          return false;
        }
      }

      if (cleanQuery.isNotEmpty) {
        final matchName = issue.namaMasalah.toLowerCase().contains(cleanQuery);
        final matchLatin = issue.namaLatin.toLowerCase().contains(cleanQuery);
        final matchGejala = issue.gejala.toLowerCase().contains(cleanQuery);
        final matchPart =
            issue.bagianTerdampak.toLowerCase().contains(cleanQuery);
        return matchName || matchLatin || matchGejala || matchPart;
      }

      return true;
    }).toList();
  }

  // ==========================================
  // TABEL 3: BOOKMARKS (Relasi Simpanan) - CRUD
  // ==========================================

  List<BookmarkModel> getBookmarks([int userId = 1]) {
    return _tableBookmarks.where((b) => b.idUser == userId).toList();
  }

  bool isBookmarked(String idIssue, [int userId = 1]) {
    return _tableBookmarks
        .any((b) => b.idUser == userId && b.idIssue == idIssue);
  }

  List<IssueModel> getBookmarkedIssues([int userId = 1]) {
    final bookmarkedIds = _tableBookmarks
        .where((b) => b.idUser == userId)
        .map((b) => b.idIssue)
        .toSet();

    return _tableIssues
        .where((issue) => bookmarkedIds.contains(issue.idIssue))
        .toList();
  }

  Future<bool> toggleBookmark(String idIssue, [int userId = 1]) async {
    final index = _tableBookmarks.indexWhere(
        (b) => b.idUser == userId && b.idIssue == idIssue);

    if (index >= 0) {
      _tableBookmarks.removeAt(index);
      await _persist();
      return false;
    } else {
      _tableBookmarks.add(
        BookmarkModel(
          idBookmark: _nextBookmarkId++,
          idUser: userId,
          idIssue: idIssue,
          tanggalSimpan: DateTime.now(),
        ),
      );
      await _persist();
      return true;
    }
  }

  Future<void> removeBookmark(String idIssue, [int userId = 1]) async {
    _tableBookmarks
        .removeWhere((b) => b.idUser == userId && b.idIssue == idIssue);
    await _persist();
  }
}
