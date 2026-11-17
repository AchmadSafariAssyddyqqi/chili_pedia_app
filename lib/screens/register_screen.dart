import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  final AppState appState;

  const RegisterScreen({super.key, required this.appState});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _luasController = TextEditingController();

  int _selectedAvatarIndex = 0;
  bool _isObscure = true;
  bool _isLoading = false;
  String? _errorMessage;

  final List<Map<String, dynamic>> _avatars = [
    {'emoji': '👨‍🌾', 'label': 'Pak Petani'},
    {'emoji': '👩‍🌾', 'label': 'Bu Petani'},
    {'emoji': '🧑‍🌾', 'label': 'Petani Muda'},
    {'emoji': '🌿', 'label': 'Agronomis'},
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _lokasiController.dispose();
    _luasController.dispose();
    super.dispose();
  }

  void _fillSampleData() {
    _namaController.text = 'Ahmad Fauzi';
    _emailController.text = 'ahmad.fauzi@gmail.com';
    _phoneController.text = '085712345678';
    _passwordController.text = 'cabaisubur123';
    _lokasiController.text = 'Desa Sumber Sari, Kediri';
    _luasController.text = '1000 meter persegi';
    setState(() {});
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    HapticFeedback.lightImpact();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final error = await widget.appState.register(
      namaLengkap: _namaController.text,
      email: _emailController.text,
      nomorHp: _phoneController.text,
      password: _passwordController.text,
      lokasiKebun: _lokasiController.text,
      luasLahan: _luasController.text,
      avatarIndex: _selectedAvatarIndex,
    );

    if (!mounted) return;

    if (error == null) {
      // Sukses registrasi -> Berikan notifikasi & kembali ke LoginScreen (jangan langsung masuk)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Akun ${_namaController.text} berhasil dibuat! Silakan masuk dengan akun Anda.',
                ),
              ),
            ],
          ),
          backgroundColor: AppTheme.primaryGreen,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );

      // Kembali ke layar login dengan membawa nomor HP / email agar otomatis terisi
      final registeredId = _phoneController.text.trim().isNotEmpty
          ? _phoneController.text.trim()
          : _emailController.text.trim();
      Navigator.pop(context, registeredId);
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Akun Petani',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: _fillSampleData,
            child: const Text('Isi Contoh'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Error Banner
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.chiliRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.chiliRed.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline_rounded, color: AppTheme.chiliRed, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(fontSize: 12, color: AppTheme.chiliRed),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Avatar Picker
                Text(
                  'Pilih Avatar Petani',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1B3822),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(_avatars.length, (index) {
                    final item = _avatars[index];
                    final isSelected = _selectedAvatarIndex == index;

                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _selectedAvatarIndex = index);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark
                                  ? AppTheme.lightGreen.withValues(alpha: 0.2)
                                  : const Color(0xFFE8F5E9))
                              : (isDark ? const Color(0xFF1E2B22) : Colors.white),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? (isDark ? AppTheme.lightGreen : AppTheme.primaryGreen)
                                : (isDark ? const Color(0xFF2C3E31) : const Color(0xFFE0E0E0)),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              item['emoji'] as String,
                              style: const TextStyle(fontSize: 26),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['label'] as String,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected
                                    ? (isDark ? AppTheme.lightGreen : AppTheme.primaryGreen)
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),

                // Input Nama Lengkap
                Text(
                  'Nama Lengkap Petani',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey.shade300 : const Color(0xFF2C3E31),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    hintText: 'Contoh: Ahmad Fauzi',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Nama wajib diisi';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Input Email
                Text(
                  'Alamat Email Petani',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey.shade300 : const Color(0xFF2C3E31),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Contoh: ahmad.fauzi@gmail.com',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Email wajib diisi';
                    if (!val.contains('@') || !val.contains('.')) {
                      return 'Format email tidak valid (harus ada @ dan domain)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Input Nomor HP
                Text(
                  'Nomor HP / WhatsApp',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey.shade300 : const Color(0xFF2C3E31),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: 'Contoh: 085712345678',
                    prefixIcon: Icon(Icons.phone_android_rounded),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Nomor HP wajib diisi';
                    if (val.trim().length < 8) return 'Nomor HP minimal 8 digit';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Input Kata Sandi
                Text(
                  'Kata Sandi Akun',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey.shade300 : const Color(0xFF2C3E31),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    hintText: 'Minimal 6 karakter',
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() => _isObscure = !_isObscure);
                      },
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Kata sandi wajib diisi';
                    if (val.trim().length < 6) return 'Kata sandi minimal 6 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Input Lokasi Kebun
                Text(
                  'Lokasi Kebun / Desa',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey.shade300 : const Color(0xFF2C3E31),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _lokasiController,
                  decoration: const InputDecoration(
                    hintText: 'Contoh: Desa Sumber Sari, Kediri',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Lokasi kebun wajib diisi';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Input Luas Lahan
                Text(
                  'Luas Lahan Cabai',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey.shade300 : const Color(0xFF2C3E31),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _luasController,
                  decoration: const InputDecoration(
                    hintText: 'Contoh: 1000 meter persegi / 0.5 Hektar',
                    prefixIcon: Icon(Icons.crop_landscape_rounded),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Luas lahan wajib diisi';
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                // Tombol Daftar
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? AppTheme.lightGreen : AppTheme.primaryGreen,
                      foregroundColor: isDark ? Colors.black : Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                          )
                        : const Text(
                            'Daftar & Masuk ke ChiliPedia',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                // Link Kembali ke Login
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Sudah punya akun? Masuk di sini',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppTheme.lightGreen : AppTheme.primaryGreen,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
