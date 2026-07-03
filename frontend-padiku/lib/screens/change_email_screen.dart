import 'package:padiku/services/auth_services.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import 'otp_verification_screen.dart';

class ChangeEmailScreen extends StatefulWidget {
  final String currentEmail;
  const ChangeEmailScreen({super.key, required this.currentEmail});

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.currentEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submitEmailChange() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      // Request OTP
      final otpResponse = await http.post(
        Uri.parse('${AuthServices.baseUrl}/api/user/request-otp'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: {'type': 'email'},
      );

      final otpData = jsonDecode(otpResponse.body);
      
      if (!mounted) return;

      if (otpResponse.statusCode != 200 || otpData['success'] != true) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(otpData['message'] ?? 'Gagal meminta OTP'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kode OTP telah dikirim ke email Anda'),
          backgroundColor: AppTheme.primaryGreen,
          duration: Duration(seconds: 3),
        ),
      );

      // Verify OTP
      final verified = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpVerificationScreen(
            type: 'email',
            value: widget.currentEmail,
          ),
        ),
      );

      if (verified != true) {
        setState(() => _isLoading = false);
        return;
      }

      // Proceed with update
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${AuthServices.baseUrl}/api/user/update'),
      );
      
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });
      request.fields['email'] = _emailController.text;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(response.body);

      if (mounted) {
        setState(() => _isLoading = false);
        
        if (response.statusCode == 200 && data['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email berhasil diperbarui'),
              backgroundColor: AppTheme.primaryGreen,
            ),
          );
          Navigator.pop(context, true); // Return to profile
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? 'Gagal memperbarui email'),
              backgroundColor: Colors.red,
            ),
          );
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
          'Ubah Email',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ubah Alamat Email',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Pastikan alamat email Anda aktif untuk menerima informasi penting.',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 32),

              _buildTextField(
                label: 'Email Baru',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Email tidak boleh kosong';
                  if (!val.contains('@')) return 'Format email tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitEmailChange,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Simpan Email',
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
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: GoogleFonts.outfit(fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Masukkan $label',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppTheme.primaryGreen, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
