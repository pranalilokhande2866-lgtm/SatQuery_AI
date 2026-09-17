import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'map_screen.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  static const Color navy = Color(0xFF071A35);
  static const Color blue = Color(0xFF2563EB);
  static const Color green = Color(0xFF10B981);
  static const Color background = Color(0xFFF5F7FA);
  static const Color border = Color(0xFFE5EAF0);

  PlatformFile? selectedFile;
  Uint8List? fileBytes;

  String imageType = 'Optical (RGB)';

  Future<void> chooseFile() async {
    try {
      final PlatformFile? file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['tif', 'tiff', 'png', 'jpg', 'jpeg'],
      );

      if (file == null) {
        return;
      }

      final Uint8List bytes = await file.readAsBytes();

      setState(() {
        selectedFile = file;
        fileBytes = bytes;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to select file: $e')));
    }
  }

  bool get isImagePreviewAvailable {
    if (selectedFile == null || fileBytes == null) {
      return false;
    }

    final extension = selectedFile!.extension?.toLowerCase();

    return extension == 'png' || extension == 'jpg' || extension == 'jpeg';
  }

  bool get isGeoTiff {
    final extension = selectedFile?.extension?.toLowerCase();

    return extension == 'tif' || extension == 'tiff';
  }

  String get fileSizeText {
    if (selectedFile == null) {
      return '--';
    }

    // file_picker 12.x मध्ये size property नाही.
    // lengthSync() वापरतो.
    final int size = selectedFile!.lengthSync() ?? fileBytes?.length ?? 0;

    if (size < 1024) {
      return '$size B';
    }

    if (size < 1024 * 1024) {
      return '${(size / 1024).toStringAsFixed(1)} KB';
    }

    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  void continueToLocation() {
    if (selectedFile == null || fileBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a satellite image first.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapScreen(
          selectedFile: selectedFile!,
          fileBytes: fileBytes!,
          imageType: imageType,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPageHeader(),

                          const SizedBox(height: 24),

                          _buildUploadSection(),

                          const SizedBox(height: 20),

                          _buildImageInformation(),

                          const SizedBox(height: 20),

                          _buildGeoTiffInfo(),

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
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: navy,
                      ),
                    ),
                    Text(
                      'From Earth Data to Real Answers',
                      style: TextStyle(fontSize: 7.5, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 35),

          _sideItem(Icons.home_rounded, 'Home', false, () {
            Navigator.popUntil(context, (route) => route.isFirst);
          }),

          _sideItem(
            Icons.add_circle_outline_rounded,
            'New Analysis',
            true,
            () {},
          ),

          _sideItem(Icons.history_rounded, 'History', false, () {}),

          _sideItem(
            Icons.bookmark_border_rounded,
            'Saved Results',
            false,
            () {},
          ),

          _sideItem(Icons.dataset_outlined, 'Datasets', false, () {}),

          _sideItem(Icons.settings_outlined, 'Settings', false, () {}),

          const Spacer(),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [navy, Color(0xFF123B68)]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.public_rounded, color: green, size: 25),
                SizedBox(height: 14),
                Text(
                  '"A clearer planet\nfor a brighter\ntomorrow."',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 14),
                Divider(color: Colors.white24),
                SizedBox(height: 8),
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
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? Colors.white : navy,
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
                  hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                  prefixIcon: Icon(Icons.search_rounded, size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 11),
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
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              Text(
                'Student',
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload Satellite Image',
          style: TextStyle(
            color: navy,
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 7),
        Text(
          'Upload your satellite imagery to start an AI-powered analysis.',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          'Supported: GeoTIFF, TIFF, PNG, JPG, JPEG',
          style: TextStyle(color: Colors.grey, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildUploadSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 6, child: _buildDropZone()),
        const SizedBox(width: 20),
        Expanded(flex: 4, child: _buildPreviewCard()),
      ],
    );
  }

  Widget _buildDropZone() {
    return Container(
      height: 290,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: blue.withValues(alpha: 0.35),
          radius: 18,
        ),
        child: InkWell(
          onTap: chooseFile,
          borderRadius: BorderRadius.circular(18),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF1FF),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.cloud_upload_outlined,
                    color: blue,
                    size: 35,
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  'Upload your satellite image',
                  style: TextStyle(
                    color: navy,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 7),

                const Text(
                  'Select a satellite image from your computer',
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),

                const SizedBox(height: 15),

                ElevatedButton.icon(
                  onPressed: chooseFile,
                  icon: const Icon(Icons.folder_open_rounded, size: 17),
                  label: const Text('Choose File'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'GeoTIFF • TIFF • PNG • JPG • JPEG',
                  style: TextStyle(color: Colors.grey, fontSize: 9),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewCard() {
    return Container(
      height: 290,
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
            'Image Preview',
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
                borderRadius: BorderRadius.circular(12),
              ),
              child: isImagePreviewAvailable
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(fileBytes!, fit: BoxFit.cover),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isGeoTiff ? Icons.map_rounded : Icons.image_outlined,
                          size: 55,
                          color: blue,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          selectedFile == null
                              ? 'No image selected'
                              : isGeoTiff
                              ? 'GeoTIFF selected'
                              : 'Satellite Image',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: Text(
                  selectedFile?.name ?? 'No file selected',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: navy,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),

              if (selectedFile != null)
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedFile = null;
                      fileBytes = null;
                    });
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
            ],
          ),

          Text(
            fileSizeText,
            style: const TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildImageInformation() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildInfoCard()),
        const SizedBox(width: 20),
        Expanded(child: _buildImageTypeCard()),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Image Information',
            style: TextStyle(
              color: navy,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 18),

          _infoRow('File Name', selectedFile?.name ?? '--'),

          _infoRow('File Size', fileSizeText),

          _infoRow('Format', selectedFile?.extension?.toUpperCase() ?? '--'),

          _infoRow('Bands', isGeoTiff ? 'Multi-band' : '--'),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          SizedBox(
            width: 95,
            child: Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ),
          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: navy,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageTypeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Image Type',
            style: TextStyle(
              color: navy,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 14),

          _imageTypeOption(
            title: 'Optical (RGB)',
            subtitle: 'Standard satellite imagery',
            icon: Icons.image_outlined,
            value: 'Optical (RGB)',
          ),

          const SizedBox(height: 10),

          _imageTypeOption(
            title: 'SAR',
            subtitle: 'Synthetic Aperture Radar',
            icon: Icons.radar_rounded,
            value: 'SAR',
          ),
        ],
      ),
    );
  }

  Widget _imageTypeOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
  }) {
    final bool selected = imageType == value;

    return InkWell(
      onTap: () {
        setState(() {
          imageType = value;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF1F6FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? blue : border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: selected ? blue.withValues(alpha: 0.1) : background,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, color: selected ? blue : navy, size: 21),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: navy,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 9),
                  ),
                ],
              ),
            ),

            Icon(
              selected ? Icons.check_circle : Icons.circle_outlined,
              color: selected ? blue : Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeoTiffInfo() {
    if (!isGeoTiff) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF4FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD2E7F2)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline_rounded, color: Color(0xFF176A8C), size: 21),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'This image contains multiple bands and is a GeoTIFF file.',
              style: TextStyle(
                color: Color(0xFF174C64),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_rounded, size: 17),
          label: const Text('Back'),
          style: OutlinedButton.styleFrom(
            foregroundColor: navy,
            side: const BorderSide(color: border),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),

        ElevatedButton.icon(
          onPressed: continueToLocation,
          icon: const Icon(Icons.arrow_forward_rounded, size: 17),
          label: const Text('Continue to Location'),
          style: ElevatedButton.styleFrom(
            backgroundColor: blue,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;

  DashedBorderPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(1, 1, size.width - 2, size.height - 2),
      Radius.circular(radius),
    );

    path.addRRect(rect);

    const double dashWidth = 7.0;
    const double dashSpace = 5.0;

    for (final metric in path.computeMetrics()) {
      double distance = 0;

      while (distance < metric.length) {
        final double end = distance + dashWidth;

        canvas.drawPath(
          metric.extractPath(
            distance,
            end > metric.length ? metric.length : end,
          ),
          paint,
        );

        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
