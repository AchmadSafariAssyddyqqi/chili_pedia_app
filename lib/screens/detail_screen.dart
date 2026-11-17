import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/database_service.dart';
import '../models/issue_model.dart';
import '../theme/app_theme.dart';
import 'calculator_screen.dart';

class DetailScreen extends StatefulWidget {
  final String issueId;

  const DetailScreen({super.key, required this.issueId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  final DatabaseService _db = DatabaseService();
  late TabController _tabController;
  IssueModel? _issue;
  bool _isBookmarked = false;

  // State Checklist Tanggap Darurat 24 Jam
  final Map<int, bool> _emergencyChecklist = {
    0: false,
    1: false,
    2: false,
    3: false,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadData() {
    final issue = _db.getIssueById(widget.issueId);
    final user = _db.getCurrentUser();
    final bookmarked = _db.isBookmarked(widget.issueId, user?.idUser ?? 1);

    setState(() {
      _issue = issue;
      _isBookmarked = bookmarked;
    });
  }

  Future<void> _toggleBookmark() async {
    HapticFeedback.lightImpact();
    final user = _db.getCurrentUser();
    final isAdded =
        await _db.toggleBookmark(widget.issueId, user?.idUser ?? 1);

    setState(() {
      _isBookmarked = isAdded;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isAdded
                  ? Icons.bookmark_added_rounded
                  : Icons.bookmark_remove_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isAdded
                    ? 'Disimpan ke Daftar Tersimpan'
                    : 'Dihapus dari Daftar Tersimpan',
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor:
            isAdded ? AppTheme.primaryGreen : Colors.grey.shade800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _shareSummary() {
    if (_issue == null) return;
    HapticFeedback.mediumImpact();
    _showShareModal();
  }

  void _showShareModal() {
    final issue = _issue!;
    int selectedRecipient = 0; // 0: Kios, 1: PPL, 2: Kelompok Tani
    bool isCopied = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final isDark = Theme.of(context).brightness == Brightness.dark;

            // Generate template text based on recipient
            String messageText = '';
            if (selectedRecipient == 0) {
              messageText =
                  'Halo Kios Pertanian,\n'
                  'Saya butuh obat untuk tanaman cabai dengan rincian berikut:\n\n'
                  '🌱 Masalah: ${issue.namaMasalah} (${issue.namaLatin})\n'
                  '🍃 Bagian: ${issue.bagianTerdampak}\n'
                  '🔍 Gejala: ${issue.gejala.split('.').first}.\n'
                  '💊 Rekomendasi Solusi: ${issue.solusi.split('\n').first}\n\n'
                  'Apakah tersedia stok obat/bahan aktif yang sesuai? Terima kasih.\n'
                  '(Dikirim via Aplikasi Petani ChiliPedia)';
            } else if (selectedRecipient == 1) {
              messageText =
                  'Yth. Bapak/Ibu Penyuluh Pertanian (PPL),\n'
                  'Izin berkonsultasi mengenai kondisi tanaman cabai di kebun saya:\n\n'
                  '🌱 Gejala Masalah: ${issue.namaMasalah}\n'
                  '🍃 Organ Terdampak: ${issue.bagianTerdampak}\n'
                  '🔍 Kondisi Fisik: ${issue.gejala}\n'
                  '⚠️ Tingkat Bahaya: ${issue.tingkatBahaya}\n\n'
                  'Mohon arahan dan saran penanganan lapangan yang tepat. Terima kasih.\n'
                  '(Dikirim via Aplikasi Petani ChiliPedia)';
            } else {
              messageText =
                  '⚠️ PEMBERITAHUAN KELOMPOK TANI (GAPOKTAN) ⚠️\n'
                  'Ditemukan potensi wabah pada kebun cabai:\n\n'
                  '🔴 Penyakit/Hama: ${issue.namaMasalah}\n'
                  '🍃 Bagian: ${issue.bagianTerdampak}\n'
                  '🔍 Ciri Serangan: ${issue.gejala.split('.').first}.\n\n'
                  'Harap rekan-rekan petani memeriksa lahan masing-masing agar penularan dapat diantisipasi serempak.\n'
                  '(Dikirim via Aplikasi Petani ChiliPedia)';
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
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
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGreen.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.share_rounded,
                            color: AppTheme.primaryGreen,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bagikan Diagnosa & Obat',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Pilih tujuan pesan untuk format teks otomatis',
                                style: TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Selector Target Penerima
                    const Text(
                      'Kirim / Konsultasikan ke:',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildRecipientChip(
                          index: 0,
                          label: 'Kios Pertanian',
                          icon: Icons.storefront_rounded,
                          isSelected: selectedRecipient == 0,
                          isDark: isDark,
                          onTap: () {
                            setModalState(() {
                              selectedRecipient = 0;
                              isCopied = false;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildRecipientChip(
                          index: 1,
                          label: 'Penyuluh (PPL)',
                          icon: Icons.school_rounded,
                          isSelected: selectedRecipient == 1,
                          isDark: isDark,
                          onTap: () {
                            setModalState(() {
                              selectedRecipient = 1;
                              isCopied = false;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildRecipientChip(
                          index: 2,
                          label: 'Kelompok Tani',
                          icon: Icons.groups_rounded,
                          isSelected: selectedRecipient == 2,
                          isDark: isDark,
                          onTap: () {
                            setModalState(() {
                              selectedRecipient = 2;
                              isCopied = false;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Pratinjau Teks Pesan Siap Kirim
                    const Text(
                      'Pratinjau Pesan Siap Kirim:',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF19271E) : const Color(0xFFF1F6F1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark ? const Color(0xFF283A2C) : const Color(0xFFD6E4D6),
                        ),
                      ),
                      child: Text(
                        messageText,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.45,
                          color: isDark ? Colors.grey.shade300 : const Color(0xFF2C3E31),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Tombol Salin & Siap Tempel ke WhatsApp
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Clipboard.setData(ClipboardData(text: messageText));
                          setModalState(() => isCopied = true);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Row(
                                children: [
                                  Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Pesan berhasil disalin! Buka WhatsApp lalu tempel (paste) ke chat.',
                                    ),
                                  ),
                                ],
                              ),
                              duration: Duration(seconds: 3),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppTheme.primaryGreen,
                            ),
                          );
                        },
                        icon: Icon(
                          isCopied ? Icons.check_circle_rounded : Icons.copy_rounded,
                          size: 18,
                        ),
                        label: Text(
                          isCopied
                              ? 'Tersalin! Buka WhatsApp & Tempel Pesan'
                              : 'Salin Pesan untuk Kirim via WhatsApp',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isCopied ? const Color(0xFF2E7D32) : const Color(0xFF25D366), // WhatsApp Green
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        '💡 Teks akan otomatis tersalin. Anda tinggal menempelkannya (paste) di WhatsApp, SMS, atau Telegram.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10.5,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRecipientChip({
    required int index,
    required String label,
    required IconData icon,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? AppTheme.lightGreen : AppTheme.primaryGreen)
                : (isDark ? const Color(0xFF1E2B22) : Colors.white),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? (isDark ? AppTheme.lightGreen : AppTheme.primaryGreen)
                  : (isDark ? const Color(0xFF2C3E31) : const Color(0xFFD6E4D6)),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? (isDark ? Colors.black : Colors.white)
                    : (isDark ? AppTheme.lightGreen : AppTheme.primaryGreen),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? (isDark ? Colors.black : Colors.white)
                      : (isDark ? Colors.grey.shade300 : const Color(0xFF2C3E31)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDangerColor(String danger) {
    switch (danger.toLowerCase()) {
      case 'tinggi':
        return AppTheme.chiliRed;
      case 'sedang':
        return AppTheme.warningOrange;
      default:
        return AppTheme.primaryGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_issue == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Masalah')),
        body: const Center(
          child: Text('Data masalah tanaman cabai tidak ditemukan.'),
        ),
      );
    }

    final issue = _issue!;
    final dangerColor = _getDangerColor(issue.tingkatBahaya);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          issue.kategori,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Salin Ringkasan',
            icon: const Icon(Icons.share_outlined),
            onPressed: _shareSummary,
          ),
          IconButton(
            tooltip: _isBookmarked ? 'Hapus Simpanan' : 'Simpan Artikel',
            icon: Icon(
              _isBookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              color: _isBookmarked ? AppTheme.chiliRed : null,
              size: 26,
            ),
            onPressed: _toggleBookmark,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Top Hero Card Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E2D22), const Color(0xFF162018)]
                    : [const Color(0xFFF1F8F1), const Color(0xFFE8F2E8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border(
                bottom: BorderSide(
                  color: isDark
                      ? const Color(0xFF2E4433)
                      : const Color(0xFFD6E6D6),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Hero(
                      tag: 'issue_icon_${issue.idIssue}',
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF283B2D) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          issue.iconSymbol,
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                issue.idIssue,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppTheme.lightGreen
                                      : AppTheme.primaryGreen,
                                  letterSpacing: 1,
                                ),
                              ),
                              const Spacer(),
                              _buildChip(
                                icon: Icons.warning_amber_rounded,
                                label: issue.tingkatBahaya,
                                color: dangerColor,
                                isDark: isDark,
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            issue.namaMasalah,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1B3822),
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            issue.namaLatin,
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildChip(
                      icon: Icons.category_rounded,
                      label: issue.kategori,
                      color: issue.kategori == 'Penyakit'
                          ? AppTheme.chiliRed
                          : AppTheme.warningOrange,
                      isDark: isDark,
                    ),
                    const SizedBox(width: 8),
                    _buildChip(
                      icon: Icons.eco_rounded,
                      label: 'Bagian: ${issue.bagianTerdampak}',
                      color: AppTheme.primaryGreen,
                      isDark: isDark,
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CalculatorScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.calculate_outlined, size: 16),
                      label: const Text('Hitung Dosis', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Segmented Tabs
          Container(
            color: isDark ? const Color(0xFF131A15) : Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: isDark ? AppTheme.lightGreen : AppTheme.primaryGreen,
              indicatorWeight: 3,
              labelColor: isDark ? AppTheme.lightGreen : AppTheme.primaryGreen,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: const [
                Tab(icon: Icon(Icons.biotech_outlined, size: 18), text: 'Gejala'),
                Tab(icon: Icon(Icons.medication_outlined, size: 18), text: 'Solusi'),
                Tab(icon: Icon(Icons.checklist_rounded, size: 18), text: 'Tanggap Darurat'),
              ],
            ),
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // TAB 1: GEJALA LENGKAP
                ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildCardSection(
                      title: 'Ciri-Ciri Kerusakan Fisik',
                      icon: Icons.search_rounded,
                      content: issue.gejala,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 16),
                    _buildCardSection(
                      title: 'Pencegahan & Perawatan Lahan',
                      icon: Icons.shield_outlined,
                      content: issue.pencegahan,
                      isDark: isDark,
                    ),
                  ],
                ),

                // TAB 2: SOLUSI & OBAT
                ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildCardSection(
                      title: 'Rekomendasi Penanganan Teknis & Kimiawi',
                      icon: Icons.healing_rounded,
                      content: issue.solusi,
                      isDark: isDark,
                      accentColor: AppTheme.primaryGreen,
                    ),
                    const SizedBox(height: 16),
                    // Quick Tank Dosing Banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E2D22) : const Color(0xFFEAF5EA),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? const Color(0xFF2E4433) : const Color(0xFFCBE3CB),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.science_rounded, color: AppTheme.primaryGreen, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Butuh Takaran Tangki Semprot?',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Gunakan Kalkulator Sprayer untuk menghitung takaran ml/gram obat per tangki 16L.',
                            style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CalculatorScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.calculate_rounded, size: 16),
                              label: const Text('Buka Kalkulator Tangki'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryGreen,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // TAB 3: CHECKLIST TANGGAP DARURAT 24 JAM
                ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF281C1C) : const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark ? const Color(0xFF4A2525) : const Color(0xFFFFCDD2),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.timer_outlined, color: AppTheme.chiliRed, size: 22),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Lakukan 4 tindakan ini dalam 1x24 jam untuk membatasi penularan di kebun:',
                              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppTheme.chiliRed),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildChecklistItem(
                      0,
                      'Eradikasi / Isolasi Tanaman Sakit',
                      'Petik buah sakit atau cabut tanaman bergejala parah, masukkan ke kantong rapat agar spora/vektor tidak menyebar.',
                      isDark,
                    ),
                    _buildChecklistItem(
                      1,
                      'Sanitasi & Semprot Sisi Bawah Daun',
                      'Aplikasi penyemprotan difokuskan pada bagian bawah daun dan celah tajuk tanaman pada pagi atau sore hari.',
                      isDark,
                    ),
                    _buildChecklistItem(
                      2,
                      'Perbaiki Sirkulasi & Drainase Lahan',
                      'Bongkar genangan air di lorong bedengan agar tanah tidak terlalu lembap yang memicu jamur & bakteri.',
                      isDark,
                    ),
                    _buildChecklistItem(
                      3,
                      'Beri Tambahan Nutrisi Kalsium & Silika',
                      'Tingkatkan ketebalan dinding sel tanaman dengan kalsium untuk menahan tusukan mulut serangga atau penetrasi jamur.',
                      isDark,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(int index, String title, String desc, bool isDark) {
    final bool checked = _emergencyChecklist[index] ?? false;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CheckboxListTile(
        value: checked,
        onChanged: (val) {
          HapticFeedback.selectionClick();
          setState(() {
            _emergencyChecklist[index] = val ?? false;
          });
        },
        activeColor: AppTheme.primaryGreen,
        checkColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: checked
                ? AppTheme.primaryGreen
                : (isDark ? const Color(0xFF283A2C) : const Color(0xFFE2EBE2)),
          ),
        ),
        tileColor: checked
            ? (isDark ? const Color(0xFF1E2F23) : const Color(0xFFEBF6EB))
            : (isDark ? const Color(0xFF19251D) : Colors.white),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            decoration: checked ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          desc,
          style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
        ),
      ),
    );
  }

  Widget _buildCardSection({
    required String title,
    required IconData icon,
    required String content,
    required bool isDark,
    Color? accentColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF19271E) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF283A2C) : const Color(0xFFE2EBE2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: accentColor ?? (isDark ? AppTheme.lightGreen : AppTheme.primaryGreen)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1B3822),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 13.5,
              height: 1.6,
              color: isDark ? Colors.grey.shade200 : const Color(0xFF2C3E31),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required IconData icon,
    required String label,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
