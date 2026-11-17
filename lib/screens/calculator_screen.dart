import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _landAreaController =
      TextEditingController(text: '500');
  final TextEditingController _dosageController =
      TextEditingController(text: '1.5');

  int _selectedTankCapacity = 16; // 14, 16, 20 Liter
  String _dosageUnit = 'ml/Liter'; // 'ml/Liter' (cair) atau 'gr/Liter' (bubuk)

  double _dosePerTank = 24.0;
  double _totalWaterLiters = 20.0;
  int _estimatedTanks = 2;
  double _totalChemicalNeeded = 30.0;

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  @override
  void dispose() {
    _landAreaController.dispose();
    _dosageController.dispose();
    super.dispose();
  }

  void _calculate() {
    final double area = double.tryParse(_landAreaController.text.replaceAll(',', '.')) ?? 0;
    final double dosage = double.tryParse(_dosageController.text.replaceAll(',', '.')) ?? 0;

    // Takaran per tangki
    final double perTank = _selectedTankCapacity * dosage;

    // Volume air standar cabai: ~400 L / 10.000 m² = 0.04 Liter air per m²
    final double waterNeeded = (area * 0.04).clamp(5.0, 5000.0);
    final int tanks = (waterNeeded / _selectedTankCapacity).ceil().clamp(1, 100);
    final double totalChemical = waterNeeded * dosage;

    setState(() {
      _dosePerTank = perTank;
      _totalWaterLiters = waterNeeded;
      _estimatedTanks = tanks;
      _totalChemicalNeeded = totalChemical;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kalkulator Tangki Semprot',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF1B3621), const Color(0xFF132216)]
                      : [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)],
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark ? const Color(0xFF283B2C) : const Color(0xFFA5D6A7),
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
                    child: const Text('🧪', style: TextStyle(fontSize: 26)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Akurasi Dosis Semprotan Cabai',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF1B5E20),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Hindari keracunan daun (overdosis) atau hama kebal (underdosis).',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Form Inputs
            Text(
              'Parameter Kebun & Tangki',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1B3822),
              ),
            ),
            const SizedBox(height: 14),

            // Kapasitas Tangki Sprayer
            Text(
              'Kapasitas Tangki Sprayer',
              style: TextStyle(fontSize: 13, color: isDark ? Colors.grey.shade300 : Colors.grey.shade700),
            ),
            const SizedBox(height: 8),
            Row(
              children: [14, 16, 20].map((cap) {
                final isSelected = _selectedTankCapacity == cap;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _selectedTankCapacity = cap);
                        _calculate();
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark ? AppTheme.lightGreen : AppTheme.primaryGreen)
                              : (isDark ? const Color(0xFF1E2B22) : Colors.white),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? (isDark ? AppTheme.lightGreen : AppTheme.primaryGreen)
                                : (isDark ? const Color(0xFF283A2C) : const Color(0xFFD0DCD0)),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$cap Liter',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? (isDark ? Colors.black : Colors.white)
                                : (isDark ? Colors.grey.shade300 : const Color(0xFF2C3E31)),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),

            // Dosis Anjuran Label
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dosis Anjuran Botol',
                        style: TextStyle(fontSize: 13, color: isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _dosageController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (_) => _calculate(),
                        decoration: const InputDecoration(
                          hintText: 'Misal: 1.5 atau 2.0',
                          prefixIcon: Icon(Icons.colorize_rounded),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Satuan',
                        style: TextStyle(fontSize: 13, color: isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 52,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E2B22) : const Color(0xFFF1F5F1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark ? const Color(0xFF283A2C) : const Color(0xFFD0DCD0),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _dosageUnit,
                            isExpanded: true,
                            items: const [
                              DropdownMenuItem(value: 'ml/Liter', child: Text('ml/L (Cair)')),
                              DropdownMenuItem(value: 'gr/Liter', child: Text('gr/L (Bubuk)')),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _dosageUnit = val);
                                _calculate();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Luas Lahan (m²)
            Text(
              'Luas Lahan Cabai (m²)',
              style: TextStyle(fontSize: 13, color: isDark ? Colors.grey.shade300 : Colors.grey.shade700),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _landAreaController,
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
              decoration: const InputDecoration(
                hintText: 'Misal: 500 atau 1000',
                prefixIcon: Icon(Icons.crop_landscape_rounded),
                suffixText: 'm²',
              ),
            ),
            const SizedBox(height: 24),

            // HASIL KALKULASI DISPLAY
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF19271E) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppTheme.lightGreen : AppTheme.primaryGreen,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'HASIL TAKARAN REKOMENDASI',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: isDark ? AppTheme.lightGreen : AppTheme.primaryGreen,
                        ),
                      ),
                      const Icon(Icons.check_circle_rounded, color: AppTheme.primaryGreen, size: 20),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Takaran per Tangki Highlight
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF223526) : const Color(0xFFEAF5EA),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Takaran Per 1 Tangki ($_selectedTankCapacity L):',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey.shade300 : const Color(0xFF1B5E20),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_dosePerTank.toStringAsFixed(1)} ${_dosageUnit.split('/').first}',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppTheme.lightGreen : AppTheme.primaryGreen,
                          ),
                        ),
                        Text(
                          '(Setara ~${(_dosePerTank / 15.0).toStringAsFixed(1)} tutup botol sprayer atau sendok makan)',
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildResultRow(
                    'Kebutuhan Air Seluruh Lahan',
                    '~${_totalWaterLiters.toStringAsFixed(0)} Liter Air',
                    Icons.water_drop_outlined,
                  ),
                  const Divider(height: 16),
                  _buildResultRow(
                    'Estimasi Jumlah Tangki',
                    '$_estimatedTanks Tangki Sprayer',
                    Icons.inventory_2_outlined,
                  ),
                  const Divider(height: 16),
                  _buildResultRow(
                    'Total Kebutuhan Obat',
                    '${_totalChemicalNeeded.toStringAsFixed(1)} ${_dosageUnit.split('/').first}',
                    Icons.science_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // SOP Waktu Semprot Petani
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF19251D) : const Color(0xFFFFF9E6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? const Color(0xFF333E33) : const Color(0xFFFFE082),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.access_time_filled_rounded, color: AppTheme.warningOrange, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Waktu Aplikasi Terbaik:',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Pagi: Jam 06.00 - 09.00 (saat stomata daun terbuka sempurna)\n• Sore: Jam 15.30 - 17.30 (matahari tidak terlalu terik, obat tidak menguap)',
                    style: TextStyle(fontSize: 12, height: 1.4, color: isDark ? Colors.grey.shade300 : const Color(0xFF4A4010)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.primaryGreen),
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
