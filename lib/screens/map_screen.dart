import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'query_screen.dart';

class MapScreen extends StatefulWidget {
  final PlatformFile selectedFile;
  final Uint8List fileBytes;
  final String imageType;

  const MapScreen({
    super.key,
    required this.selectedFile,
    required this.fileBytes,
    required this.imageType,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const Color navy = Color(0xFF071A35);
  static const Color blue = Color(0xFF2563EB);
  static const Color green = Color(0xFF10B981);
  static const Color background = Color(0xFFF5F7FA);
  static const Color border = Color(0xFFE5EAF0);

  final MapController mapController = MapController();

  LatLng selectedLocation = const LatLng(18.5204, 73.8567);

  double currentZoom = 12;

  String locationName = 'Pune, Maharashtra';

  void selectLocation(LatLng location) {
    setState(() {
      selectedLocation = location;
      locationName = 'Selected Location';
    });

    mapController.move(location, currentZoom);
  }

  void zoomIn() {
    currentZoom += 1;

    mapController.move(selectedLocation, currentZoom);
  }

  void zoomOut() {
    currentZoom -= 1;

    if (currentZoom < 3) {
      currentZoom = 3;
    }

    mapController.move(selectedLocation, currentZoom);
  }

  void resetLocation() {
    setState(() {
      selectedLocation = const LatLng(18.5204, 73.8567);

      locationName = 'Pune, Maharashtra';

      currentZoom = 12;
    });

    mapController.move(selectedLocation, currentZoom);
  }

  void continueToQuestion() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QueryScreen(
          selectedFile: widget.selectedFile,
          fileBytes: widget.fileBytes,
          imageType: widget.imageType,
          latitude: selectedLocation.latitude,
          longitude: selectedLocation.longitude,
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
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),

                          const SizedBox(height: 14),

                          _buildUploadedImageInfo(),

                          const SizedBox(height: 18),

                          Expanded(child: _buildMapWorkspace()),

                          const SizedBox(height: 18),

                          _buildBottomBar(),
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

  // =========================================================
  // SIDEBAR
  // =========================================================

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
            false,
            () {
              Navigator.pop(context);
            },
          ),

          _sideItem(Icons.cloud_upload_outlined, 'Upload Image', false, () {
            Navigator.pop(context);
          }),

          _sideItem(Icons.map_rounded, 'Explore Map', true, () {}),

          _sideItem(
            Icons.chat_bubble_outline_rounded,
            'Ask Question',
            false,
            () {},
          ),

          _sideItem(Icons.history_rounded, 'History', false, () {}),

          _sideItem(
            Icons.bookmark_border_rounded,
            'Saved Results',
            false,
            () {},
          ),

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

  // =========================================================
  // TOP BAR
  // =========================================================

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
                  hintText: 'Search location...',
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

  // =========================================================
  // HEADER
  // =========================================================

  Widget _buildHeader() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Analysis Area',
                style: TextStyle(
                  color: navy,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Choose a location on the map for your satellite analysis.',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F8F2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Icon(Icons.gps_fixed_rounded, color: green, size: 16),
              SizedBox(width: 7),
              Text(
                'Location Selection',
                style: TextStyle(
                  color: Color(0xFF047857),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =========================================================
  // UPLOADED IMAGE INFO
  // =========================================================

  Widget _buildUploadedImageInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: green, size: 18),

          const SizedBox(width: 9),

          const Text(
            'Image:',
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),

          const SizedBox(width: 5),

          Expanded(
            child: Text(
              widget.selectedFile.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: navy,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1FF),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              widget.imageType,
              style: const TextStyle(
                color: blue,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // MAP
  // =========================================================

  Widget _buildMapWorkspace() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: selectedLocation,
              initialZoom: currentZoom,
              onTap: (tapPosition, point) {
                selectLocation(point);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.satquery.ai',
              ),

              MarkerLayer(
                markers: [
                  Marker(
                    point: selectedLocation,
                    width: 65,
                    height: 65,
                    child: Container(
                      decoration: BoxDecoration(
                        color: blue.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // MAP LABEL
          Positioned(
            left: 18,
            top: 18,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.layers_outlined, color: blue, size: 18),
                  SizedBox(width: 7),
                  Text(
                    'Satellite Analysis Map',
                    style: TextStyle(
                      color: navy,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ZOOM
          Positioned(
            right: 18,
            top: 18,
            child: Column(
              children: [
                _mapControl(Icons.add, zoomIn),
                const SizedBox(height: 7),
                _mapControl(Icons.remove, zoomOut),
              ],
            ),
          ),

          // CURRENT LOCATION
          Positioned(
            right: 18,
            bottom: 18,
            child: _mapControl(Icons.my_location_rounded, () {
              mapController.move(selectedLocation, currentZoom);
            }),
          ),

          // LOCATION CARD
          Positioned(
            left: 18,
            bottom: 18,
            child: Container(
              width: 275,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 14,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.location_on_rounded, color: green, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'Selected Area',
                        style: TextStyle(
                          color: navy,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    locationName,
                    style: const TextStyle(
                      color: navy,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      _coordinate(
                        'LAT',
                        selectedLocation.latitude.toStringAsFixed(5),
                      ),
                      const SizedBox(width: 18),
                      _coordinate(
                        'LON',
                        selectedLocation.longitude.toStringAsFixed(5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapControl(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, color: navy, size: 20),
        ),
      ),
    );
  }

  Widget _coordinate(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: navy,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // =========================================================
  // BOTTOM BAR
  // =========================================================

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          const Icon(Icons.touch_app_outlined, color: blue, size: 20),

          const SizedBox(width: 10),

          const Expanded(
            child: Text(
              'Click anywhere on the map to change the analysis location.',
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ),

          OutlinedButton.icon(
            onPressed: resetLocation,
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Reset'),
            style: OutlinedButton.styleFrom(
              foregroundColor: navy,
              side: const BorderSide(color: border),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),

          const SizedBox(width: 10),

          ElevatedButton.icon(
            onPressed: continueToQuestion,
            icon: const Icon(Icons.arrow_forward_rounded, size: 17),
            label: const Text('Continue to Question'),
            style: ElevatedButton.styleFrom(
              backgroundColor: blue,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
