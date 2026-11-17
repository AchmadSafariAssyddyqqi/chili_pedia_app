import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class DiagnosisFilter extends StatelessWidget {
  final String selectedPart;
  final String selectedCategory;
  final ValueChanged<String> onPartSelected;
  final ValueChanged<String> onCategorySelected;

  const DiagnosisFilter({
    super.key,
    required this.selectedPart,
    required this.selectedCategory,
    required this.onPartSelected,
    required this.onCategorySelected,
  });

  static const List<Map<String, dynamic>> plantParts = [
    {'name': 'Semua', 'icon': Icons.all_inclusive_rounded},
    {'name': 'Daun', 'icon': Icons.energy_savings_leaf_rounded},
    {'name': 'Buah', 'icon': Icons.circle_rounded},
    {'name': 'Batang', 'icon': Icons.line_weight_rounded},
    {'name': 'Akar', 'icon': Icons.grass_rounded},
  ];

  static const List<String> categories = ['Semua', 'Penyakit', 'Hama'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Title Menu Diagnosa
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Bagian Terdampak',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1B3822),
              ),
            ),
            // Kategori Switcher Mini Chips
            Row(
              children: categories.map((cat) {
                final isCatSelected = selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: GestureDetector(
                    onTap: () => onCategorySelected(cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isCatSelected
                            ? (cat == 'Hama'
                                ? AppTheme.warningOrange
                                : (cat == 'Penyakit'
                                    ? AppTheme.chiliRed
                                    : AppTheme.primaryGreen))
                            : (isDark
                                ? const Color(0xFF222F26)
                                : const Color(0xFFE8EFE8)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isCatSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isCatSelected
                              ? Colors.white
                              : (isDark
                                  ? Colors.grey.shade300
                                  : Colors.grey.shade700),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Horizontal Plant Part Icons / Chips
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: plantParts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final item = plantParts[index];
              final name = item['name'] as String;
              final icon = item['icon'] as IconData;
              final isSelected = selectedPart == name;

              return InkWell(
                onTap: () => onPartSelected(name),
                borderRadius: BorderRadius.circular(14),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark
                            ? AppTheme.lightGreen
                            : AppTheme.primaryGreen)
                        : (isDark
                            ? const Color(0xFF1A261D)
                            : Colors.white),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? (isDark
                              ? AppTheme.lightGreen
                              : AppTheme.primaryGreen)
                          : (isDark
                              ? const Color(0xFF2C3E31)
                              : const Color(0xFFE2EBE2)),
                      width: 1.2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppTheme.primaryGreen.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        icon,
                        size: 16,
                        color: isSelected
                            ? (isDark ? Colors.black : Colors.white)
                            : (isDark
                                ? AppTheme.lightGreen
                                : AppTheme.primaryGreen),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w600,
                          color: isSelected
                              ? (isDark ? Colors.black : Colors.white)
                              : (isDark
                                  ? Colors.grey.shade300
                                  : const Color(0xFF2C3E31)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
