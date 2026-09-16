import 'package:flutter/material.dart';

import 'upload_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color navy = Color(0xFF071A35);
  static const Color blue = Color(0xFF2563EB);
  static const Color green = Color(0xFF10B981);
  static const Color background = Color(0xFFF5F7FA);
  static const Color border = Color(0xFFE5EAF0);

  void openUpload(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const UploadScreen()),
    );
  }

  void showComingSoon(BuildContext context, String name) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$name will be available soon.'),
          behavior: SnackBarBehavior.floating,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHero(context),
                          const SizedBox(height: 24),
                          _buildStats(),
                          const SizedBox(height: 30),
                          _buildSectionTitle(
                            'Quick Actions',
                            'Start your satellite analysis in seconds.',
                          ),
                          const SizedBox(height: 15),
                          _buildQuickActions(context),
                          const SizedBox(height: 30),
                          _buildSectionTitle(
                            'AI Capabilities',
                            'Powerful AI tools for remote sensing.',
                          ),
                          const SizedBox(height: 15),
                          _buildCapabilities(),
                          const SizedBox(height: 30),
                          _buildSampleAnalysis(),
                          const SizedBox(height: 30),
                          _buildRecentAnalyses(),
                          const SizedBox(height: 30),
                          _buildSustainabilityBanner(),
                          const SizedBox(height: 25),
                          _buildFooter(),
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

  // ============================================================
  // SIDEBAR
  // ============================================================

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 220,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      child: Column(
        children: [
          Row(
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
                  size: 23,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SatQuery AI',
                      style: TextStyle(
                        color: navy,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'From Earth Data to Real Answers',
                      style: TextStyle(color: Colors.grey, fontSize: 7.5),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 35),

          _sideItem(Icons.home_rounded, 'Home', true, () {}),

          _sideItem(
            Icons.add_circle_outline_rounded,
            'New Analysis',
            false,
            () => openUpload(context),
          ),

          _sideItem(
            Icons.cloud_upload_outlined,
            'Upload Image',
            false,
            () => openUpload(context),
          ),

          _sideItem(
            Icons.map_outlined,
            'Explore Map',
            false,
            () => openUpload(context),
          ),

          _sideItem(
            Icons.chat_bubble_outline_rounded,
            'Ask Question',
            false,
            () => openUpload(context),
          ),

          _sideItem(
            Icons.history_rounded,
            'History',
            false,
            () => showComingSoon(context, 'History'),
          ),

          _sideItem(
            Icons.bookmark_border_rounded,
            'Saved Results',
            false,
            () => showComingSoon(context, 'Saved Results'),
          ),

          _sideItem(
            Icons.settings_outlined,
            'Settings',
            false,
            () => showComingSoon(context, 'Settings'),
          ),

          const Spacer(),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [navy, Color(0xFF123B68)]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.public_rounded, color: green, size: 25),
                SizedBox(height: 13),
                Text(
                  '"A clearer planet\nfor a brighter\ntomorrow."',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    height: 1.45,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 13),
                Divider(color: Colors.white24),
                SizedBox(height: 7),
                Text(
                  'SatQuery AI',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(color: Colors.white38, fontSize: 9),
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
      margin: const EdgeInsets.only(bottom: 5),
      child: Material(
        color: selected ? navy : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            child: Row(
              children: [
                Icon(icon, size: 19, color: selected ? Colors.white : navy),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: selected ? Colors.white : navy,
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TOP BAR
  // ============================================================

  Widget _buildTopBar() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 26),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 42,
              constraints: const BoxConstraints(maxWidth: 520),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: border),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search location, topic or analysis...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                  prefixIcon: Icon(Icons.search_rounded, size: 20),
                  border: InputBorder.none,
                ),
              ),
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
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pranav Langade',
                style: TextStyle(
                  color: navy,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Student',
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          ),

          const SizedBox(width: 8),

          const Icon(Icons.keyboard_arrow_down_rounded, color: navy),
        ],
      ),
    );
  }

  // ============================================================
  // HERO
  // ============================================================

  Widget _buildHero(BuildContext context) {
    return Container(
      width: double.infinity,

      // Increased height to prevent overflow.
      height: 340,

      padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 30),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF071A35), Color(0xFF123B68)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),

      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome_rounded, color: green, size: 15),
                      SizedBox(width: 7),
                      Text(
                        'AI-POWERED REMOTE SENSING',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'See the Earth\nDifferently.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    height: 1.05,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 14),

                const Text(
                  'Ask questions. Understand satellite imagery.\n'
                  'Turn Earth observation data into real answers.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 22),

                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        openUpload(context);
                      },
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Start New Analysis'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: green,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 13,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    OutlinedButton.icon(
                      onPressed: () {
                        showComingSoon(context, 'Demo');
                      },
                      icon: const Icon(Icons.play_circle_outline, size: 18),
                      label: const Text('Watch Demo'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white38),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 13,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 20),

          Expanded(flex: 4, child: _buildEarthVisual()),
        ],
      ),
    );
  }

  Widget _buildEarthVisual() {
    return Center(
      child: SizedBox(
        width: 260,
        height: 260,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 245,
              height: 245,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0xFF16477B), Color(0xFF0A2748)],
                ),
              ),
            ),

            Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0xFF21734C), Color(0xFF0D4934)],
                ),
              ),
              child: const Icon(
                Icons.public_rounded,
                color: Colors.white,
                size: 125,
              ),
            ),

            Positioned(top: 5, right: 12, child: _orbitDot(green, 15)),

            Positioned(bottom: 25, left: 4, child: _orbitDot(Colors.white, 9)),

            Positioned(top: 65, left: 0, child: _orbitDot(blue, 10)),
          ],
        ),
      ),
    );
  }

  Widget _orbitDot(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 12),
        ],
      ),
    );
  }

  // ============================================================
  // STATS
  // ============================================================

  Widget _buildStats() {
    return Row(
      children: [
        Expanded(child: _statCard(Icons.psychology_rounded, '4+', 'AI Models')),
        const SizedBox(width: 14),
        Expanded(
          child: _statCard(Icons.analytics_outlined, '10+', 'Analysis Types'),
        ),
        const SizedBox(width: 14),
        Expanded(child: _statCard(Icons.public_rounded, 'Global', 'Coverage')),
        const SizedBox(width: 14),
        Expanded(
          child: _statCard(Icons.speed_rounded, '< 30s', 'Avg. Analysis'),
        ),
      ],
    );
  }

  Widget _statCard(IconData icon, String value, String title) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1FF),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: blue, size: 21),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: navy,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: navy,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 11),
        ),
      ],
    );
  }

  // ============================================================
  // QUICK ACTIONS
  // ============================================================

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _actionCard(
            context,
            Icons.cloud_upload_outlined,
            'Upload Image',
            'Upload satellite imagery',
            blue,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _actionCard(
            context,
            Icons.map_outlined,
            'Explore Map',
            'Select analysis location',
            green,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _actionCard(
            context,
            Icons.chat_bubble_outline_rounded,
            'Ask Question',
            'Ask AI about your image',
            const Color(0xFF8B5CF6),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _actionCard(
            context,
            Icons.compare_arrows_rounded,
            'Compare Images',
            'Detect changes over time',
            const Color(0xFFF59E0B),
          ),
        ),
      ],
    );
  }

  Widget _actionCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return InkWell(
      onTap: () {
        openUpload(context);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 155,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 13),
            Text(
              title,
              style: const TextStyle(
                color: navy,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  height: 1.4,
                ),
              ),
            ),
            const Row(
              children: [
                Text(
                  'Open',
                  style: TextStyle(
                    color: blue,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_rounded, color: blue, size: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // AI CAPABILITIES
  // ============================================================

  Widget _buildCapabilities() {
    return Row(
      children: [
        Expanded(
          child: _capabilityCard(
            Icons.question_answer_outlined,
            'Visual Question Answering',
            'Ask natural-language questions about satellite images.',
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _capabilityCard(
            Icons.description_outlined,
            'Scene Description',
            'Generate meaningful descriptions of observed areas.',
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _capabilityCard(
            Icons.my_location_rounded,
            'Visual Grounding',
            'Connect AI answers with specific image regions.',
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _capabilityCard(
            Icons.compare_arrows_rounded,
            'Change Detection',
            'Identify important changes between images.',
          ),
        ),
      ],
    );
  }

  Widget _capabilityCard(IconData icon, String title, String description) {
    return Container(
      height: 155,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1FF),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: blue, size: 21),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: navy,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 9.5,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SAMPLE ANALYSIS
  // ============================================================

  Widget _buildSampleAnalysis() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF153E2D),
                    Color(0xFF6B9B52),
                    Color(0xFFB7C879),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(
                      Icons.satellite_rounded,
                      color: Colors.white54,
                      size: 90,
                    ),
                  ),
                  Positioned(top: 18, left: 18, child: _imageLabel('SAMPLE')),
                  Positioned(
                    bottom: 18,
                    right: 18,
                    child: _imageLabel('SATELLITE IMAGE'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 25),

          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F8F2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'SAMPLE ANALYSIS',
                    style: TextStyle(
                      color: Color(0xFF047857),
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 13),

                const Text(
                  'Land Cover Analysis',
                  style: TextStyle(
                    color: navy,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'What type of land cover is visible in this area?',
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),

                const SizedBox(height: 16),

                const Text(
                  'AI Answer',
                  style: TextStyle(
                    color: navy,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 7),

                const Text(
                  'The selected region contains vegetation, open land and built-up areas. Vegetation appears to be one of the dominant features.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    _miniMetric('92%', 'Confidence'),
                    const SizedBox(width: 20),
                    _miniMetric('VLM', 'AI Model'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _miniMetric(String value, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: navy,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 9)),
      ],
    );
  }

  // ============================================================
  // RECENT ANALYSES
  // ============================================================

  Widget _buildRecentAnalyses() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Analyses',
                        style: TextStyle(
                          color: navy,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Your latest satellite analysis activity.',
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                    ],
                  ),
                ),
                TextButton(onPressed: () {}, child: const Text('View All')),
              ],
            ),
          ),

          const Divider(height: 1, color: border),

          _analysisRow(
            Icons.landscape_outlined,
            'Land Cover Analysis',
            'Pune, Maharashtra',
            '92%',
          ),

          _analysisRow(
            Icons.water_drop_outlined,
            'Water Body Detection',
            'Satara, Maharashtra',
            '89%',
          ),

          _analysisRow(
            Icons.compare_arrows_rounded,
            'Change Detection',
            'Nashik, Maharashtra',
            '94%',
          ),
        ],
      ),
    );
  }

  Widget _analysisRow(
    IconData icon,
    String title,
    String location,
    String confidence,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: border)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: blue, size: 20),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: const TextStyle(color: Colors.grey, fontSize: 9),
                ),
              ],
            ),
          ),

          Text(
            confidence,
            style: const TextStyle(
              color: navy,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(width: 18),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F8F2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text(
              'Completed',
              style: TextStyle(
                color: Color(0xFF047857),
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 10),

          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.grey,
            size: 13,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SUSTAINABILITY
  // ============================================================

  Widget _buildSustainabilityBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF063B2B), Color(0xFF0A6B4B)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.eco_rounded, color: green, size: 30),
          ),

          const SizedBox(width: 18),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Technology for a Better Planet',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Use Earth observation data to understand agriculture, forests, water resources, disasters and urban development.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.arrow_forward_rounded,
            color: Colors.white,
            size: 23,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FOOTER
  // ============================================================

  Widget _buildFooter() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '© 2026 SatQuery AI • OrbitIQ',
          style: TextStyle(color: Colors.grey, fontSize: 9),
        ),
        Text(
          'AI-powered Remote Sensing Platform',
          style: TextStyle(color: Colors.grey, fontSize: 9),
        ),
      ],
    );
  }
}
