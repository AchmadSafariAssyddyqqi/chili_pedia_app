import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'widgets/issue_card.dart';
import 'widgets/empty_state.dart';

class BookmarkScreen extends StatelessWidget {
  final AppState appState;
  final VoidCallback onNavigateToHome;

  const BookmarkScreen({
    super.key,
    required this.appState,
    required this.onNavigateToHome,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bookmarkedIssues = appState.getBookmarkedIssues();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Tersimpan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (bookmarkedIssues.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.chiliRed.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${bookmarkedIssues.length} Disimpan',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.chiliRed,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: bookmarkedIssues.isEmpty
          ? EmptyStateWidget(
              icon: Icons.bookmark_border_rounded,
              title: 'Belum Ada yang Disimpan',
              description:
                  'Tandai penyakit atau hama yang sedang menyerang kebun cabai Anda agar mudah diakses kembali tanpa perlu mencari ulang.',
              buttonText: 'Jelajahi Ensiklopedia',
              onButtonPressed: onNavigateToHome,
            )
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              children: [
                // Info Banner
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF19271E)
                        : const Color(0xFFEBF5EB),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF273C2E)
                          : const Color(0xFFD4E7D4),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: AppTheme.primaryGreen,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Daftar ini disimpan secara lokal di perangkat Anda, dapat diakses kapan saja tanpa internet.',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? Colors.grey.shade300
                                : const Color(0xFF2C3E31),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // List Bookmark
                ...bookmarkedIssues.map((issue) {
                  return IssueCard(
                    issue: issue,
                    isBookmarked: true,
                    onToggleBookmark: () async {
                      await appState.removeBookmark(issue.idIssue);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                '${issue.namaMasalah} dihapus dari Tersimpan'),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }
                    },
                  );
                }),
              ],
            ),
    );
  }
}
