import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/rice_plant_widget.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {'text': 'Bidik Swasembada Pangan, Luas Lahan Padi Perhatian Kementan', 'time': '2m', 'isNew': true},
      {'text': 'Bidik Swasembada Pangan, Luas Lahan Padi Perhatian Kementan', 'time': '2h', 'isNew': true},
      {'text': 'Bidik Swasembada Pangan, Luas Lahan Padi Perhatian Kementan', 'time': '1d', 'isNew': false},
      {'text': 'Bidik Swasembada Pangan, Luas Lahan Padi Perhatian Kementan', 'time': '3d', 'isNew': false},
      {'text': 'Bidik Swasembada Pangan, Luas Lahan Padi Perhatian Kementan', 'time': '5d', 'isNew': false},
      {'text': 'Bidik Swasembada Pangan, Luas Lahan Padi Perhatian Kementan', 'time': '7d', 'isNew': false},
      {'text': 'Bidik Swasembada Pangan, Luas Lahan Padi Perhatian Kementan', 'time': '10d', 'isNew': false},
      {'text': 'Bidik Swasembada Pangan, Luas Lahan Padi Perhatian Kementan', 'time': '14d', 'isNew': false},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                return _buildNotificationItem(item);
              },
            ),
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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'PAD',
                style: GoogleFonts.outfit(color: AppTheme.gold, fontSize: 36, fontWeight: FontWeight.w900, letterSpacing: -1.5),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: RicePlantWidget(height: 42, width: 24),
              ),
              Text(
                'KU',
                style: GoogleFonts.outfit(color: AppTheme.gold, fontSize: 36, fontWeight: FontWeight.w900, letterSpacing: -1.5),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: item['isNew'] ? const Color(0xFFE8F5E9) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: item['isNew'] ? [] : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Rice Plant Icon in Circle
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const RicePlantWidget(height: 32, width: 20),
          ),
          const SizedBox(width: 16),
          // Notification Text
          Expanded(
            child: Text(
              item['text'],
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Colors.black.withValues(alpha: 0.8),
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Time
          Text(
            item['time'],
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
}
