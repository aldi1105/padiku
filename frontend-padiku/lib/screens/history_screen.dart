import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/rice_plant_widget.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _activeTab = 0; // 0 for Terakhir Scan, 1 for Terakhir Dikunjungi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),
          _buildTabs(),
          Expanded(
            child: _buildHistoryList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 24,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.primaryGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Back Button
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.gold, width: 2),
                ),
                child: const Icon(Icons.arrow_back, color: AppTheme.gold, size: 22),
              ),
            ),
          ),
          // Centered PADIKU logo
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'PAD',
                style: GoogleFonts.outfit(
                  color: AppTheme.gold,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.5,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: RicePlantWidget(height: 42, width: 24),
              ),
              Text(
                'KU',
                style: GoogleFonts.outfit(
                  color: AppTheme.gold,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppTheme.primaryGreen, width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _activeTab = 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: _activeTab == 0 ? AppTheme.primaryGreen : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      'Terakhir Scan',
                      style: GoogleFonts.outfit(
                        color: _activeTab == 0 ? Colors.white : AppTheme.primaryGreen,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _activeTab = 1),
                child: Container(
                  decoration: BoxDecoration(
                    color: _activeTab == 1 ? AppTheme.primaryGreen : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      'Terakhir Dikunjungi',
                      style: GoogleFonts.outfit(
                        color: _activeTab == 1 ? Colors.white : AppTheme.primaryGreen,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    if (_activeTab == 0) {
      final scanData = [
        {
          'title': 'HAMA WERENG',
          'desc': 'adalah serangga yang menyerang tanaman padi dengan menghisa...',
          'date': '23-October-2024',
          'image': 'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=200&fit=crop'
        },
        {
          'title': 'Blast',
          'desc': 'adalah serangga yang menyerang tanaman padi dengan menghisa...',
          'date': '2-September-2024',
          'image': 'https://images.unsplash.com/photo-1530507629858-e4977d30e9e0?w=200&fit=crop'
        },
      ];

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: scanData.length,
        itemBuilder: (context, index) {
          final item = scanData[index];
          return _buildScanCard(item);
        },
      );
    } else {
      final visitedData = [
        {
          'title': 'Toko Sumber Tani',
          'address': 'Jl. Surotokunto No.97, Adiarsa Tim., Kec. Karawang Tim., Karawang, Jawa Barat 41313',
          'date': '2 September 2024 - 15.00',
          'status': 'Selesai',
          'statusColor': Colors.green,
          'image': 'https://images.unsplash.com/photo-1590602847861-f357a9332bbc?w=300&fit=crop'
        },
        {
          'title': 'Toko Pak Rahmat',
          'address': 'Jl. Perum Karawang Jaya, RT.32/RW.8, Sukaresmi, Kec. Karawang Tim., Karawang, Jawa Barat 41371',
          'date': '2 September 2024 - 15.00',
          'status': 'Dibatalkan',
          'statusColor': Colors.red,
          'image': 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=300&fit=crop'
        },
      ];

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: visitedData.length,
        itemBuilder: (context, index) {
          final item = visitedData[index];
          return _buildVisitedCard(item);
        },
      );
    }
  }

  Widget _buildScanCard(Map<String, String> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryGreen.withValues(alpha: 0.2), width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(18), bottomLeft: Radius.circular(18)),
            child: Image.network(item['image']!, width: 130, height: 120, fit: BoxFit.cover),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(item['title']!, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black)),
                  const SizedBox(height: 4),
                  Text(item['desc']!, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.outfit(fontSize: 12, color: Colors.black87, height: 1.3)),
                  const SizedBox(height: 8),
                  Text(item['date']!, style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black54)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisitedCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9).withValues(alpha: 0.5), // Soft green background from image
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shop Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(item['image']!, width: 120, height: 130, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            // Shop Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item['date']!, style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.black87)),
                      Text(item['status']!, style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, color: item['statusColor'])),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(item['title']!, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black)),
                  const SizedBox(height: 6),
                  Text(item['address']!, maxLines: 3, overflow: TextOverflow.ellipsis, style: GoogleFonts.outfit(fontSize: 11, color: Colors.black45, height: 1.3, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _smallButton('10m', Icons.location_on, false),
                      const SizedBox(width: 8),
                      _smallButton('Rute', Icons.near_me_rounded, true),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallButton(String label, IconData icon, bool hasIcon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hasIcon) Icon(icon, size: 12, color: Colors.black87),
            if (hasIcon) const SizedBox(width: 4),
            Text(label, style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}
