import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/fade_in_slide.dart';

class GuideDetailScreen extends StatelessWidget {
  final Map<String, String> guide;
  final String heroTag;

  const GuideDetailScreen({super.key, required this.guide, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    final isHama = guide['category'] == 'Hama';

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Header Image with Hero and Actions
          SliverAppBar(
            expandedHeight: 400.0,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: AppTheme.primaryGreen,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildGlassButton(
                icon: Icons.arrow_back_rounded,
                onTap: () => Navigator.pop(context),
              ),
            ),
            actions: [
              _buildGlassButton(
                icon: Icons.share_outlined,
                onTap: () {
                   ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Membagikan panduan...')),
                  );
                },
              ),
              const SizedBox(width: 8),
              _buildGlassButton(
                icon: Icons.bookmark_border_rounded,
                onTap: () {
                   ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Panduan disimpan ke Favorit!')),
                  );
                },
              ),
              const SizedBox(width: 16),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: heroTag,
                    child: Image.network(
                      guide['imageUrl']!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Gradient overlay for better text/icon visibility
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.5),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content Section
          SliverToBoxAdapter(
            child: Container(
              transform: Matrix4.translationValues(0, -32, 0),
              padding: const EdgeInsets.fromLTRB(28, 40, 28, 28),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Badge & Title
                  DelayedFadeInSlide(
                    delay: const Duration(milliseconds: 100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppTheme.gold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.gold.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            guide['category']!.toUpperCase(),
                            style: GoogleFonts.outfit(
                              color: AppTheme.gold,
                              fontWeight: FontWeight.w900,
                              fontSize: 11,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        // Professional Rating Pill
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star_rounded, color: AppTheme.gold, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                "4.8",
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  DelayedFadeInSlide(
                    delay: const Duration(milliseconds: 200),
                    child: Text(
                      guide['title']!,
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.primaryGreen,
                        letterSpacing: -1.0,
                        height: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Quick Metrics Row
                  DelayedFadeInSlide(
                    delay: const Duration(milliseconds: 300),
                    child: _buildMetricsRow(isHama),
                  ),
                  const SizedBox(height: 32),

                  // Content Sections
                  DelayedFadeInSlide(
                    delay: const Duration(milliseconds: 400),
                    child: _buildSection(
                      title: "Karakteristik Utama",
                      icon: Icons.info_outline_rounded,
                      content: guide['description'] ?? "Deskripsi lengkap tidak tersedia.",
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  DelayedFadeInSlide(
                    delay: const Duration(milliseconds: 500),
                    child: _buildSection(
                      title: isHama ? "Rekomendasi Penanganan" : "Saran Perawatan",
                      icon: isHama ? Icons.shield_outlined : Icons.eco_outlined,
                      content: isHama 
                        ? "• Lakukan penyemprotan insektisida organik secara berkala.\n• Gunakan varietas padi yang tahan hama.\n• Bersihkan gulma di sekitar area sawah."
                        : "• Pastikan sistem irigasi mengalir dengan baik.\n• Berikan pupuk NPK sesuai dosis anjuran.\n• Kurangi genangan air saat padi mulai menguning.",
                    ),
                  ),
                  const SizedBox(height: 32),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.25),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildMetricsRow(bool isHama) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _metricCard(
          icon: isHama ? Icons.warning_amber_rounded : Icons.water_drop_outlined,
          title: guide['metric1_title'] ?? (isHama ? 'Tingkat Bahaya' : 'Kebutuhan Air'),
          value: guide['metric1_value'] ?? (isHama ? 'Tinggi' : 'Sedang'),
        ),
        _metricCard(
          icon: isHama ? Icons.bug_report_outlined : Icons.wb_sunny_outlined,
          title: guide['metric2_title'] ?? (isHama ? 'Siklus Hidup' : 'Suhu Optimal'),
          value: guide['metric2_value'] ?? (isHama ? 'Pendek' : '20-30°C'),
        ),
        _metricCard(
          icon: isHama ? Icons.speed_rounded : Icons.calendar_month_outlined,
          title: guide['metric3_title'] ?? (isHama ? 'Penyebaran' : 'Masa Panen'),
          value: guide['metric3_value'] ?? (isHama ? 'Cepat' : '100-120 Hari'),
        ),
      ],
    );
  }

  Widget _metricCard({required IconData icon, required String title, required String value}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.gold.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppTheme.gold, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.outfit(
                color: Colors.grey.shade500,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.outfit(
                color: AppTheme.primaryGreen,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required IconData icon, required String content}) {
    List<Widget> contentWidgets = [];
    if (content.contains(':') && content.contains('\n')) {
      final lines = content.split('\n');
      for (var line in lines) {
        if (line.contains(':')) {
          final parts = line.split(':');
            contentWidgets.add(
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Text(
                        parts[0].trim(),
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Text(
                        parts.sublist(1).join(':').trim(),
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            );
        } else {
          contentWidgets.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                line,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
            ),
          );
        }
      }
    } else {
      contentWidgets.add(
        Text(
          content,
          style: GoogleFonts.outfit(
            fontSize: 16,
            color: Colors.grey.shade600,
            height: 1.7,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppTheme.primaryGreen, size: 24),
            const SizedBox(width: 10),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ...contentWidgets,
      ],
    );
  }
}
