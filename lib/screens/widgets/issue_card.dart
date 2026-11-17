import 'package:flutter/material.dart';
import '../../models/issue_model.dart';
import '../../theme/app_theme.dart';
import '../detail_screen.dart';

class IssueCard extends StatelessWidget {
  final IssueModel issue;
  final bool isBookmarked;
  final VoidCallback onToggleBookmark;

  const IssueCard({
    super.key,
    required this.issue,
    required this.isBookmarked,
    required this.onToggleBookmark,
  });

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
    final dangerColor = _getDangerColor(issue.tingkatBahaya);

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: isDark ? const Color(0xFF283A2C) : const Color(0xFFE2EBE2),
          width: 1.2,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(issueId: issue.idIssue),
            ),
          );
        },
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Badges & Bookmark Button
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Emoji / Icon with Hero transition
                  Hero(
                    tag: 'issue_icon_${issue.idIssue}',
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF243527)
                            : const Color(0xFFF0F5F0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        issue.iconSymbol,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Kategori Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: issue.kategori == 'Penyakit'
                          ? AppTheme.chiliRed.withValues(alpha: 0.12)
                          : AppTheme.warningOrange.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      issue.kategori,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: issue.kategori == 'Penyakit'
                            ? AppTheme.chiliRed
                            : AppTheme.warningOrange,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Bagian Terdampak Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF253729)
                          : const Color(0xFFE8F2E8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      issue.bagianTerdampak,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppTheme.lightGreen
                            : AppTheme.primaryGreen,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Bahaya Dot/Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: dangerColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: dangerColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          issue.tingkatBahaya,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: dangerColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Bookmark Quick Action
                  InkWell(
                    onTap: onToggleBookmark,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        isBookmarked
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        color: isBookmarked
                            ? AppTheme.chiliRed
                            : Colors.grey.shade400,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Nama Masalah
              Text(
                issue.namaMasalah,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1B3822),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              // Nama Latin
              Text(
                issue.namaLatin,
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              // Gejala Ringkas
              Text(
                issue.gejala,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.4,
                  color: isDark ? Colors.grey.shade300 : const Color(0xFF4A554A),
                ),
              ),
              const SizedBox(height: 12),
              // Bottom Action Row
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Lihat Solusi & Pencegahan',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppTheme.lightGreen
                          : AppTheme.primaryGreen,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 14,
                    color: isDark
                        ? AppTheme.lightGreen
                        : AppTheme.primaryGreen,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
