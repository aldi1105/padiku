import 'package:padiku/services/auth_services.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../theme/app_theme.dart';
import 'reset_password_screen.dart';

class ForgotPasswordOtpScreen extends StatefulWidget {
  final String email;

  const ForgotPasswordOtpScreen({
    super.key,
    required this.email,
  });

  @override
  State<ForgotPasswordOtpScreen> createState() => _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends State<ForgotPasswordOtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  Future<void> _verifyOtp() async {
    if (_otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kode OTP harus 6 digit')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('${AuthServices.baseUrl}/api/forgot-password/verify-otp'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': widget.email,
          'otp': _otpController.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (mounted) {
        setState(() => _isLoading = false);

        if (response.statusCode == 200 && data['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kode OTP valid!'),
              backgroundColor: AppTheme.primaryGreen,
            ),
          );
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(
                email: widget.email,
                otp: _otpController.text,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? 'Kode OTP salah'),
              backgroundColor: Colors.red,
            ),
          );
          _otpController.clear();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: AppTheme.primaryGreen,
        elevation: 0,
        title: Text(
          'Verifikasi OTP',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Icon(Icons.mark_email_read_rounded, size: 80, color: AppTheme.primaryGreen),
            const SizedBox(height: 24),
            Text(
              'Masukkan Kode OTP',
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Kode 6 digit telah dikirim ke:\n${widget.email}',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.black54,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 6,
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 8,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: "000000",
                      hintStyle: TextStyle(color: Colors.grey.shade300),
                      border: InputBorder.none,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _verifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Verifikasi Kode',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
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
}
