import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../models/analysis_result.dart';

class ResultScreen extends StatelessWidget {
  final AnalysisResult result;
  final PlatformFile selectedFile;
  final Uint8List fileBytes;
  final String imageType;
  final double latitude;
  final double longitude;
  final String analysisMode;

  const ResultScreen({
    super.key,
    required this.result,
    required this.selectedFile,
    required this.fileBytes,
    required this.imageType,
    required this.latitude,
    required this.longitude,
    required this.analysisMode,
  });

  static const Color navy = Color(0xFF071A35);
  static const Color blue = Color(0xFF2563EB);
  static const Color green = Color(0xFF10B981);
  static const Color background = Color(0xFFF5F7FA);
  static const Color border = Color(0xFFE5EAF0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 22),
                    _buildMainResult(),
                    const SizedBox(height: 20),
                    _buildInformationRow(),
                    const SizedBox(height: 20),
                    _buildEvidence(),
                    const SizedBox(height: 20),
                    _buildExecutionInfo(),
                    const SizedBox(height: 30),
                    _buildBottomButtons(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 26),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: border)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [blue, green]),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.satellite_alt_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'SatQuery AI',
            style: TextStyle(
              color: navy,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          const Icon(Icons.notifications_none_rounded, color: navy),
          const SizedBox(width: 18),
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: navy,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'PL',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'Pranav Langade',
            style: TextStyle(
              color: navy,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Analysis Result',
                style: TextStyle(
                  color: navy,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'AI-generated insights from your satellite image.',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F8F2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: green, size: 16),
              SizedBox(width: 6),
              Text(
                'ANALYSIS COMPLETE',
                style: TextStyle(
                  color: Color(0xFF047857),
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainResult() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: _buildImageCard()),
        const SizedBox(width: 20),
        Expanded(flex: 5, child: _buildAnswerCard()),
      ],
    );
  }

  Widget _buildImageCard() {
    final String? extension = selectedFile.extension?.toLowerCase();

    final bool canPreview =
        extension == 'png' || extension == 'jpg' || extension == 'jpeg';

    return Container(
      height: 330,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Analyzed Image',
            style: TextStyle(
              color: navy,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(13),
              ),
              child: canPreview
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Image.memory(fileBytes, fit: BoxFit.cover),
                    )
                  : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.map_rounded, color: blue, size: 60),
                          SizedBox(height: 10),
                          Text(
                            'GeoTIFF Image',
                            style: TextStyle(
                              color: navy,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Processed by AI pipeline',
                            style: TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            selectedFile.name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: navy,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerCard() {
    final int confidence = (result.confidence * 100).round();

    return Container(
      height: 330,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F8F2),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(Icons.auto_awesome_rounded, color: green),
              ),
              const SizedBox(width: 11),
              const Text(
                'AI Answer',
                style: TextStyle(
                  color: navy,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          const Text(
            'QUESTION',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            result.question,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: navy,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'ANSWER',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Expanded(
            child: SingleChildScrollView(
              child: Text(
                result.answer,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  height: 1.6,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.verified_rounded, color: green, size: 17),
              const SizedBox(width: 6),
              Text(
                '$confidence% Confidence',
                style: const TextStyle(
                  color: Color(0xFF047857),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInformationRow() {
    return Row(
      children: [
        Expanded(
          child: _infoCard(
            Icons.location_on_outlined,
            'Location',
            '${latitude.toStringAsFixed(5)}° N\n${longitude.toStringAsFixed(5)}° E',
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _infoCard(Icons.image_outlined, 'Image Type', imageType),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _infoCard(Icons.psychology_outlined, 'AI Model', result.model),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _infoCard(
            Icons.analytics_outlined,
            'Analysis Mode',
            analysisMode,
          ),
        ),
      ],
    );
  }

  Widget _infoCard(IconData icon, String title, String value) {
    return Container(
      height: 105,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Icon(icon, color: blue, size: 22),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.grey, fontSize: 9),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvidence() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detected Evidence',
            style: TextStyle(
              color: navy,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Visual features identified during analysis.',
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
          const SizedBox(height: 17),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: result.evidence.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F8F2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: green,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item,
                      style: const TextStyle(
                        color: Color(0xFF047857),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildExecutionInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [navy, Color(0xFF123B68)]),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.memory_rounded, color: green, size: 28),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SatQuery AI Processing',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Image processing → AI vision → geospatial reasoning → natural language response',
                  style: TextStyle(color: Colors.white60, fontSize: 10),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle_rounded, color: green, size: 24),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton.icon(
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          icon: const Icon(Icons.home_outlined),
          label: const Text('Back to Home'),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          icon: const Icon(Icons.add_rounded),
          label: const Text('New Analysis'),
          style: ElevatedButton.styleFrom(
            backgroundColor: blue,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          ),
        ),
      ],
    );
  }
}
