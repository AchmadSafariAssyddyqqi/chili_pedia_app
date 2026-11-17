import 'package:flutter/material.dart';
import '../data/database_service.dart';
import '../models/user_model.dart';
import '../models/issue_model.dart';

class AppState extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  UserModel? _user;
  UserModel? get user => _user;

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _selectedCategory = 'Semua'; // 'Semua', 'Penyakit', 'Hama'
  String get selectedCategory => _selectedCategory;

  String _selectedPlantPart = 'Semua'; // 'Semua', 'Daun', 'Buah', 'Akar', 'Batang'
  String get selectedPlantPart => _selectedPlantPart;

  Set<String> _bookmarkedIds = {};
  Set<String> get bookmarkedIds => _bookmarkedIds;

  bool get isAuthenticated => _user != null;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    await _db.init();
    _user = _db.getCurrentUser();
    _isDarkMode = _user?.isDarkMode ?? false;
    _refreshBookmarks();

    _isLoading = false;
    notifyListeners();
  }

  void _refreshBookmarks() {
    final bookmarks = _db.getBookmarks(_user?.idUser ?? 1);
    _bookmarkedIds = bookmarks.map((b) => b.idIssue).toSet();
  }

  bool isBookmarked(String issueId) {
    return _bookmarkedIds.contains(issueId);
  }

  Future<bool> toggleBookmark(String issueId) async {
    final userId = _user?.idUser ?? 1;
    final isAdded = await _db.toggleBookmark(issueId, userId);
    _refreshBookmarks();
    notifyListeners();
    return isAdded;
  }

  Future<void> removeBookmark(String issueId) async {
    final userId = _user?.idUser ?? 1;
    await _db.removeBookmark(issueId, userId);
    _refreshBookmarks();
    notifyListeners();
  }

  List<IssueModel> getBookmarkedIssues() {
    return _db.getBookmarkedIssues(_user?.idUser ?? 1);
  }

  List<IssueModel> getPopularIssues() {
    return _db.getPopularIssues();
  }

  List<IssueModel> getFilteredIssues() {
    return _db.searchIssues(
      query: _searchQuery,
      category: _selectedCategory,
      affectedPart: _selectedPlantPart,
    );
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSelectedPlantPart(String plantPart) {
    _selectedPlantPart = plantPart;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedCategory = 'Semua';
    _selectedPlantPart = 'Semua';
    notifyListeners();
  }

  /// Login Akun Petani
  Future<String?> login({
    required String nomorHpOrEmail,
    required String password,
  }) async {
    final error = await _db.login(
      nomorHpOrEmail: nomorHpOrEmail,
      password: password,
    );
    if (error == null) {
      _user = _db.getCurrentUser();
      _isDarkMode = _user?.isDarkMode ?? false;
      _refreshBookmarks();
      notifyListeners();
    }
    return error;
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
    final error = await _db.register(
      namaLengkap: namaLengkap,
      email: email,
      nomorHp: nomorHp,
      password: password,
      lokasiKebun: lokasiKebun,
      luasLahan: luasLahan,
      avatarIndex: avatarIndex,
      autoLogin: autoLogin,
    );
    if (error == null && autoLogin) {
      _user = _db.getCurrentUser();
      _isDarkMode = _user?.isDarkMode ?? false;
      _refreshBookmarks();
      notifyListeners();
    }
    return error;
  }

  /// 1-Click Login Akun Demo Petani
  Future<void> loginAsDemo() async {
    await _db.loginAsDemo();
    _user = _db.getCurrentUser();
    _isDarkMode = _user?.isDarkMode ?? false;
    _refreshBookmarks();
    notifyListeners();
  }

  /// Logout Akun
  Future<void> logout() async {
    await _db.logout();
    _user = null;
    _bookmarkedIds.clear();
    notifyListeners();
  }

  Future<void> updateUserProfile(UserModel updatedUser) async {
    await _db.updateUser(updatedUser);
    _user = updatedUser;
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await _db.setDarkMode(_isDarkMode);
    if (_user != null) {
      _user = _user!.copyWith(isDarkMode: _isDarkMode);
    }
    notifyListeners();
  }
}
