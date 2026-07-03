import 'package:padiku/services/auth_services.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _pauseAll = false;
  bool _newsArticles = true;
  bool _weatherAlerts = true;
  bool _shopPromos = true;
  bool _systemSecurity = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load from local first for fast UI
    setState(() {
      _pauseAll = prefs.getBool('notif_pause_all') ?? false;
      _newsArticles = prefs.getBool('notif_news') ?? true;
      _weatherAlerts = prefs.getBool('notif_weather') ?? true;
      _shopPromos = prefs.getBool('notif_shop') ?? true;
      _systemSecurity = prefs.getBool('notif_system') ?? true;
    });

    // Try fetching from server
    try {
      final token = prefs.getString('token');
      if (token != null) {
        final response = await http.get(
          Uri.parse('${AuthServices.baseUrl}/api/user'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['success'] == true && data['data']['notification_settings'] != null) {
            final ns = data['data']['notification_settings'];
            setState(() {
              _pauseAll = ns['pause_all'] ?? false;
              _newsArticles = ns['news'] ?? true;
              _weatherAlerts = ns['weather'] ?? true;
              _shopPromos = ns['shop'] ?? true;
              _systemSecurity = ns['system'] ?? true;
            });
            // Update local prefs
            prefs.setBool('notif_pause_all', _pauseAll);
            prefs.setBool('notif_news', _newsArticles);
            prefs.setBool('notif_weather', _weatherAlerts);
            prefs.setBool('notif_shop', _shopPromos);
            prefs.setBool('notif_system', _systemSecurity);
          }
        }
      }
    } catch (e) {
      // Ignore network error, fallback to local
    }
  }

  Future<void> _savePreference(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    
    // Sync to server
    try {
      final token = prefs.getString('token');
      if (token != null) {
        await http.post(
          Uri.parse('${AuthServices.baseUrl}/api/user/notification-settings'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'notification_settings': {
              'pause_all': _pauseAll,
              'news': _newsArticles,
              'weather': _weatherAlerts,
              'shop': _shopPromos,
              'system': _systemSecurity,
            }
          }),
        );
      }
    } catch (e) {
      // Background sync failed, ignore
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
        title: Text(
          'Pengaturan Notifikasi',
          style: GoogleFonts.inter(
            color: const Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          _buildSectionHeader('Notifikasi Push'),
          _buildSwitchTile(
            title: 'Jeda Semua',
            subtitle: 'Mematikan semua notifikasi untuk sementara',
            value: _pauseAll,
            onChanged: (val) {
              setState(() {
                _pauseAll = val;
                // If pause all is true, we visually might want to disable others, 
                // but for simplicity we just save the state.
              });
              _savePreference('notif_pause_all', val);
            },
            isDestructive: true,
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Kategori Notifikasi'),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                _buildSwitchTile(
                  title: 'Berita & Artikel',
                  subtitle: 'Notifikasi untuk berita pertanian terbaru',
                  value: _newsArticles,
                  onChanged: _pauseAll ? null : (val) {
                    setState(() => _newsArticles = val);
                    _savePreference('notif_news', val);
                  },
                ),
                const Divider(height: 1, indent: 16),
                _buildSwitchTile(
                  title: 'Peringatan Cuaca',
                  subtitle: 'Notifikasi jika ada perubahan cuaca drastis',
                  value: _weatherAlerts,
                  onChanged: _pauseAll ? null : (val) {
                    setState(() => _weatherAlerts = val);
                    _savePreference('notif_weather', val);
                  },
                ),
                const Divider(height: 1, indent: 16),
                _buildSwitchTile(
                  title: 'Promo Toko',
                  subtitle: 'Notifikasi penawaran produk pertanian di toko',
                  value: _shopPromos,
                  onChanged: _pauseAll ? null : (val) {
                    setState(() => _shopPromos = val);
                    _savePreference('notif_shop', val);
                  },
                ),
                const Divider(height: 1, indent: 16),
                _buildSwitchTile(
                  title: 'Sistem & Keamanan',
                  subtitle: 'Notifikasi mengenai akun dan pembaruan sistem',
                  value: _systemSecurity,
                  onChanged: _pauseAll ? null : (val) {
                    setState(() => _systemSecurity = val);
                    _savePreference('notif_system', val);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF64748B),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
    bool isDestructive = false,
  }) {
    return Container(
      color: Colors.white,
      child: SwitchListTile(
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1E293B),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: const Color(0xFF64748B),
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: isDestructive ? Colors.red : const Color(0xFF22C55E),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}
