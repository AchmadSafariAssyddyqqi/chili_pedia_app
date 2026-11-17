import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'calculator_screen.dart';
import 'diagnostic_wizard_screen.dart';
import 'widgets/weather_card.dart';
import 'widgets/diagnosis_filter.dart';
import 'widgets/popular_carousel.dart';
import 'widgets/issue_card.dart';
import 'widgets/empty_state.dart';

class HomeScreen extends StatefulWidget {
  final AppState appState;
  final VoidCallback onNavigateToBookmarks;

  const HomeScreen({
    super.key,
    required this.appState,
    required this.onNavigateToBookmarks,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.appState.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleBookmarkToggle(String issueId, String name) async {
    HapticFeedback.lightImpact();
    final isAdded = await widget.appState.toggleBookmark(issueId);
    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isAdded ? Icons.bookmark_added_rounded : Icons.bookmark_remove_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isAdded
                    ? '$name ditambahkan ke Tersimpan'
                    : '$name dihapus dari Tersimpan',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        backgroundColor:
            isAdded ? AppTheme.primaryGreen : Colors.grey.shade800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        action: isAdded
            ? SnackBarAction(
                label: 'Lihat',
                textColor: Colors.amberAccent,
                onPressed: widget.onNavigateToBookmarks,
              )
            : null,
      ),
    );
  }

  void _showPlantingSchedule() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Icon(Icons.calendar_month_rounded, color: AppTheme.primaryGreen),
                  SizedBox(width: 8),
                  Text(
                    'Kalender & Fase Rawat Cabai',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildPhaseItem(
                'Fase 1: Semai & Vegetatif (0 - 30 HST)',
                'Fokus: Pertumbuhan akar dan daun. Waspada rebah semai (Pythium), Thrips, dan Kutu Kebul.',
                'Pupuk N & P dominan, aplikasi agen hayati Trichoderma.',
                isDark,
              ),
              _buildPhaseItem(
                'Fase 2: Generatif & Pembungaan (30 - 65 HST)',
                'Fokus: Pembentukan bunga & bakal buah. Waspada Antraknosa (Patek), Layu Bakteri, dan Lalat Buah.',
                'Tingkatkan Kalium, Kalsium & Silika. Kurangi Nitrogen berlebih.',
                isDark,
              ),
              _buildPhaseItem(
                'Fase 3: Pematangan Buah & Panen (> 65 HST)',
                'Fokus: Pemetikan rutin tiap 3-5 hari. Sanitasi buah afkir/busuk segera dari lahan.',
                'Gunakan fungisida kontak Mankozeb bergantian dengan biopestisida.',
                isDark,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Tutup Panduan'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPhaseItem(String title, String desc, String tips, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2D22) : const Color(0xFFF1F7F1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF283A2C) : const Color(0xFFD6E6D6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
          const SizedBox(height: 4),
          Text(desc, style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade300 : const Color(0xFF2C3E31))),
          const SizedBox(height: 4),
          Text('💡 Tips: $tips', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppTheme.primaryGreen)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final farmerName = widget.appState.user?.namaLengkap ?? 'Sahabat Petani';
    final filteredIssues = widget.appState.getFilteredIssues();
    final popularIssues = widget.appState.getPopularIssues();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('🌶️', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(width: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Chili',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1B5E20),
                    ),
                  ),
                  const TextSpan(
                    text: 'Pedia',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.chiliRed,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Halaman Tersimpan',
            icon: Badge(
              isLabelVisible: widget.appState.bookmarkedIds.isNotEmpty,
              backgroundColor: AppTheme.chiliRed,
              child: const Icon(Icons.bookmark_outline_rounded),
            ),
            onPressed: widget.onNavigateToBookmarks,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Sambutan Petani + Cuaca
              WeatherCard(farmerName: farmerName),
              const SizedBox(height: 14),

              // 2. Quick Action Grid (Fitur Unggulan Mahasiswa)
              Row(
                children: [
                  // Tombol Diagnosa Pintar AI
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DiagnosticWizardScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE53935), Color(0xFFC62828)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.chiliRed.withValues(alpha: 0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Text('🔬', style: TextStyle(fontSize: 22)),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Diagnosa Pintar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    'Sistem Pakar Cabai',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Tombol Kalkulator Sprayer
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CalculatorScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDark
                                ? [const Color(0xFF263D2A), const Color(0xFF1E3222)]
                                : [const Color(0xFF2E7D32), const Color(0xFF1B5E20)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryGreen.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Text('🧪', style: TextStyle(fontSize: 22)),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Kalkulator Dosis',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    'Tangki Sprayer 16L',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Baris Info Kalender Fase Tanam
              InkWell(
                onTap: _showPlantingSchedule,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1B281E) : const Color(0xFFF1F6F1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark ? const Color(0xFF283A2C) : const Color(0xFFD6E4D6),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.event_note_rounded, size: 18, color: AppTheme.primaryGreen),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Panduan Jadwal & Fase Rawat Tanam Cabai',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.grey.shade200 : const Color(0xFF1B3822),
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 3. Search Bar
              TextField(
                controller: _searchController,
                onChanged: (val) {
                  widget.appState.setSearchQuery(val);
                },
                decoration: InputDecoration(
                  hintText: 'Cari penyakit, hama, atau gejala...',
                  hintStyle: TextStyle(
                    fontSize: 13.5,
                    color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
                  ),
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            widget.appState.setSearchQuery('');
                          },
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 18),

              // 4. Menu Diagnosa (Filter Bagian Tanaman & Kategori)
              DiagnosisFilter(
                selectedPart: widget.appState.selectedPlantPart,
                selectedCategory: widget.appState.selectedCategory,
                onPartSelected: (part) {
                  widget.appState.setSelectedPlantPart(part);
                },
                onCategorySelected: (cat) {
                  widget.appState.setSelectedCategory(cat);
                },
              ),
              const SizedBox(height: 22),

              // 5. Carousel Populer (Tampil hanya jika tidak sedang filter search query)
              if (widget.appState.searchQuery.isEmpty &&
                  widget.appState.selectedPlantPart == 'Semua' &&
                  widget.appState.selectedCategory == 'Semua') ...[
                PopularCarousel(
                  popularIssues: popularIssues,
                  isBookmarked: (id) => widget.appState.isBookmarked(id),
                  onToggleBookmark: (id) {
                    final item = widget.appState.getPopularIssues().firstWhere(
                          (issue) => issue.idIssue == id,
                        );
                    _handleBookmarkToggle(id, item.namaMasalah);
                  },
                ),
                const SizedBox(height: 24),
              ],

              // 6. Section Header Katalog Masalah
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Katalog Ensiklopedia',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF1B3822),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF233527)
                              : const Color(0xFFE8F2E8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${filteredIssues.length} ditemukan',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppTheme.lightGreen
                                : AppTheme.primaryGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (widget.appState.searchQuery.isNotEmpty ||
                      widget.appState.selectedPlantPart != 'Semua' ||
                      widget.appState.selectedCategory != 'Semua')
                    TextButton(
                      onPressed: () {
                        _searchController.clear();
                        widget.appState.resetFilters();
                      },
                      child: const Text('Reset Filter'),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // 7. List Masalah
              if (filteredIssues.isEmpty)
                EmptyStateWidget(
                  icon: Icons.search_off_rounded,
                  title: 'Tidak Ada Masalah Ditemukan',
                  description:
                      'Coba gunakan kata kunci lain seperti "daun kuning", "patek", "ulat", atau reset filter.',
                  buttonText: 'Reset Semua Filter',
                  onButtonPressed: () {
                    _searchController.clear();
                    widget.appState.resetFilters();
                  },
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredIssues.length,
                  itemBuilder: (context, index) {
                    final issue = filteredIssues[index];
                    final isBookmarked =
                        widget.appState.isBookmarked(issue.idIssue);

                    return IssueCard(
                      issue: issue,
                      isBookmarked: isBookmarked,
                      onToggleBookmark: () {
                        _handleBookmarkToggle(
                            issue.idIssue, issue.namaMasalah);
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
