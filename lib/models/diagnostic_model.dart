class SymptomOption {
  final String id;
  final String label;
  final String plantPart; // 'Daun', 'Buah', 'Batang', 'Akar'
  final String description;
  final String targetIssueId;
  final int weight;

  const SymptomOption({
    required this.id,
    required this.label,
    required this.plantPart,
    required this.description,
    required this.targetIssueId,
    this.weight = 35,
  });
}

class DiagnosticResult {
  final String issueId;
  final double confidencePercentage;
  final String matchingLevel; // 'Sangat Cocok', 'Kemungkinan Besar', 'Perlu Pemeriksaan'
  final List<String> matchedSymptoms;

  const DiagnosticResult({
    required this.issueId,
    required this.confidencePercentage,
    required this.matchingLevel,
    required this.matchedSymptoms,
  });
}
