import 'package:padiku/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../theme/app_theme.dart';
import '../widgets/rice_plant_widget.dart';
import 'forgot_password_otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isLoading = false;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submitForgotPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email tidak boleh kosong!')),
      );
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Format email tidak valid!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      const String baseUrl = AuthServices.baseUrl;
      final response = await http.post(
        Uri.parse('$baseUrl/api/forgot-password/request-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200 && data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'OTP terkirim.'),
            backgroundColor: AppTheme.primaryGreen,
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForgotPasswordOtpScreen(email: email),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Gagal mengirim OTP.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Terjadi kesalahan koneksi'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: AppTheme.primaryGradient,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight:
                        screenH - MediaQuery.of(context).padding.top),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 48),
                      // â”€â”€ Back Button â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
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
                        ),
                      ),
                      const SizedBox(height: 24),
                      // â”€â”€ Label â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Pemulihan Akun',
                            style: GoogleFonts.outfit(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // â”€â”€ Logo â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildLogo(),
                      ),
                      const SizedBox(height: 40),
                      // â”€â”€ Card â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: _isSuccess
                              ? _buildSuccessCard()
                              : _buildFormCard(),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // â”€â”€ Footer â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                      if (!_isSuccess)
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Ingat kata sandi? ',
                                style: GoogleFonts.outfit(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 14,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Text(
                                  'Kembali Login',
                                  style: GoogleFonts.outfit(
                                    color: AppTheme.gold,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'PAD',
          style: GoogleFonts.outfit(
            fontSize: 48,
            fontWeight: FontWeight.w900,
            color: AppTheme.gold,
            letterSpacing: -1.5,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: RicePlantWidget(height: 48, width: 28),
        ),
        Text(
          'KU',
          style: GoogleFonts.outfit(
            fontSize: 48,
            fontWeight: FontWeight.w900,
            color: AppTheme.gold,
            letterSpacing: -1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          // â”€â”€ Header â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              'LUPA KATA SANDI',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // â”€â”€ Icon â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.lightGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_reset_rounded,
              size: 48,
              color: AppTheme.primaryGreen,
            ),
          ),
          const SizedBox(height: 20),
          // â”€â”€ Instruction Text â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          Text(
            'Masukkan email yang terdaftar',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppTheme.textDark,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Kami akan mengirimkan tautan pemulihan kata sandi ke email Anda.',
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          // â”€â”€ Email Field â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Alamat Email',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.outfit(
                    fontSize: 15, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: 'cth: petani@padiku.id',
                  prefixIcon: const Icon(Icons.email_outlined,
                      color: AppTheme.primaryGreen),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // â”€â”€ Submit Button â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          ElevatedButton(
            onPressed: _isLoading ? null : _submitForgotPassword,
            child: _isLoading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text('Kirim Tautan Pemulihan'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          // Checkmark animation
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.lightGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mark_email_read_rounded,
              size: 64,
              color: AppTheme.primaryGreen,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Email Terkirim!',
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Kami telah mengirimkan tautan pemulihan ke:\n${_emailController.text.trim()}\n\nSilakan cek inbox atau folder spam Anda.',
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kembali ke Login'),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              setState(() => _isSuccess = false);
            },
            child: Text(
              'Coba email lain',
              style: GoogleFonts.outfit(
                color: AppTheme.primaryGreen,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
