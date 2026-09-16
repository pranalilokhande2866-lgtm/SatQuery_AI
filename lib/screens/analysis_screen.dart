import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../models/analysis_result.dart';
import '../services/mock_api_service.dart';
import '../widgets/analysis_step.dart';
import 'result_screen.dart';

class AnalysisScreen extends StatefulWidget {
  final String question;
  final PlatformFile selectedFile;
  final Uint8List fileBytes;
  final String imageType;
  final double latitude;
  final double longitude;
  final String analysisMode;

  const AnalysisScreen({
    super.key,
    required this.question,
    required this.selectedFile,
    required this.fileBytes,
    required this.imageType,
    required this.latitude,
    required this.longitude,
    required this.analysisMode,
  });

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen>
    with SingleTickerProviderStateMixin {
  static const Color navy = Color(0xFF071A35);
  static const Color blue = Color(0xFF2563EB);
  static const Color green = Color(0xFF10B981);
  static const Color background = Color(0xFFF5F7FA);

  final MockApiService apiService = MockApiService();

  late AnimationController animationController;

  int currentStep = 0;
  bool completed = false;

  final List<String> steps = [
    'Preparing satellite image',
    'Processing image data',
    'Running AI vision model',
    'Analyzing geospatial information',
    'Generating final answer',
  ];

  final List<String> descriptions = [
    'Validating image and analysis parameters',
    'Extracting useful visual information',
    'Understanding the satellite image',
    'Connecting image with selected location',
    'Preparing the final AI response',
  ];

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _startAnalysis();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<void> _startAnalysis() async {
    for (int i = 0; i < steps.length; i++) {
      if (!mounted) return;

      setState(() {
        currentStep = i;
      });

      await Future.delayed(const Duration(milliseconds: 700));
    }

    final AnalysisResult result = await apiService.analyze(
      question: widget.question,
    );

    if (!mounted) return;

    setState(() {
      completed = true;
    });

    animationController.stop();

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          result: result,
          selectedFile: widget.selectedFile,
          fileBytes: widget.fileBytes,
          imageType: widget.imageType,
          latitude: widget.latitude,
          longitude: widget.longitude,
          analysisMode: widget.analysisMode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double progress = completed ? 1.0 : (currentStep + 1) / steps.length;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                children: [
                  _buildLogo(),
                  const SizedBox(height: 25),
                  _buildHeader(),
                  const SizedBox(height: 25),
                  _buildQuestionCard(),
                  const SizedBox(height: 20),
                  _buildProgress(progress),
                  const SizedBox(height: 20),
                  _buildSteps(),
                  const SizedBox(height: 20),
                  _buildAgentCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [blue, green]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.satellite_alt_rounded,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          'AI Analysis in Progress',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: navy,
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          completed
              ? 'Analysis completed successfully.'
              : 'SatQuery AI is analyzing your satellite image.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildQuestionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: blue),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Question',
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.question,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress(double progress) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Analysis Progress',
                style: TextStyle(
                  color: navy,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  color: blue,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSteps() {
    return Column(
      children: List.generate(steps.length, (index) {
        final bool isCompleted = completed || index < currentStep;

        final bool isCurrent = !completed && index == currentStep;

        return AnalysisStep(
          title: steps[index],
          description: descriptions[index],
          isCompleted: isCompleted,
          isCurrent: isCurrent,
        );
      }),
    );
  }

  Widget _buildAgentCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [navy, Color(0xFF123B68)]),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: animationController.value * 6.28,
                child: child,
              );
            },
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.psychology_rounded,
                color: green,
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SatQuery AI Agent',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Vision model + geospatial reasoning + natural language generation',
                  style: TextStyle(color: Colors.white60, fontSize: 10),
                ),
              ],
            ),
          ),
          const Icon(Icons.cloud_done_rounded, color: green, size: 25),
        ],
      ),
    );
  }
}
