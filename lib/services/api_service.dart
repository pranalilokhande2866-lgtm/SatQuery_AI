import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import '../models/analysis_result.dart';

class ApiService {
  // ============================================================
  // BACKEND URL
  // ============================================================

  static const String baseUrl = 'http://127.0.0.1:8000';

  // ============================================================
  // ANALYZE IMAGE
  // ============================================================

  Future<AnalysisResult> analyze({
    required PlatformFile selectedFile,
    required Uint8List fileBytes,
    required String question,
    required String imageType,
    required double latitude,
    required double longitude,
    required String analysisMode,
  }) async {
    final uri = Uri.parse('$baseUrl/analyze');

    try {
      final request = http.MultipartRequest('POST', uri);

      // --------------------------------------------------------
      // IMAGE
      // --------------------------------------------------------

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: selectedFile.name,
        ),
      );

      // --------------------------------------------------------
      // FORM DATA
      // --------------------------------------------------------

      request.fields['question'] = question;

      request.fields['image_type'] = imageType;

      request.fields['latitude'] = latitude.toString();

      request.fields['longitude'] = longitude.toString();

      request.fields['analysis_mode'] = analysisMode;

      // --------------------------------------------------------
      // SEND REQUEST
      // --------------------------------------------------------

      final streamedResponse = await request.send();

      final response = await http.Response.fromStream(streamedResponse);

      // --------------------------------------------------------
      // SUCCESS
      // --------------------------------------------------------

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> data =
            jsonDecode(response.body) as Map<String, dynamic>;

        return _parseResult(data);
      }

      // --------------------------------------------------------
      // SERVER ERROR
      // --------------------------------------------------------

      throw Exception(
        'Backend error: '
        '${response.statusCode}\n'
        '${response.body}',
      );
    } catch (e) {
      throw Exception('Unable to connect to backend: $e');
    }
  }

  // ============================================================
  // PARSE BACKEND RESPONSE
  // ============================================================

  AnalysisResult _parseResult(Map<String, dynamic> data) {
    final dynamic evidenceData = data['evidence'];

    List<String> evidence = [];

    if (evidenceData is List) {
      evidence = evidenceData.map((item) => item.toString()).toList();
    }

    return AnalysisResult(
      question: data['question']?.toString() ?? '',

      answer: data['answer']?.toString() ?? 'No answer received.',

      confidence: _parseConfidence(data['confidence']),

      model: data['model']?.toString() ?? 'SatQuery-VLM',

      analysisType: data['analysis_type']?.toString() ?? 'Remote Sensing VQA',

      evidence: evidence,
    );
  }

  // ============================================================
  // CONFIDENCE PARSER
  // ============================================================

  double _parseConfidence(dynamic value) {
    if (value is num) {
      final double confidence = value.toDouble();

      // Backend may send:
      // 0.92 OR 92

      if (confidence > 1) {
        return confidence / 100;
      }

      return confidence;
    }

    if (value is String) {
      final double? parsed = double.tryParse(value);

      if (parsed == null) {
        return 0.0;
      }

      if (parsed > 1) {
        return parsed / 100;
      }

      return parsed;
    }

    return 0.0;
  }

  // ============================================================
  // HEALTH CHECK
  // ============================================================

  Future<bool> checkBackend() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));

      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (_) {
      return false;
    }
  }
}
