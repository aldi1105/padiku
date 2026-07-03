import 'package:padiku/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../widgets/rice_plant_widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<dynamic> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        setState(() => isLoading = false);
        return;
      }

      final response = await http.get(
        Uri.parse('${AuthServices.baseUrl}/api/user/notifications'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          setState(() {
            notifications = data['data'];
            isLoading = false;
          });
        }
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _markAsRead(String id, int index) async {
    // Optimistic UI update
    setState(() {
      notifications[index]['isNew'] = false;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      await http.post(
        Uri.parse('${AuthServices.baseUrl}/api/user/notifications/$id/read'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
    } catch (e) {
      // Revert if failed
      setState(() {
        notifications[index]['isNew'] = true;
      });
    }
  }

  Future<void> _deleteNotification(String id, int index) async {
    // Store removed item in case of failure
    final removedItem = notifications[index];
    setState(() {
      notifications.removeAt(index);
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      final response = await http.delete(
        Uri.parse('${AuthServices.baseUrl}/api/user/notifications/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete');
      }
    } catch (e) {
      // Revert if failed
      setState(() {
        notifications.insert(index, removedItem);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus notifikasi')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen))
                : notifications.isEmpty
                    ? Center(
                        child: Text(
                          'Tidak ada notifikasi.',
                          style: GoogleFonts.outfit(color: Colors.black54),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final item = notifications[index];
                          return _buildNotificationItem(item, index);
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

  Widget _buildNotificationItem(Map<String, dynamic> item, int index) {
    return GestureDetector(
      onTap: () {
        if (item['isNew']) {
          _markAsRead(item['id'].toString(), index);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(12),
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
            const SizedBox(width: 12),
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
            const SizedBox(width: 8),
            // Time & Menu
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item['time'],
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black45,
                  ),
                ),
                SizedBox(
                  height: 30,
                  width: 30,
                  child: PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.more_vert, color: Colors.black45, size: 20),
                    onSelected: (value) {
                      if (value == 'read') {
                        _markAsRead(item['id'].toString(), index);
                      } else if (value == 'delete') {
                        _deleteNotification(item['id'].toString(), index);
                      }
                    },
                    itemBuilder: (context) => [
                      if (item['isNew'])
                        PopupMenuItem(
                          value: 'read',
                          child: Text('Tandai Dibaca', style: GoogleFonts.outfit(fontSize: 14)),
                        ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('Hapus', style: GoogleFonts.outfit(fontSize: 14, color: Colors.red)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
