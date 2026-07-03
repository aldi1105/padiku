import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> _sections = [
    {
      'icon': Icons.info_outline_rounded,
      'iconColor': const Color(0xFF1565C0),
      'bgColor': const Color(0xFFE3F2FD),
      'title': '1. Informasi yang Kami Kumpulkan',
      'content':
          'Ketika Anda menggunakan aplikasi Padiku, kami dapat mengumpulkan informasi berikut:\n\n'
              '• Informasi Akun: nama lengkap, alamat email, dan kata sandi yang dienkripsi.\n\n'
              '• Informasi Profil: nomor telepon, foto profil, dan biografi singkat yang Anda berikan secara sukarela.\n\n'
              '• Data Lokasi: koordinat GPS dan nama alamat untuk fitur cuaca dan rute lahan. Kami hanya mengakses lokasi saat Anda mengizinkannya.\n\n'
              '• Data Penggunaan: informasi tentang cara Anda menggunakan aplikasi, seperti fitur yang diakses, untuk keperluan peningkatan layanan.',
    },
    {
      'icon': Icons.tune_rounded,
      'iconColor': AppTheme.primaryGreen,
      'bgColor': AppTheme.lightGreen,
      'title': '2. Cara Kami Menggunakan Informasi',
      'content':
          'Informasi yang kami kumpulkan digunakan untuk:\n\n'
              '• Menyediakan, mengoperasikan, dan memelihara layanan Padiku.\n\n'
              '• Mempersonalisasi pengalaman Anda, termasuk rekomendasi cuaca, panduan budidaya, dan informasi pasar yang relevan dengan lokasi lahan Anda.\n\n'
              '• Mengirimkan pembaruan, notifikasi layanan, dan informasi penting tentang akun Anda.\n\n'
              '• Meningkatkan keamanan dan mendeteksi aktivitas yang mencurigakan atau tidak sah.\n\n'
              '• Mematuhi kewajiban hukum yang berlaku.',
    },
    {
      'icon': Icons.share_outlined,
      'iconColor': AppTheme.orange,
      'bgColor': const Color(0xFFFFF3EE),
      'title': '3. Berbagi Informasi',
      'content':
          'Kami berkomitmen untuk TIDAK menjual, memperdagangkan, atau menyewakan informasi pribadi Anda kepada pihak ketiga untuk keperluan komersial.\n\n'
              'Informasi Anda hanya dapat dibagikan dalam kondisi berikut:\n\n'
              '• Dengan persetujuan eksplisit dari Anda.\n\n'
              '• Kepada penyedia layanan terpercaya yang membantu operasional kami (misalnya layanan server), dengan perjanjian kerahasiaan yang ketat.\n\n'
              '• Jika diwajibkan oleh hukum, perintah pengadilan, atau proses hukum yang sah.',
    },
    {
      'icon': Icons.security_rounded,
      'iconColor': const Color(0xFF7B1FA2),
      'bgColor': const Color(0xFFF3E5F5),
      'title': '4. Keamanan Data',
      'content':
          'Kami menerapkan langkah-langkah keamanan teknis dan organisasional yang sesuai untuk melindungi informasi Anda dari akses tidak sah, perubahan, pengungkapan, atau penghancuran.\n\n'
              '• Kata sandi Anda disimpan menggunakan algoritma hashing bcrypt yang aman.\n\n'
              '• Komunikasi antara aplikasi dan server dienkripsi menggunakan protokol HTTPS.\n\n'
              '• Akses ke data pengguna dibatasi hanya untuk personel yang berwenang.\n\n'
              'Namun, tidak ada metode transmisi data melalui internet yang 100% aman. Kami akan berupaya semaksimal mungkin untuk melindungi data Anda.',
    },
    {
      'icon': Icons.verified_user_outlined,
      'iconColor': const Color(0xFF00796B),
      'bgColor': const Color(0xFFE0F2F1),
      'title': '5. Hak-Hak Pengguna',
      'content':
          'Sebagai pengguna Padiku, Anda memiliki hak untuk:\n\n'
              '• Mengakses: melihat informasi pribadi yang kami simpan tentang Anda kapan saja melalui halaman Profil.\n\n'
              '• Memperbarui: mengubah atau mengoreksi informasi pribadi Anda melalui aplikasi.\n\n'
              '• Menghapus: meminta penghapusan akun dan semua data terkait dengan menghubungi tim kami.\n\n'
              '• Membatasi Pemrosesan: meminta kami untuk membatasi pemrosesan data Anda dalam kondisi tertentu.\n\n'
              'Untuk menggunakan hak-hak ini, hubungi kami melalui email privacy@padiku.id.',
    },
    {
      'icon': Icons.location_on_outlined,
      'iconColor': const Color(0xFFC62828),
      'bgColor': const Color(0xFFFFEBEE),
      'title': '6. Kebijakan Lokasi',
      'content':
          'Aplikasi Padiku meminta izin akses lokasi perangkat Anda untuk fitur-fitur berikut:\n\n'
              '• Informasi cuaca yang akurat dan spesifik untuk lahan pertanian Anda.\n\n'
              '• Fitur navigasi dan rute menuju lahan.\n\n'
              '• Penyimpanan lokasi profil untuk kemudahan identifikasi wilayah.\n\n'
              'Anda dapat mencabut izin lokasi kapan saja melalui pengaturan perangkat. Namun, beberapa fitur mungkin tidak berfungsi optimal tanpa akses lokasi.',
    },
    {
      'icon': Icons.cookie_outlined,
      'iconColor': const Color(0xFF5D4037),
      'bgColor': const Color(0xFFFBEFE6),
      'title': '7. Penyimpanan Data Lokal',
      'content':
          'Aplikasi Padiku menggunakan penyimpanan lokal (SharedPreferences) di perangkat Anda untuk menyimpan:\n\n'
              '• Status login dan token autentikasi agar Anda tidak perlu login berulang kali.\n\n'
              '• Preferensi pengaturan aplikasi.\n\n'
              'Data ini tidak dibagikan ke pihak lain dan dapat dihapus dengan cara keluar (logout) dari aplikasi atau menghapus data aplikasi di pengaturan perangkat Anda.',
    },
    {
      'icon': Icons.update_rounded,
      'iconColor': const Color(0xFF0277BD),
      'bgColor': const Color(0xFFE1F5FE),
      'title': '8. Perubahan Kebijakan',
      'content':
          'Kami dapat memperbarui Kebijakan Privasi ini dari waktu ke waktu. Kami akan memberitahukan perubahan signifikan melalui notifikasi dalam aplikasi atau melalui email terdaftar Anda.\n\n'
              'Dengan terus menggunakan aplikasi Padiku setelah perubahan diterbitkan, Anda dianggap telah menerima kebijakan yang diperbarui.\n\n'
              'Kami menganjurkan Anda untuk meninjau kebijakan ini secara berkala untuk tetap mendapatkan informasi terbaru.',
    },
    {
      'icon': Icons.contact_mail_outlined,
      'iconColor': AppTheme.premiumGold,
      'bgColor': const Color(0xFFFFF8E1),
      'title': '9. Hubungi Kami',
      'content':
          'Jika Anda memiliki pertanyaan, kekhawatiran, atau permintaan terkait Kebijakan Privasi ini atau cara kami menangani informasi Anda, silakan hubungi:\n\n'
              '📧 Email: privacy@padiku.id\n\n'
              '🏢 Alamat: Jl. Pertanian No. 1, Jakarta, Indonesia\n\n'
              '📞 Telepon: +62 21 1234 5678\n\n'
              'Tim Privasi kami akan berupaya merespons permintaan Anda dalam waktu 7 (tujuh) hari kerja.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildEffectiveDate(),
                      const SizedBox(height: 20),
                      _buildIntroCard(),
                      const SizedBox(height: 20),
                      ..._sections.map((section) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _buildSectionCard(section),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Kebijakan Privasi',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              // Hero card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.gold.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.privacy_tip_rounded,
                        color: AppTheme.gold,
                        size: 36,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Privasi Anda, Prioritas Kami',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Kami berkomitmen melindungi dan menghormati privasi Anda.',
                            style: GoogleFonts.outfit(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEffectiveDate() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryGreen.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today_outlined,
              color: AppTheme.primaryGreen, size: 18),
          const SizedBox(width: 10),
          Text(
            'Berlaku sejak: ',
            style: GoogleFonts.outfit(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          Text(
            '1 Januari 2025',
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryGreen,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.lightGreen,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'v1.0',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryGreen.withValues(alpha: 0.08),
            AppTheme.accentGreen.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryGreen.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.article_outlined,
                  color: AppTheme.primaryGreen, size: 20),
              const SizedBox(width: 8),
              Text(
                'Pendahuluan',
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Selamat datang di Padiku — aplikasi pertanian digital untuk petani Indonesia. '
            'Kebijakan Privasi ini menjelaskan bagaimana kami mengumpulkan, menggunakan, '
            'menyimpan, dan melindungi informasi pribadi Anda saat menggunakan layanan kami.\n\n'
            'Dengan mendaftar dan menggunakan Padiku, Anda menyetujui pengumpulan dan '
            'penggunaan informasi sesuai dengan kebijakan ini. Harap baca dengan seksama.',
            style: GoogleFonts.outfit(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(Map<String, dynamic> section) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: (section['bgColor'] as Color).withValues(alpha: 0.6),
                border: Border(
                  bottom: BorderSide(
                    color: (section['iconColor'] as Color).withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: section['bgColor'] as Color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      section['icon'] as IconData,
                      color: section['iconColor'] as Color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      section['title'] as String,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Section content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                section['content'] as String,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: Colors.grey[700],
                  height: 1.7,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
