import '../models/analysis_result.dart';

class MockApiService {
  Future<AnalysisResult> analyze({required String question}) async {
    // Simulate backend processing
    await Future.delayed(const Duration(seconds: 2));

    return AnalysisResult(
      question: question,
      answer:
          'The satellite image shows a mixed landscape with visible vegetation, built-up areas and open land. Vegetation appears to be one of the dominant features in the selected region.',
      confidence: 0.92,
      model: 'SatQuery-VLM',
      analysisType: 'Remote Sensing VQA',
      evidence: [
        'Vegetation detected',
        'Built-up area detected',
        'Open land detected',
        'Satellite image successfully analyzed',
      ],
    );
  }
}
