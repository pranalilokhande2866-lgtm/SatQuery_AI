class AnalysisResult {
  final String question;
  final String answer;
  final double confidence;
  final String model;
  final String analysisType;
  final List<String> evidence;

  const AnalysisResult({
    required this.question,
    required this.answer,
    required this.confidence,
    required this.model,
    required this.analysisType,
    required this.evidence,
  });
}
