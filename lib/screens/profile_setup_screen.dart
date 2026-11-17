import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'main_wrapper.dart';

class ProfileSetupScreen extends StatefulWidget {
  final AppState appState;

  const ProfileSetupScreen({super.key, required this.appState});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _luasController = TextEditingController();

  int _selectedAvatarIndex = 0;
  bool _isSaving = false;

  final List<Map<String, dynamic>> _avatars = [
    {'emoji': '👨‍🌾', 'label': 'Pak Petani'},
    {'emoji': '👩‍🌾', 'label': 'Bu Petani'},
    {'emoji': '🧑‍🌾', 'label': 'Petani Muda'},
    {'emoji': '🌿', 'label': 'Agronomis'},
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _lokasiController.dispose();
    _luasController.dispose();
    super.dispose();
  }

  void _fillSampleData() {
    _namaController.text = 'Budi Santoso';
    _lokasiController.text = 'Desa Pamekasan, Jawa Timur';
    _luasController.text = '500 meter persegi';
    setState(() {});
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    await widget.appState.register(
      namaLengkap: _namaController.text,
      email: 'budi.santoso@chilipedia.id',
      nomorHp: '08123456789',
      password: 'petani123',
      lokasiKebun: _lokasiController.text,
      luasLahan: _luasController.text,
      avatarIndex: _selectedAvatarIndex,
    );

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainWrapper(appState: widget.appState),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil Petani Baru',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: _fillSampleData,
            child: const Text('Contoh Cepat'),
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
                // Header Banner
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF192A1D)
                        : const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF2C3E31)
                          : const Color(0xFFC8E6C9),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Text(
                          '🌱',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selamat Datang di ChiliPedia!',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF1B5E20),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Lengkapi profil kebun Anda agar diagnosis & rekomendasi lebih relevan.',
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.3,
                                color: isDark
                                    ? Colors.grey.shade300
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Avatar Picker
                Text(
                  'Pilih Karakter Avatar',
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
                        setState(() => _selectedAvatarIndex = index);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark
                                  ? AppTheme.lightGreen.withValues(alpha: 0.2)
                                  : const Color(0xFFE8F5E9))
                              : (isDark
                                  ? const Color(0xFF1E2B22)
                                  : Colors.white),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? (isDark
                                    ? AppTheme.lightGreen
                                    : AppTheme.primaryGreen)
                                : (isDark
                                    ? const Color(0xFF2C3E31)
                                    : const Color(0xFFE0E0E0)),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              item['emoji'] as String,
                              style: const TextStyle(fontSize: 28),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['label'] as String,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? (isDark
                                        ? AppTheme.lightGreen
                                        : AppTheme.primaryGreen)
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),

                // Input Nama Lengkap
                Text(
                  'Nama Lengkap Petani',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey.shade300 : const Color(0xFF2C3E31),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    hintText: 'Contoh: Budi Santoso',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama lengkap tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // Input Lokasi Kebun
                Text(
                  'Lokasi Kebun / Desa',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey.shade300 : const Color(0xFF2C3E31),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _lokasiController,
                  decoration: const InputDecoration(
                    hintText: 'Contoh: Desa Pamekasan, Jawa Timur',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Lokasi kebun wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // Input Luas Lahan
                Text(
                  'Luas Lahan Cabai',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey.shade300 : const Color(0xFF2C3E31),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _luasController,
                  decoration: const InputDecoration(
                    hintText: 'Contoh: 500 meter persegi / 0.5 Hektar',
                    prefixIcon: Icon(Icons.square_foot_rounded),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Luas lahan wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Tombol Simpan & Masuk
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark
                          ? AppTheme.lightGreen
                          : AppTheme.primaryGreen,
                      foregroundColor: isDark ? Colors.black : Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Mulai Eksplorasi ChiliPedia',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_rounded, size: 18),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
