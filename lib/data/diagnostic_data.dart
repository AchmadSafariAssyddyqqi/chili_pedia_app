import '../models/diagnostic_model.dart';

const List<SymptomOption> allSymptomsList = [
  // DAUN
  SymptomOption(
    id: 'sym_daun_kuning_keriting',
    label: 'Daun menguning cerah & keriting ke atas',
    plantPart: 'Daun',
    description: 'Tulang daun menebal, buku batang memendek, tanaman jadi kerdil.',
    targetIssueId: 'PENY-01', // Virus Gemini
    weight: 45,
  ),
  SymptomOption(
    id: 'sym_daun_mangkuk_perak',
    label: 'Daun melengkung ke atas & mengilap seperti perak',
    plantPart: 'Daun',
    description: 'Permukaan bawah daun keperakan bekas hisapan hama, pucuk daun kaku.',
    targetIssueId: 'HAMA-01', // Thrips
    weight: 45,
  ),
  SymptomOption(
    id: 'sym_daun_sendok_tembaga',
    label: 'Daun melengkung ke bawah & kaku cokelat tembaga',
    plantPart: 'Daun',
    description: 'Seperti sendok telungkup, daun menebal dan kaku di musim kemarau panas.',
    targetIssueId: 'HAMA-03', // Tungau
    weight: 45,
  ),
  SymptomOption(
    id: 'sym_daun_mata_katak',
    label: 'Bercak bulat abu-abu dengan tepi cokelat tua',
    plantPart: 'Daun',
    description: 'Menyerupai mata katak, daun menguning lalu rontok parah saat musim hujan.',
    targetIssueId: 'PENY-05', // Cercospora
    weight: 45,
  ),
  SymptomOption(
    id: 'sym_daun_berlubang',
    label: 'Daun berlubang-lubang dan tinggal kerangka tulang',
    plantPart: 'Daun',
    description: 'Ada bekas gigitan ulat di malam hari atau kotoran hitam ulat.',
    targetIssueId: 'HAMA-05', // Ulat Grayak
    weight: 45,
  ),
  SymptomOption(
    id: 'sym_daun_kutu_putih',
    label: 'Banyak serangga putih kecil berterbangan',
    plantPart: 'Daun',
    description: 'Terbang seperti debu saat tanaman digoyang, daun tampak berjelaga hitam.',
    targetIssueId: 'HAMA-04', // Kutu Kebul
    weight: 45,
  ),

  // BUAH
  SymptomOption(
    id: 'sym_buah_patek_cekung',
    label: 'Bercak hitam melekuk melingkar (cekung ke dalam)',
    plantPart: 'Buah',
    description: 'Ada massa spora oranye/kuning di tengah bercak, buah busuk mengerut kering.',
    targetIssueId: 'PENY-02', // Antraknosa
    weight: 50,
  ),
  SymptomOption(
    id: 'sym_buah_belatung',
    label: 'Titik hitam kecil di kulit & ada belatung di dalam',
    plantPart: 'Buah',
    description: 'Buah cabai busuk berair dari dalam dan rontok sebelum matang sempurna.',
    targetIssueId: 'HAMA-02', // Lalat Buah
    weight: 50,
  ),
  SymptomOption(
    id: 'sym_buah_busuk_basah',
    label: 'Buah lembek basah seperti tersiram air mendidih',
    plantPart: 'Buah',
    description: 'Muncul jamur lapisan miselium putih tipis saat curah hujan tinggi lembap.',
    targetIssueId: 'PENY-06', // Phytophthora
    weight: 50,
  ),

  // BATANG & AKAR
  SymptomOption(
    id: 'sym_layu_mendadak_hijau',
    label: 'Layu mendadak di siang terik, daun tetap hijau',
    plantPart: 'Batang',
    description: 'Segar di pagi hari tapi layu di siang terik, batang berlendir jika dicelup air.',
    targetIssueId: 'PENY-03', // Layu Bakteri
    weight: 50,
  ),
  SymptomOption(
    id: 'sym_layu_kuning_merambat',
    label: 'Daun bawah menguning perlahan merambat ke atas',
    plantPart: 'Akar',
    description: 'Tanaman perlahan layu mati, pembuluh batang cokelat tua, akar busuk.',
    targetIssueId: 'PENY-04', // Layu Fusarium
    weight: 50,
  ),
  SymptomOption(
    id: 'sym_rebah_semai',
    label: 'Batang bibit di persemaian melunak lalu roboh',
    plantPart: 'Batang',
    description: 'Pangkal batang mengecil dan busuk pada tanaman muda di polybag/bedeng semai.',
    targetIssueId: 'PENY-07', // Rebah Semai
    weight: 50,
  ),
];

class DiagnosticEngine {
  static List<DiagnosticResult> runInference({
    required String selectedPart,
    required List<String> selectedSymptomIds,
    required String weatherCondition, // 'Hujan / Lembap', 'Kemarau / Panas', 'Normal'
  }) {
    final Map<String, int> scores = {};
    final Map<String, List<String>> matchedLabels = {};

    for (final symId in selectedSymptomIds) {
      final symptom = allSymptomsList.firstWhere(
        (s) => s.id == symId,
        orElse: () => allSymptomsList.first,
      );

      scores[symptom.targetIssueId] =
          (scores[symptom.targetIssueId] ?? 0) + symptom.weight;
      matchedLabels.putIfAbsent(symptom.targetIssueId, () => []);
      matchedLabels[symptom.targetIssueId]!.add(symptom.label);
    }

    // Korelasi Cuaca (Faktor Penguat)
    if (weatherCondition == 'Hujan / Lembap') {
      // Jamur & Bakteri lebih agresif di musim hujan
      for (final id in ['PENY-02', 'PENY-03', 'PENY-05', 'PENY-06']) {
        if (scores.containsKey(id)) {
          scores[id] = (scores[id] ?? 0) + 15;
        }
      }
    } else if (weatherCondition == 'Kemarau / Panas') {
      // Serangga vektor & tungau/thrips meledak di cuaca panas kering
      for (final id in ['HAMA-01', 'HAMA-03', 'HAMA-04', 'PENY-01']) {
        if (scores.containsKey(id)) {
          scores[id] = (scores[id] ?? 0) + 15;
        }
      }
    }

    final List<DiagnosticResult> results = [];
    scores.forEach((issueId, rawScore) {
      // Normalisasi skor ke persen (Max 98% realistis sistem pakar)
      final double percentage = (rawScore.clamp(20, 100)).toDouble();
      String level = 'Perlu Pemeriksaan';
      if (percentage >= 80) {
        level = 'Kecocokan Sangat Tinggi';
      } else if (percentage >= 50) {
        level = 'Kemungkinan Besar';
      }

      results.add(
        DiagnosticResult(
          issueId: issueId,
          confidencePercentage: percentage,
          matchingLevel: level,
          matchedSymptoms: matchedLabels[issueId] ?? [],
        ),
      );
    });

    results.sort((a, b) => b.confidencePercentage.compareTo(a.confidencePercentage));
    return results;
  }
}
