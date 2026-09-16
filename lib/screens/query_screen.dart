import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'analysis_screen.dart';

class QueryScreen extends StatefulWidget {
  final PlatformFile selectedFile;
  final Uint8List fileBytes;
  final String imageType;
  final double latitude;
  final double longitude;

  const QueryScreen({
    super.key,
    required this.selectedFile,
    required this.fileBytes,
    required this.imageType,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<QueryScreen> createState() => _QueryScreenState();
}

class _QueryScreenState extends State<QueryScreen> {
  static const Color navy = Color(0xFF071A35);
  static const Color blue = Color(0xFF2563EB);
  static const Color green = Color(0xFF10B981);
  static const Color background = Color(0xFFF5F7FA);
  static const Color border = Color(0xFFE5EAF0);

  final TextEditingController questionController =
      TextEditingController();

  String selectedMode = 'Visual Question Answering';

  final List<String> suggestedQuestions = [
    'What type of land cover is visible in this area?',
    'Is vegetation present in this region?',
    'Are there any buildings or roads visible?',
    'Describe the satellite image in detail.',
    'Are there signs of water bodies in this area?',
    'What major features can be identified?',
  ];

  @override
  void dispose() {
    questionController.dispose();
    super.dispose();
  }

  void useSuggestion(String question) {
    setState(() {
      questionController.text = question;
      questionController.selection =
          TextSelection.fromPosition(
        TextPosition(
          offset: question.length,
        ),
      );
    });
  }

  void startAnalysis() {
    final question = questionController.text.trim();

    if (question.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a question first.',
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AnalysisScreen(
          question: question,
          selectedFile: widget.selectedFile,
          fileBytes: widget.fileBytes,
          imageType: widget.imageType,
          latitude: widget.latitude,
          longitude: widget.longitude,
          analysisMode: selectedMode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Row(
          children: [
            _buildSidebar(context),
            Expanded(
              child: Column(
                children: [
                  _buildTopBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(26),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 22),
                          _buildSelectedData(),
                          const SizedBox(height: 20),
                          _buildQuestionBox(),
                          const SizedBox(height: 20),
                          _buildSuggestedQuestions(),
                          const SizedBox(height: 20),
                          _buildAnalysisMode(),
                          const SizedBox(height: 30),
                          _buildBottomButtons(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 220,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 18,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [blue, green],
                  ),
                  borderRadius:
                      BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.satellite_alt_rounded,
                  color: Colors.white,
                  size: 23,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SatQuery AI',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.w800,
                        color: navy,
                      ),
                    ),
                    Text(
                      'From Earth Data to Real Answers',
                      style: TextStyle(
                        fontSize: 7.5,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 35),
          _sideItem(
            Icons.home_rounded,
            'Home',
            false,
            () {
              Navigator.popUntil(
                context,
                (route) => route.isFirst,
              );
            },
          ),
          _sideItem(
            Icons.add_circle_outline_rounded,
            'New Analysis',
            false,
            () {},
          ),
          _sideItem(
            Icons.cloud_upload_outlined,
            'Upload Image',
            false,
            () {},
          ),
          _sideItem(
            Icons.map_outlined,
            'Explore Map',
            false,
            () {
              Navigator.pop(context);
            },
          ),
          _sideItem(
            Icons.chat_bubble_rounded,
            'Ask Question',
            true,
            () {},
          ),
          _sideItem(
            Icons.history_rounded,
            'History',
            false,
            () {},
          ),
          _sideItem(
            Icons.bookmark_border_rounded,
            'Saved Results',
            false,
            () {},
          ),
          _sideItem(
            Icons.settings_outlined,
            'Settings',
            false,
            () {},
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  navy,
                  Color(0xFF123B68),
                ],
              ),
              borderRadius:
                  BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  color: green,
                  size: 25,
                ),
                SizedBox(height: 14),
                Text(
                  'Ask your satellite\nimage anything.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    height: 1.5,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
                SizedBox(height: 14),
                Divider(
                  color: Colors.white24,
                ),
                SizedBox(height: 8),
                Text(
                  'AI-powered remote sensing',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sideItem(
    IconData icon,
    String title,
    bool selected,
    VoidCallback onTap,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 5),
      child: Material(
        color: selected
            ? navy
            : Colors.transparent,
        borderRadius:
            BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius:
              BorderRadius.circular(10),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 11,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 19,
                  color: selected
                      ? Colors.white
                      : navy,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: selected
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: selected
                        ? Colors.white
                        : navy,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 70,
      padding:
          const EdgeInsets.symmetric(
        horizontal: 26,
      ),
      decoration:
          const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: border,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 42,
              constraints:
                  const BoxConstraints(
                maxWidth: 520,
              ),
              decoration: BoxDecoration(
                color: background,
                borderRadius:
                    BorderRadius.circular(12),
                border: Border.all(
                  color: border,
                ),
              ),
              child: const TextField(
                decoration:
                    InputDecoration(
                  hintText:
                      'Search location, topic or analysis...',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 20,
                  ),
                  border:
                      InputBorder.none,
                ),
              ),
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.notifications_none_rounded,
            color: navy,
          ),
          const SizedBox(width: 18),
          Container(
            width: 38,
            height: 38,
            decoration:
                const BoxDecoration(
              color: navy,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'PL',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight:
                      FontWeight.bold,
                  fontSize: 12,
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
              fontWeight:
                  FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Ask SatQuery AI',
                style: TextStyle(
                  color: navy,
                  fontSize: 30,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
              SizedBox(height: 7),
              Text(
                'Ask questions about your satellite image using natural language.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F8F2),
            borderRadius:
                BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                color: green,
                size: 16,
              ),
              SizedBox(width: 7),
              Text(
                'AI READY',
                style: TextStyle(
                  color: Color(0xFF047857),
                  fontSize: 10,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedData() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(17),
        border: Border.all(
          color: border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(12),
              gradient:
                  const LinearGradient(
                colors: [
                  Color(0xFF2F704C),
                  Color(0xFF82A65B),
                ],
              ),
            ),
            child: const Icon(
              Icons.satellite_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Analysis Data',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.selectedFile.name,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.latitude.toStringAsFixed(5)}° N  •  ${widget.longitude.toStringAsFixed(5)}° E',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1FF),
              borderRadius:
                  BorderRadius.circular(9),
            ),
            child: Text(
              widget.imageType,
              style: const TextStyle(
                color: blue,
                fontSize: 10,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: blue.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.chat_bubble_outline_rounded,
                color: blue,
                size: 21,
              ),
              SizedBox(width: 9),
              Text(
                'What would you like to know?',
                style: TextStyle(
                  color: navy,
                  fontSize: 17,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              color: background,
              borderRadius:
                  BorderRadius.circular(13),
              border: Border.all(
                color: border,
              ),
            ),
            child: TextField(
              controller:
                  questionController,
              maxLines: 5,
              minLines: 4,
              maxLength: 500,
              style: const TextStyle(
                color: navy,
                fontSize: 13,
                height: 1.5,
              ),
              decoration:
                  const InputDecoration(
                hintText:
                    'Example: What type of vegetation is visible in this area?',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                border:
                    InputBorder.none,
                contentPadding:
                    EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedQuestions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(17),
        border: Border.all(
          color: border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Suggested Questions',
            style: TextStyle(
              color: navy,
              fontSize: 16,
              fontWeight:
                  FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Choose one or use your own question above.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children:
                suggestedQuestions.map(
              (question) {
                return InkWell(
                  onTap: () {
                    useSuggestion(
                      question,
                    );
                  },
                  borderRadius:
                      BorderRadius.circular(
                    10,
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration:
                        BoxDecoration(
                      color: const Color(
                        0xFFF7F9FC,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                      border: Border.all(
                        color: border,
                      ),
                    ),
                    child: Text(
                      question,
                      style:
                          const TextStyle(
                        color: navy,
                        fontSize: 10,
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisMode() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(17),
        border: Border.all(
          color: border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Analysis Mode',
            style: TextStyle(
              color: navy,
              fontSize: 16,
              fontWeight:
                  FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Choose how SatQuery AI should analyze your image.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _modeCard(
                  Icons.question_answer_outlined,
                  'Visual Question Answering',
                  'Ask questions about the image',
                  'Visual Question Answering',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _modeCard(
                  Icons.description_outlined,
                  'Scene Description',
                  'Generate image description',
                  'Scene Description',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _modeCard(
                  Icons.compare_arrows_rounded,
                  'Change Detection',
                  'Compare satellite images',
                  'Change Detection',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _modeCard(
    IconData icon,
    String title,
    String subtitle,
    String value,
  ) {
    final selected =
        selectedMode == value;

    return InkWell(
      onTap: () {
        setState(() {
          selectedMode = value;
        });
      },
      borderRadius:
          BorderRadius.circular(12),
      child: Container(
        padding:
            const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFF1F6FF)
              : Colors.white,
          borderRadius:
              BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? blue
                : border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color:
                  selected ? blue : navy,
              size: 21,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                        const TextStyle(
                      color: navy,
                      fontSize: 10,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style:
                        const TextStyle(
                      color: Colors.grey,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.check_circle
                  : Icons.circle_outlined,
              color:
                  selected ? blue : Colors.grey,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            size: 17,
          ),
          label: const Text('Back'),
        ),
        ElevatedButton.icon(
          onPressed: startAnalysis,
          icon: const Icon(
            Icons.auto_awesome_rounded,
            size: 18,
          ),
          label: const Text(
            'Start AI Analysis',
          ),
          style:
              ElevatedButton.styleFrom(
            backgroundColor: blue,
            foregroundColor:
                Colors.white,
            elevation: 0,
            padding:
                const EdgeInsets.symmetric(
              horizontal: 23,
              vertical: 14,
            ),
            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}