import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/database_service.dart';
import '../data/diagnostic_data.dart';
import '../models/diagnostic_model.dart';
import '../models/issue_model.dart';
import '../theme/app_theme.dart';
import 'detail_screen.dart';

class DiagnosticWizardScreen extends StatefulWidget {
  const DiagnosticWizardScreen({super.key});

  @override
  State<DiagnosticWizardScreen> createState() => _DiagnosticWizardScreenState();
}

class _DiagnosticWizardScreenState extends State<DiagnosticWizardScreen> {
  int _currentStep = 0;
  String _selectedPart = 'Daun';
  final Set<String> _selectedSymptomIds = {};
  String _selectedWeather = 'Hujan / Lembap';

  List<DiagnosticResult> _results = [];
  bool _isAnalyzing = false;

  final List<Map<String, dynamic>> _parts = [
    {'name': 'Daun', 'icon': Icons.energy_savings_leaf_rounded, 'desc': 'Kuning, keriting, bercak, berlubang'},
    {'name': 'Buah', 'icon': Icons.circle_rounded, 'desc': 'Busuk, patek melekuk, belatung'},
    {'name': 'Batang', 'icon': Icons.line_weight_rounded, 'desc': 'Layu mendadak, busuk cincin, patah'},
    {'name': 'Akar', 'icon': Icons.grass_rounded, 'desc': 'Layu perlahan, akar membusuk cokelat'},
  ];

  final List<Map<String, dynamic>> _weatherOptions = [
    {'title': 'Hujan / Lembap', 'icon': Icons.water_drop_rounded, 'desc': 'Suhu dingin, embun pekat, rawan jamur & bakteri'},
    {'title': 'Kemarau / Panas', 'icon': Icons.wb_sunny_rounded, 'desc': 'Suhu terik, kering, rawan ledakan kutu & tungau'},
    {'title': 'Pancaroba / Normal', 'icon': Icons.cloud_outlined, 'desc': 'Cuaca berganti-ganti, masa peralihan'},
  ];

  void _runDiagnostic() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isAnalyzing = true;
    });

    Future.delayed(const Duration(milliseconds: 650), () {
      if (!mounted) return;
      final results = DiagnosticEngine.runInference(
        selectedPart: _selectedPart,
        selectedSymptomIds: _selectedSymptomIds.toList(),
        weatherCondition: _selectedWeather,
      );

      setState(() {
        _results = results;
        _isAnalyzing = false;
        _currentStep = 2; // Jump to Result step
      });
    });
  }

  void _reset() {
    HapticFeedback.lightImpact();
    setState(() {
      _currentStep = 0;
      _selectedPart = 'Daun';
      _selectedSymptomIds.clear();
      _selectedWeather = 'Hujan / Lembap';
      _results.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Diagnosa Gejala Cerdas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Ulangi Diagnosa',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _reset,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Step Progress Indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: isDark ? const Color(0xFF131A15) : Colors.white,
              child: Row(
                children: [
                  _buildStepIndicator(0, '1. Bagian', _currentStep >= 0),
                  _buildStepDivider(_currentStep >= 1),
                  _buildStepIndicator(1, '2. Gejala', _currentStep >= 1),
                  _buildStepDivider(_currentStep >= 2),
                  _buildStepIndicator(2, '3. Hasil', _currentStep >= 2),
                ],
              ),
            ),
            const Divider(height: 1),

            // Content Area
            Expanded(
              child: _isAnalyzing
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: AppTheme.primaryGreen,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Sistem Pakar Sedang Menganalisis...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF1B3822),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Mencocokkan pola gejala & riwayat cuaca kebun',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    )
                  : IndexedStack(
                      index: _currentStep,
                      children: [
                        _buildStep1PartSelection(isDark),
                        _buildStep2SymptomSelection(isDark),
                        _buildStep3Results(isDark),
                      ],
                    ),
            ),

            // Bottom Navigation Controls (Hanya di Step 0 & 1)
            if (_currentStep < 2 && !_isAnalyzing)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF162018) : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    if (_currentStep > 0) ...[
                      OutlinedButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          setState(() => _currentStep--);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Kembali'),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          if (_currentStep == 0) {
                            setState(() => _currentStep = 1);
                          } else if (_currentStep == 1) {
                            if (_selectedSymptomIds.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Pilih minimal 1 ciri-ciri gejala fisik'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              return;
                            }
                            _runDiagnostic();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? AppTheme.lightGreen : AppTheme.primaryGreen,
                          foregroundColor: isDark ? Colors.black : Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text(
                          _currentStep == 0 ? 'Lanjut ke Pilih Gejala ›' : 'Mulai Analisa Sekarang ⚡',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int stepIndex, String title, bool isActive) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: isActive ? AppTheme.primaryGreen : Colors.grey.shade400,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${stepIndex + 1}',
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? AppTheme.primaryGreen : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepDivider(bool isActive) {
    return Container(
      width: 24,
      height: 2,
      color: isActive ? AppTheme.primaryGreen : Colors.grey.shade300,
      margin: const EdgeInsets.only(bottom: 16),
    );
  }

  // STEP 1: PILIH BAGIAN TANAMAN
  Widget _buildStep1PartSelection(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Bagian mana yang menunjukkan gejala sakit?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF1B3822),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Pemeriksaan yang spesifik menghasilkan akurasi diagnosa lebih tinggi.',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 20),
        ..._parts.map((p) {
          final isSelected = _selectedPart == p['name'];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() {
                  _selectedPart = p['name'] as String;
                  _selectedSymptomIds.clear(); // reset gejala saat ganti organ
                });
              },
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? const Color(0xFF233627) : const Color(0xFFEAF5EA))
                      : (isDark ? const Color(0xFF19251D) : Colors.white),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? (isDark ? AppTheme.lightGreen : AppTheme.primaryGreen)
                        : (isDark ? const Color(0xFF283A2C) : const Color(0xFFE2EBE2)),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryGreen.withValues(alpha: 0.2)
                            : (isDark ? const Color(0xFF253729) : const Color(0xFFF1F6F1)),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        p['icon'] as IconData,
                        color: isSelected
                            ? (isDark ? AppTheme.lightGreen : AppTheme.primaryGreen)
                            : Colors.grey,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p['name'] as String,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF1B3822),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            p['desc'] as String,
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? (isDark ? AppTheme.lightGreen : AppTheme.primaryGreen)
                              : Colors.grey.shade400,
                          width: isSelected ? 6.5 : 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  // STEP 2: PILIH GEJALA & CUACA
  Widget _buildStep2SymptomSelection(bool isDark) {
    final relevantSymptoms = allSymptomsList
        .where((s) => s.plantPart.toLowerCase() == _selectedPart.toLowerCase())
        .toList();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Pilih Ciri-Ciri Gejala Fisik',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF1B3822),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Centang semua kondisi yang Anda lihat pada bagian $_selectedPart tanaman cabai:',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 16),
        ...relevantSymptoms.map((sym) {
          final isChecked = _selectedSymptomIds.contains(sym.id);
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: CheckboxListTile(
              value: isChecked,
              activeColor: isDark ? AppTheme.lightGreen : AppTheme.primaryGreen,
              checkColor: isDark ? Colors.black : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(
                  color: isChecked
                      ? (isDark ? AppTheme.lightGreen : AppTheme.primaryGreen)
                      : (isDark ? const Color(0xFF283A2C) : const Color(0xFFE2EBE2)),
                ),
              ),
              tileColor: isChecked
                  ? (isDark ? const Color(0xFF233627) : const Color(0xFFEBF6EB))
                  : (isDark ? const Color(0xFF19251D) : Colors.white),
              title: Text(
                sym.label,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                sym.description,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              onChanged: (val) {
                HapticFeedback.selectionClick();
                setState(() {
                  if (val == true) {
                    _selectedSymptomIds.add(sym.id);
                  } else {
                    _selectedSymptomIds.remove(sym.id);
                  }
                });
              },
            ),
          );
        }),
        const SizedBox(height: 20),
        Text(
          'Faktor Lingkungan & Cuaca Terkini',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF1B3822),
          ),
        ),
        const SizedBox(height: 10),
        ..._weatherOptions.map((w) {
          final isSelected = _selectedWeather == w['title'];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () {
                setState(() => _selectedWeather = w['title'] as String);
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? const Color(0xFF243628) : const Color(0xFFEDF7ED))
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? (isDark ? AppTheme.lightGreen : AppTheme.primaryGreen)
                        : (isDark ? const Color(0xFF283A2C) : const Color(0xFFE2EBE2)),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(w['icon'] as IconData, size: 20, color: AppTheme.primaryGreen),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            w['title'] as String,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            w['desc'] as String,
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  // STEP 3: HASIL DIAGNOSA CERDAS
  Widget _buildStep3Results(bool isDark) {
    if (_results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.help_outline_rounded, size: 56, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Tidak Ditemukan Kecocokan Spesifik',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Gejala yang dipilih terlalu umum. Coba pilih kombinasi gejala lain atau periksa katalog lengkap.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _reset,
                child: const Text('Ulangi Diagnosa'),
              ),
            ],
          ),
        ),
      );
    }

    final db = DatabaseService();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Top Banner Kesimpulan
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF1B3822), const Color(0xFF122416)]
                  : [const Color(0xFF2E7D32), const Color(0xFF1B5E20)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.verified_rounded, color: Colors.amberAccent, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'HASIL ANALISA SISTEM PAKAR',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Terdeteksi Masalah Dominan!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Berdasarkan ${_selectedSymptomIds.length} gejala fisik dan kondisi cuaca $_selectedWeather.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Text(
          'Tingkat Probabilitas Kecocokan:',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF1B3822),
          ),
        ),
        const SizedBox(height: 12),

        ..._results.map((res) {
          final IssueModel? issue = db.getIssueById(res.issueId);
          if (issue == null) return const SizedBox.shrink();

          final bool isTop = res == _results.first;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: isTop ? 3 : 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(
                color: isTop
                    ? AppTheme.chiliRed
                    : (isDark ? const Color(0xFF283A2C) : const Color(0xFFE2EBE2)),
                width: isTop ? 1.8 : 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isTop
                              ? AppTheme.chiliRed.withValues(alpha: 0.12)
                              : Colors.grey.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          res.matchingLevel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isTop ? AppTheme.chiliRed : Colors.grey.shade600,
                          ),
                        ),
                      ),
                      Text(
                        '${res.confidencePercentage.toInt()}% Akurat',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isTop ? AppTheme.chiliRed : AppTheme.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: res.confidencePercentage / 100.0,
                      minHeight: 8,
                      backgroundColor: isDark ? const Color(0xFF2A3D2E) : const Color(0xFFE6EFE6),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isTop ? AppTheme.chiliRed : AppTheme.primaryGreen,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Text(issue.iconSymbol, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              issue.namaMasalah,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              issue.namaLatin,
                              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Sifat Penyakit
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E2C21) : const Color(0xFFF4F8F4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Tindakan Utama: ${issue.solusi.split('\n').first}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, height: 1.3, color: isDark ? Colors.grey.shade300 : const Color(0xFF2C3E31)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(issueId: issue.idIssue),
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                      label: const Text('Buka Solusi & Langkah Pengendalian'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isTop ? AppTheme.chiliRed : AppTheme.primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        Center(
          child: TextButton.icon(
            onPressed: _reset,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Ulangi Diagnosa Tanaman'),
          ),
        ),
      ],
    );
  }
}
