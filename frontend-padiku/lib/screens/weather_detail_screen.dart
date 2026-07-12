import 'package:padiku/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class WeatherDetailScreen extends StatefulWidget {
  final String temp;
  final String desc;
  final String iconId;
  final String city;
  final String province;
  final String? lat;
  final String? lon;

  const WeatherDetailScreen({
    super.key,
    required this.temp,
    required this.desc,
    required this.iconId,
    required this.city,
    required this.province,
    this.lat,
    this.lon,
  });

  @override
  State<WeatherDetailScreen> createState() => _WeatherDetailScreenState();
}

class _WeatherDetailScreenState extends State<WeatherDetailScreen> {
  final DraggableScrollableController _sheetController = DraggableScrollableController();
  bool _isExpanded = false;
  List<dynamic> _dailyForecastData = [];
  List<dynamic> _hourlyForecastData = [];
  bool _isLoadingForecast = true;

  @override
  void initState() {
    super.initState();
    _fetchForecast();
    _sheetController.addListener(() {
      if (_sheetController.isAttached) {
        if (_sheetController.size > 0.5 && !_isExpanded) {
          setState(() => _isExpanded = true);
        } else if (_sheetController.size <= 0.5 && _isExpanded) {
          setState(() => _isExpanded = false);
        }
      }
    });
  }

  Future<void> _fetchForecast() async {
    try {
      String url = '${AuthServices.baseUrl}/api/weather-forecast?city=${widget.city}';
      if (widget.lat != null && widget.lon != null) {
        url += '&lat=${widget.lat}&lon=${widget.lon}';
      }
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && mounted) {
          setState(() {
            _dailyForecastData = data['data']['daily'] ?? [];
            _hourlyForecastData = data['data']['hourly'] ?? [];
          });
        }
      }
    } catch (e) {
      // ignore
    } finally {
      if (mounted) setState(() => _isLoadingForecast = false);
    }
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  void _toggleSheet() {
    if (_sheetController.isAttached) {
      if (_isExpanded) {
        _sheetController.animateTo(
          0.3,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _sheetController.animateTo(
          0.85,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryGreen,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // Background Content
              Column(
                children: [
                  // Header
                  _buildHeader(context),
                  
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Main Weather Info
                          _buildMainWeather(),
                          
                          const SizedBox(height: 20),
                          
                          // High/Low Info
                          _buildHighLowInfo(),
                          
                          const SizedBox(height: 30),
                          
                          // Hourly Forecast
                          _buildHourlyForecast(),
                          
                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              // Draggable Sheet for 7 Day Forecast
              _buildDraggableSheet(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.city}, ${widget.province}',
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Text(
                DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now()),
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainWeather() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration from OWM
          Expanded(
            child: Center(
              child: Image.network(
                'http://openweathermap.org/img/wn/${widget.iconId}@4x.png',
                width: 150,
                height: 150,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.wb_sunny_rounded, size: 120, color: AppTheme.gold),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.temp}°',
                  style: GoogleFonts.outfit(
                    fontSize: 80,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                Text(
                  widget.desc,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighLowInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _tempCapsule('Tertinggi: 35°C')),
          const SizedBox(width: 12),
          Expanded(child: _tempCapsule('Terendah: 24°C')),
        ],
      ),
    );
  }

  Widget _tempCapsule(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppTheme.textDark,
          ),
        ),
      ),
    );
  }

  Widget _buildHourlyForecast() {
    if (_isLoadingForecast) {
      return const SizedBox(
        height: 130,
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (_hourlyForecastData.isEmpty) {
      return const SizedBox(
        height: 130,
        child: Center(child: Text('Data per jam tidak tersedia', style: TextStyle(color: Colors.white))),
      );
    }

    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _hourlyForecastData.length,
        itemBuilder: (context, index) {
          final data = _hourlyForecastData[index];
          // Gunakan warna hijau gelap untuk semua kecuali jam saat ini (index 0) yang pakai hijau terang
          final color = index == 0 ? const Color(0xFF4CAF50) : const Color(0xFF2E7D32);

          return Container(
            width: 70,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data['time'],
                  style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
                const SizedBox(height: 10),
                Image.network(
                  'http://openweathermap.org/img/wn/${data['icon']}@2x.png',
                  width: 30,
                  height: 30,
                  errorBuilder: (_, __, ___) => const Icon(Icons.cloud, color: Colors.white, size: 28),
                ),
                const SizedBox(height: 10),
                Text(
                  '${data['temperature']}°C',
                  style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDraggableSheet() {
    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: 0.3, 
      minChildSize: 0.3,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            color: Color(0xFF0D4D11),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            border: Border(
              top: BorderSide(color: Colors.white, width: 2),
              left: BorderSide(color: Colors.white, width: 2),
              right: BorderSide(color: Colors.white, width: 2),
            ),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              // Header Section (Clickable & Draggable)
              GestureDetector(
                onTap: _toggleSheet,
                behavior: HitTestBehavior.opaque,
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      width: 50,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Perkiraan 5 Hari Ke Depan',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              // Forecast Cards
              if (_isLoadingForecast)
                const Center(child: CircularProgressIndicator(color: Colors.white))
              else if (_dailyForecastData.isEmpty)
                const Center(child: Text('Gagal memuat perkiraan cuaca', style: TextStyle(color: Colors.white)))
              else
                ..._dailyForecastData.map((day) {
                  final date = DateTime.parse(day['date']);
                  final dayName = DateFormat('EEEE', 'id_ID').format(date);
                  final isToday = day['date'] == DateFormat('yyyy-MM-dd').format(DateTime.now());
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _dailyForecastCard(
                      isToday ? 'Hari Ini' : dayName,
                      'http://openweathermap.org/img/wn/${day['icon']}@2x.png',
                      '${day['temperature']}°C',
                      day['description'],
                      isToday,
                    ),
                  );
                }),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _dailyForecastCard(String day, String iconUrl, String temp, String status, bool isHighlighted) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isHighlighted ? const Color(0xFF28C72D) : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              day,
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isHighlighted ? Colors.white : AppTheme.textDark,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Image.network(
                iconUrl,
                width: 40,
                height: 40,
                errorBuilder: (_, __, ___) => const Icon(Icons.cloud, color: Colors.grey),
              ),
            ),
          ),
          Expanded(
            child: Text(
              temp,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isHighlighted ? Colors.white : AppTheme.textDark,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              status,
              textAlign: TextAlign.right,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isHighlighted ? Colors.white : AppTheme.textDark.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
