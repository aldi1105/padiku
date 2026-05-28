import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
import 'change_password_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> _userData = {};
  String _name = 'Memuat...';
  String _email = 'Memuat...';
  String _role = 'Petani Hebat';
  String _phone = 'Belum diatur';
  String _location = 'Belum diatur';
  String? _profilePictureUrl;
  bool _isLoading = true;

  // Inline editing state
  String? _editingField; // 'name', 'bio', 'phone'
  final TextEditingController _editController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return;

      final response = await http.get(
        Uri.parse('http://192.168.100.56:8000/api/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && mounted) {
          setState(() {
            _userData = data['data'];
            _name = _userData['name'] ?? 'Pengguna';
            _email = _userData['email'] ?? '';
            _role = _userData['bio'] != null && _userData['bio'].toString().isNotEmpty ? _userData['bio'] : 'Petani Hebat';
            _phone = _userData['phone'] != null && _userData['phone'].toString().isNotEmpty ? _userData['phone'] : 'Belum diatur';
            _location = _userData['location'] != null && _userData['location'].toString().isNotEmpty ? _userData['location'] : 'Belum diatur';
            _profilePictureUrl = _userData['profile_picture_url'];
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateFields(Map<String, String> fields, {bool showSnackbar = true}) async {
    bool hasData = false;
    for (var value in fields.values) {
      if (value.trim().isNotEmpty) {
        hasData = true;
        break;
      }
    }
    if (!hasData && !fields.containsKey('bio')) return;

    setState(() => _isLoading = true);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return;

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.100.56:8000/api/user/update'),
      );
      
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      fields.forEach((key, value) {
        request.fields[key] = value;
      });

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        if (mounted) {
          if (showSnackbar) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Pembaruan berhasil disimpan')),
            );
          }
          _fetchUserData();
        }
      } else {
        if (mounted) {
          if (showSnackbar) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Gagal menyimpan perubahan')),
            );
          }
          setState(() => _isLoading = false);
        }
      }
    } catch (e) {
      if (mounted) {
        if (showSnackbar) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Terjadi kesalahan koneksi')),
          );
        }
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _updateField(String field, String value) async {
    return _updateFields({field: value});
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() => _isLoading = true);
      
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        if (token == null) return;

        var request = http.MultipartRequest(
          'POST',
          Uri.parse('http://192.168.100.56:8000/api/user/update'),
        );
        
        request.headers.addAll({
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        });

        request.files.add(await http.MultipartFile.fromPath(
          'profile_picture',
          pickedFile.path,
        ));

        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Foto profil berhasil diperbarui')),
            );
            _fetchUserData();
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Gagal mengunggah foto')),
            );
            setState(() => _isLoading = false);
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Terjadi kesalahan koneksi saat mengunggah')),
          );
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _fetchGPSAndSave() async {
    setState(() => _isLoading = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Layanan Lokasi dinonaktifkan')));
        }
        setState(() => _isLoading = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Izin Lokasi ditolak')));
          }
          setState(() => _isLoading = false);
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Izin Lokasi ditolak secara permanen')));
        }
        setState(() => _isLoading = false);
        return;
      }

      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation,
          timeLimit: const Duration(seconds: 15),
        );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sinyal GPS lemah, gagal mendapatkan lokasi presisi.')));
        }
        setState(() => _isLoading = false);
        return;
      }

      if (position == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tidak dapat melacak lokasi saat ini, pastikan GPS aktif')));
        }
        setState(() => _isLoading = false);
        return;
      }

      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        
        List<String> detailedParts = [];
        if (place.street != null && place.street!.isNotEmpty) detailedParts.add(place.street!);
        if (place.subLocality != null && place.subLocality!.isNotEmpty) detailedParts.add(place.subLocality!);
        if (place.locality != null && place.locality!.isNotEmpty) detailedParts.add(place.locality!);
        if (place.subAdministrativeArea != null && place.subAdministrativeArea!.isNotEmpty) {
          detailedParts.add(place.subAdministrativeArea!.replaceAll('Kabupaten ', '').replaceAll('Kota ', ''));
        }
        if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) detailedParts.add(place.administrativeArea!);
        
        String locationStr = detailedParts.isNotEmpty ? detailedParts.join(', ') : (place.country ?? 'Lokasi ditemukan');
        
        await _updateFields({
          'location': locationStr,
          'latitude': position.latitude.toString(),
          'longitude': position.longitude.toString(),
        }, showSnackbar: false);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal menemukan alamat dari kordinat')));
        }
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal mendapatkan lokasi GPS')));
      }
      setState(() => _isLoading = false);
    }
  }

  String _formatPhoneDisplay(String phone) {
    if (phone == 'Belum diatur' || phone.isEmpty) return phone;
    final text = phone.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write('-');
      buffer.write(text[i]);
    }
    return buffer.toString();
  }

  void _startEditing(String fieldKey, String currentValue) {
    setState(() {
      _editingField = fieldKey;
      _editController.text = currentValue == 'Belum diatur' ? '' : currentValue;
    });
  }

  void _saveEditing() {
    if (_editingField != null) {
      _updateField(_editingField!, _editController.text);
      setState(() {
        _editingField = null;
      });
    }
  }

  void _cancelEditing() {
    setState(() {
      _editingField = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Soft background
      body: _isLoading && _userData.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen))
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(context),
                  _buildProfileInfo(),
                  const SizedBox(height: 20),
                  _buildMenuSection(context),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 280, // Total height to contain both background and avatar
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Green Background Curve
          Container(
            height: 220,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryGreen, Color(0xFF2E7D32)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    'Profil Saya',
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Avatar overlapping the bottom edge
          Positioned(
            top: 165, // 220 (background) - 55 (half of 110 avatar size)
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _pickAndUploadImage,
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: AppTheme.lightGreen,
                      backgroundImage: _profilePictureUrl != null 
                          ? NetworkImage(_profilePictureUrl!)
                          : NetworkImage(
                              'https://ui-avatars.com/api/?name=${Uri.encodeComponent(_name)}&background=E8F5E9&color=15682A&size=200',
                            ) as ImageProvider,
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.gold,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: _isLoading 
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 24, right: 24),
      child: Column(
        children: [
          // Nama Lengkap Inline Edit
          _editingField == 'name'
              ? _buildInlineEditField()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _name,
                      style: GoogleFonts.outfit(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _startEditing('name', _name),
                      child: const Icon(Icons.edit_rounded, color: AppTheme.primaryGreen, size: 20),
                    )
                  ],
                ),
          const SizedBox(height: 4),
          // Bio / Pekerjaan Inline Edit
          _editingField == 'bio'
              ? _buildInlineEditField()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _role,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _startEditing('bio', _role),
                      child: Icon(Icons.edit_rounded, color: AppTheme.primaryGreen.withOpacity(0.6), size: 16),
                    )
                  ],
                ),
          const SizedBox(height: 24),
          
          // Info Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, 5)),
              ],
            ),
            child: Column(
              children: [
                _buildInfoRow(Icons.mail_outline_rounded, 'Email', _email, fieldKey: null),
                const Divider(color: Color(0xFFEEEEEE)),
                _editingField == 'phone'
                    ? _buildInlineEditCardField('phone', Icons.phone_outlined)
                    : _buildInfoRow(Icons.phone_outlined, 'Telepon', _formatPhoneDisplay(_phone), fieldKey: 'phone'),
                const Divider(color: Color(0xFFEEEEEE)),
                // Lokasi tidak pakai inline edit, tapi panggil _fetchGPSAndSave()
                _buildInfoRow(Icons.location_on_outlined, 'Lokasi', _location, fieldKey: 'location', onEdit: _fetchGPSAndSave),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInlineEditField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 180,
          child: TextField(
            controller: _editController,
            autofocus: true,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.check_circle, color: AppTheme.primaryGreen),
          onPressed: _saveEditing,
        ),
        IconButton(
          icon: const Icon(Icons.cancel, color: Colors.grey),
          onPressed: _cancelEditing,
        ),
      ],
    );
  }

  Widget _buildInlineEditCardField(String fieldKey, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.lightGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.primaryGreen, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: _editController,
              autofocus: true,
              keyboardType: fieldKey == 'phone' ? TextInputType.phone : TextInputType.text,
              inputFormatters: fieldKey == 'phone' ? [_PhoneFormatter()] : null,
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
              decoration: InputDecoration(
                isDense: true,
                hintText: fieldKey == 'phone' ? 'Masukkan nomor telepon' : '',
                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              ),
              onSubmitted: (_) => _saveEditing(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.check_circle, color: AppTheme.primaryGreen),
            onPressed: _saveEditing,
          ),
          IconButton(
            icon: const Icon(Icons.cancel, color: Colors.grey),
            onPressed: _cancelEditing,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {String? fieldKey, VoidCallback? onEdit}) {
    return InkWell(
      onTap: () {
        if (onEdit != null) {
          onEdit();
        } else if (fieldKey != null) {
          _startEditing(fieldKey, value);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.lightGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppTheme.primaryGreen, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.outfit(
                      color: Colors.grey.shade500,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    value,
                    style: GoogleFonts.outfit(
                      color: AppTheme.textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            if (fieldKey != null || onEdit != null)
              Icon(fieldKey == 'location' ? Icons.my_location_rounded : Icons.edit_outlined, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pengaturan',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, 5)),
              ],
            ),
            child: Column(
              children: [
                _buildMenuItem(Icons.lock_outline_rounded, 'Ubah Password', true, onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                  );
                }),
                const Divider(color: Color(0xFFEEEEEE), height: 1),
                _buildMenuItem(Icons.notifications_none_rounded, 'Notifikasi', true, onTap: () {}),
                const Divider(color: Color(0xFFEEEEEE), height: 1),
                _buildMenuItem(Icons.help_outline_rounded, 'Pusat Bantuan', true, onTap: () {}),
                const Divider(color: Color(0xFFEEEEEE), height: 1),
                _buildMenuItem(Icons.privacy_tip_outlined, 'Kebijakan Privasi', true, onTap: () {}),
                const Divider(color: Color(0xFFEEEEEE), height: 1),
                
                // Logout Button
                InkWell(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('isLoggedIn', false);
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    }
                  },
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.logout_rounded, color: Colors.red, size: 22),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Keluar (Logout)',
                          style: GoogleFonts.outfit(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, bool hasArrow, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppTheme.textDark, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.outfit(
                  color: AppTheme.textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
              if (hasArrow)
              Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade400, size: 16),
          ],
        ),
      ),
    );
  }
}

class _PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write('-');
      buffer.write(text[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
