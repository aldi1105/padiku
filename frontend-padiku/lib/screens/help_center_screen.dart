import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, String>> _faqs = [
    {
      'question': 'Bagaimana cara mendaftar akun Padiku?',
      'answer':
          'Buka aplikasi Padiku dan ketuk tombol "Daftar Sekarang" di halaman login. Isi nama lengkap, alamat email, dan kata sandi. Setelah mendaftar, akun Anda akan menunggu verifikasi dari Admin sebelum bisa digunakan.',
    },
    {
      'question': 'Mengapa akun saya belum bisa masuk setelah daftar?',
      'answer':
          'Setiap akun baru memerlukan persetujuan dari Admin Padiku. Proses ini biasanya memakan waktu 1×24 jam. Anda akan mendapatkan notifikasi otomatis di aplikasi saat akun telah disetujui.',
    },
    {
      'question': 'Bagaimana cara memperbarui data profil saya?',
      'answer':
          'Buka menu "Profil Saya" di navigasi bawah. Ketuk ikon edit (pensil) di samping nama atau bio Anda untuk mengubahnya langsung. Untuk telepon, ketuk baris telepon pada kartu info. Untuk lokasi, ketuk ikon lokasi agar GPS otomatis mendeteksi posisi Anda.',
    },
    {
      'question': 'Bagaimana cara mengubah foto profil?',
      'answer':
          'Di halaman Profil, ketuk foto profil Anda (lingkaran dengan ikon kamera di pojok kanan bawah). Pilih foto dari galeri perangkat Anda. Foto akan langsung diperbarui secara otomatis.',
    },
    {
      'question': 'Fitur apa saja yang tersedia di Padiku?',
      'answer':
          'Padiku menyediakan berbagai fitur untuk petani, antara lain: (1) Informasi cuaca real-time untuk lahan pertanian, (2) Panduan budidaya padi, (3) Berita pertanian terkini, (4) Toko produk pertanian, (5) Rute dan navigasi ke lahan, serta (6) Pemindaian hama dan penyakit tanaman.',
    },
    {
      'question': 'Bagaimana cara mengubah kata sandi?',
      'answer':
          'Buka halaman Profil, lalu ketuk menu "Ubah Password" pada bagian Pengaturan. Masukkan kata sandi lama Anda, diikuti kata sandi baru dan konfirmasinya. Pastikan kata sandi baru minimal 8 karakter.',
    },
    {
      'question': 'Saya lupa kata sandi, apa yang harus dilakukan?',
      'answer':
          'Di halaman Login, ketuk tautan "Lupa Kata Sandi?" di bawah kolom kata sandi. Masukkan email yang terdaftar dan kami akan mengirimkan tautan pemulihan ke email Anda.',
    },
    {
      'question': 'Bagaimana cara melaporkan masalah teknis?',
      'answer':
          'Jika mengalami masalah teknis, Anda dapat menghubungi tim dukungan kami melalui WhatsApp di 0812-3456-7890 atau email ke support@padiku.id. Sertakan deskripsi masalah dan screenshot jika memungkinkan untuk penanganan lebih cepat.',
    },
    {
      'question': 'Apakah data saya aman di Padiku?',
      'answer':
          'Ya, kami menggunakan enkripsi standar industri untuk melindungi data Anda. Informasi pribadi Anda tidak akan dibagikan kepada pihak ketiga tanpa izin. Selengkapnya dapat dibaca di halaman Kebijakan Privasi.',
    },
  ];

  int? _expandedIndex;

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
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      _buildSearchHint(),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Pertanyaan Umum (FAQ)'),
                      const SizedBox(height: 12),
                      _buildFaqList(),
                      const SizedBox(height: 28),
                      _buildSectionTitle('Butuh Bantuan Lebih?'),
                      const SizedBox(height: 12),
                      _buildContactCard(),
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
              // Back button + title row
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
                    'Pusat Bantuan',
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
                        Icons.support_agent_rounded,
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
                            'Ada yang bisa kami bantu?',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Temukan jawaban atas pertanyaan Anda di bawah ini.',
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

  Widget _buildSearchHint() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryGreen.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded,
              color: AppTheme.primaryGreen, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Ketuk pertanyaan di bawah untuk melihat jawabannya.',
              style: GoogleFonts.outfit(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: AppTheme.textDark,
      ),
    );
  }

  Widget _buildFaqList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: List.generate(_faqs.length, (index) {
            final faq = _faqs[index];
            final isExpanded = _expandedIndex == index;
            final isLast = index == _faqs.length - 1;

            return Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  color: isExpanded
                      ? AppTheme.lightGreen
                      : Colors.white,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _expandedIndex = isExpanded ? null : index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: isExpanded
                                      ? AppTheme.primaryGreen
                                      : AppTheme.lightGreen,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '${index + 1}',
                                  style: GoogleFonts.outfit(
                                    color: isExpanded
                                        ? Colors.white
                                        : AppTheme.primaryGreen,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  faq['question']!,
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: isExpanded
                                        ? AppTheme.primaryGreen
                                        : AppTheme.textDark,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              AnimatedRotation(
                                turns: isExpanded ? 0.5 : 0,
                                duration: const Duration(milliseconds: 200),
                                child: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: isExpanded
                                      ? AppTheme.primaryGreen
                                      : Colors.grey[400],
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                          if (isExpanded) ...[
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.only(left: 40),
                              child: Text(
                                faq['answer']!,
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                  height: 1.6,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  const Divider(
                      height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildContactCard() {
    return Column(
      children: [
        _buildContactItem(
          icon: Icons.chat_rounded,
          iconColor: const Color(0xFF25D366),
          bgColor: const Color(0xFFE8F8EF),
          title: 'WhatsApp Support',
          subtitle: '0812-3456-7890',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildContactItem(
          icon: Icons.email_outlined,
          iconColor: AppTheme.primaryGreen,
          bgColor: AppTheme.lightGreen,
          title: 'Email Dukungan',
          subtitle: 'support@padiku.id',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildContactItem(
          icon: Icons.schedule_rounded,
          iconColor: AppTheme.orange,
          bgColor: const Color(0xFFFFF3EE),
          title: 'Jam Operasional',
          subtitle: 'Senin – Jumat, 08.00 – 17.00 WIB',
          onTap: null,
        ),
      ],
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
