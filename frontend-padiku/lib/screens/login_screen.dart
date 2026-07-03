import 'package:padiku/services/auth_services.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../widgets/rice_plant_widget.dart';
import 'register_screen.dart';
import 'main_navigation.dart';
import 'splash_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool _obscurePassword = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  Timer? _statusTimer;
  String? _pendingEmail;

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

    _checkPendingVerification();
  }

  Future<void> _checkPendingVerification() async {
    _statusTimer?.cancel(); // Pastikan timer lama dimatikan sebelum membuat yang baru
    final prefs = await SharedPreferences.getInstance();
    _pendingEmail = prefs.getString('pending_email');

    if (_pendingEmail != null && _pendingEmail!.isNotEmpty) {
      // Start polling every 3 seconds
      _statusTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
        try {
          String baseUrl = AuthServices.baseUrl;
          final response = await http.get(Uri.parse('$baseUrl/api/check-status/$_pendingEmail'));
          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            if (data['success'] == true && data['status'] == 'approved') {
              timer.cancel();
              await prefs.remove('pending_email');
              
              if (!mounted) return;
              _showApprovalSuccessDialog();
            }
          }
        } catch (e) {
          // Abaikan error koneksi saat polling
        }
      });
    }
  }

  void _showApprovalSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: AppTheme.primaryGreen, size: 64),
                const SizedBox(height: 16),
                Text(
                  'Horee!',
                  style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Akun Anda telah disetujui oleh Admin. Silakan masuk sekarang.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey[700]),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Auto-fill email untuk memudahkan
                      if (_pendingEmail != null) {
                        setState(() {
                          _emailController.text = _pendingEmail!;
                        });
                      }
                    },
                    child: const Text('Siap, Masuk!'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
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
              constraints: BoxConstraints(minHeight: screenH - MediaQuery.of(context).padding.top),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 48),
                    // â”€â”€ Welcome to â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Selamat Datang di',
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
                    // â”€â”€ PADIKU Logo â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildLogo(),
                    ),
                    const SizedBox(height: 40),
                    // â”€â”€ Form Card â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildCard(context),
                      ),
                    ),
                    const SizedBox(height: 48),
                    // â”€â”€ Footer â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Belum punya akun? ',
                            style: GoogleFonts.outfit(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const RegisterScreen()),
                              );
                              // Panggil ulang pengecekan jika baru selesai mendaftar
                              _checkPendingVerification();
                            },
                            child: Text(
                              'Daftar Sekarang',
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
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
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

  Widget _buildCard(BuildContext context) {
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
          // â”€â”€ Pill Header â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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
              'MASUK',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
              ),
            ),
          ),
          const SizedBox(height: 28),
          // Email
          _buildField(
            controller: _emailController,
            label: 'Alamat Email',
            hint: 'cth: petani@padiku.id',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 18),
          // Password
          _buildField(
            controller: _passwordController,
            label: 'Kata Sandi',
            hint: 'â€¢â€¢â€¢â€¢â€¢â€¢â€¢â€¢',
            obscure: _obscurePassword,
            suffix: GestureDetector(
              onTap: () => setState(() => _obscurePassword = !_obscurePassword),
              child: Icon(
                _obscurePassword
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: AppTheme.primaryGreen,
                size: 22,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ForgotPasswordScreen(),
                  ),
                );
              },
              child: Text(
                'Lupa Kata Sandi?',
                style: GoogleFonts.outfit(
                  color: AppTheme.primaryGreen,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Masuk button
          ElevatedButton(
            onPressed: () async {
              // Validasi Frontend
              final email = _emailController.text.trim();
              final password = _passwordController.text;

              if (email.isEmpty || password.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Email dan kata sandi tidak boleh kosong!')),
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

              try {
                // Tampilkan loading dialog atau ubah state
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Memproses login...')),
                );

                String baseUrl = AuthServices.baseUrl; // IP WiFi Laptop Anda
                final response = await http.post(
                  Uri.parse('$baseUrl/api/login'),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({
                    'email': email,
                    'password': password,
                  }),
                );

                final data = jsonDecode(response.body);

                if (response.statusCode == 200 && data['success'] == true) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isLoggedIn', true);
                  await prefs.setString('token', data['token']);
                  await prefs.setString('userName', data['data']['name']);
                  
                  if (!context.mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SplashScreen(fromLogin: true)),
                  );
                } else {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(data['message'] ?? 'Email atau password salah'),
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('Gagal terhubung ke server database.'),
                  ),
                );
              }
            },
            child: const Text('Masuk Sekarang'),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}
