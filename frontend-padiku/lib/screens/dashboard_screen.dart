import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../widgets/rice_plant_widget.dart';
import '../widgets/fade_in_slide.dart';
import 'news_list_screen.dart';
import 'news_detail_screen.dart';
import 'guide_screen.dart';
import 'shop_screen.dart';
import 'weather_detail_screen.dart';
import 'history_screen.dart';
import 'notification_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _showWelcomePopup = false;
  int _popupPageIndex = 0;
  
  List<dynamic> _trendingNews = [];
  bool _isLoadingNews = true;
  
  // Weather state
  String _currentCity = 'Karawang';
  String _currentProvince = 'Jawa Barat';
  String? _currentLat;
  String? _currentLon;
  String _weatherTemp = '--';
  String _weatherDesc = 'Memuat cuaca...';
  String _weatherIcon = '01d';
  bool _isLoadingWeather = true;
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    // Mempercepat jeda awal agar tidak terlalu lama
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _showWelcomePopup = true);
    });
    _fetchTrendingNews();
    _startLocationTracking();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _startLocationTracking() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _fetchWeather();
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _fetchWeather();
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        _fetchWeather();
        return;
      }

      // Initial position
      try {
        Position initialPos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 15),
        );
        await _handlePositionUpdate(initialPos, isInitial: true);
      } catch (e) {
        _fetchWeather();
      }

      // Start stream for live tracking
      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // Update jika pindah minimal 5 meter
      );

      _positionStreamSubscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
        _handlePositionUpdate(position, isInitial: false);
      });
    } catch (e) {
      _fetchWeather();
    }
  }

  Future<void> _handlePositionUpdate(Position position, {bool isInitial = false}) async {
    // Logika Penyaringan Data (Agar Peta Tidak "Lompat-Lompat")
    // Abaikan data jika tingkat akurasi (radius error) lebih besar dari 25 meter
    if (position.accuracy > 25.0 && !isInitial) {
      return;
    }

    // Sensor dan Sumber Data: Abaikan jika data lokasi merupakan Fake/Mock GPS
    if (position.isMocked) {
      return;
    }

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        
        // Simpan data sederhana untuk UI Cuaca
        String city = place.subAdministrativeArea ?? place.locality ?? 'Karawang';
        String province = place.administrativeArea ?? 'Jawa Barat';
        city = city.replaceAll('Kabupaten ', '').replaceAll('Kota ', '');
        
        // Simpan data alamat sedetail mungkin untuk Admin Panel
        List<String> detailedParts = [];
        if (place.street != null && place.street!.isNotEmpty) detailedParts.add(place.street!);
        if (place.subLocality != null && place.subLocality!.isNotEmpty) detailedParts.add(place.subLocality!);
        if (place.locality != null && place.locality!.isNotEmpty) detailedParts.add(place.locality!);
        if (place.subAdministrativeArea != null && place.subAdministrativeArea!.isNotEmpty) {
          detailedParts.add(place.subAdministrativeArea!.replaceAll('Kabupaten ', '').replaceAll('Kota ', ''));
        }
        if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) detailedParts.add(place.administrativeArea!);
        
        String locationStr = detailedParts.isNotEmpty ? detailedParts.join(', ') : (place.country ?? 'Lokasi ditemukan');

        if (mounted) {
          setState(() {
            _currentCity = city;
            _currentProvince = province;
            _currentLat = position.latitude.toString();
            _currentLon = position.longitude.toString();
          });
        }

        try {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');
          if (token != null) {
            var request = http.MultipartRequest('POST', Uri.parse('http://192.168.100.56:8000/api/user/update'));
            request.headers.addAll({
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            });
            request.fields['location'] = locationStr;
            request.fields['latitude'] = position.latitude.toString();
            request.fields['longitude'] = position.longitude.toString();
            await request.send();
          }
        } catch (e) {
           // ignore
        }
      }
    } catch (e) {
      // Fallback
    }
    
    if (isInitial) {
      _fetchWeather();
    }
  }

  Future<void> _fetchWeather() async {
    try {
      String url = 'http://192.168.100.56:8000/api/weather?city=$_currentCity';
      if (_currentLat != null && _currentLon != null) {
        url += '&lat=$_currentLat&lon=$_currentLon';
      }
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          if (mounted) {
            setState(() {
              _weatherTemp = data['data']['temperature'].toString();
              _weatherDesc = data['data']['description'];
              _weatherIcon = data['data']['icon'];
              _isLoadingWeather = false;
            });
          }
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingWeather = false);
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isLoadingNews = true;
      _isLoadingWeather = true;
    });
    
    // Panggil API dengan param refresh=1
    final fetchNews = http.get(Uri.parse('http://192.168.100.56:8000/api/news?refresh=1'));
    
    String weatherUrl = 'http://192.168.100.56:8000/api/weather?city=$_currentCity&refresh=1';
    if (_currentLat != null && _currentLon != null) {
      weatherUrl += '&lat=$_currentLat&lon=$_currentLon';
    }
    final fetchWeather = http.get(Uri.parse(weatherUrl));
    
    try {
      final results = await Future.wait([fetchNews, fetchWeather]);
      
      // Proses News
      if (results[0].statusCode == 200) {
        final data = jsonDecode(results[0].body);
        if (data['success'] == true && mounted) {
          final List<dynamic> allNews = data['data'];
          setState(() {
            _trendingNews = allNews.take(3).toList();
            _isLoadingNews = false;
          });
        }
      }
      
      // Proses Weather
      if (results[1].statusCode == 200) {
        final data = jsonDecode(results[1].body);
        if (data['success'] == true && mounted) {
          setState(() {
            _weatherTemp = data['data']['temperature'].toString();
            _weatherDesc = data['data']['description'];
            _weatherIcon = data['data']['icon'];
            _isLoadingWeather = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingNews = false;
          _isLoadingWeather = false;
        });
      }
    }
  }

  Future<void> _fetchTrendingNews() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.100.56:8000/api/news'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final List<dynamic> allNews = data['data'];
          if (mounted) {
            setState(() {
              // Ambil 3 berita saja untuk halaman utama
              _trendingNews = allNews.take(3).toList();
              _isLoadingNews = false;
            });
          }
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingNews = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: RefreshIndicator(
                  color: AppTheme.primaryGreen,
                  backgroundColor: Colors.white,
                  onRefresh: _handleRefresh,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 22),
                        DelayedFadeInSlide(
                          delay: const Duration(milliseconds: 100),
                          child: _buildQuickMenu(),
                        ),
                        const SizedBox(height: 20),
                        DelayedFadeInSlide(
                          delay: const Duration(milliseconds: 200),
                          child: _buildScanBanner(),
                        ),
                        const SizedBox(height: 24),
                        DelayedFadeInSlide(
                          delay: const Duration(milliseconds: 300),
                          child: _buildNewsSection(),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: _showWelcomePopup ? _buildWelcomeOverlay() : const SizedBox.shrink(),
          ),
        ],
      ),
    ));
  }

  // ────────────────────────────────────────────────────────────
  // Header
  // ────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 28,
      ),
      decoration: const BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x331B5E20),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // PADIKU logo
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'PAD',
                style: GoogleFonts.outfit(
                  color: AppTheme.gold,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.5,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: RicePlantWidget(height: 42, width: 24),
              ),
              Text(
                'KU',
                style: GoogleFonts.outfit(
                  color: AppTheme.gold,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.5,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Right icons
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Weather
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => WeatherDetailScreen(
                    temp: _weatherTemp,
                    desc: _weatherDesc,
                    iconId: _weatherIcon,
                    city: _currentCity,
                    province: _currentProvince,
                    lat: _currentLat,
                    lon: _currentLon,
                  )),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      _isLoadingWeather
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Image.network(
                              'https://openweathermap.org/img/wn/$_weatherIcon.png',
                              width: 24, height: 24,
                              errorBuilder: (_, __, ___) => const Icon(Icons.wb_sunny_rounded, color: Colors.amber, size: 22),
                            ),
                      const SizedBox(width: 6),
                      Text(
                        '$_weatherTemp°C',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HistoryScreen()),
                ),
                child: _headerIcon(Icons.history_rounded),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationScreen()),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _headerIcon(Icons.notifications_rounded),
                    Positioned(
                      right: 2,
                      top: 2,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.primaryGreen, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }

  // ────────────────────────────────────────────────────────────
  // Quick Menu  (Toko · Berita · Panduan)
  // ────────────────────────────────────────────────────────────
  Widget _buildQuickMenu() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _menuItem(
            child: Image.asset('assets/images/store.png', width: 42, height: 42, fit: BoxFit.contain),
            label: 'Toko',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ShopScreen()),
            ),
          ),
          _menuItem(
            child: Image.asset('assets/images/berita.png', width: 44, height: 44, fit: BoxFit.contain),
            label: 'Berita',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NewsListScreen()),
            ),
          ),
          _menuItem(
            child: Image.asset('assets/images/padi.png', width: 40, height: 40, fit: BoxFit.contain),
            label: 'Panduan',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GuideScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem({
    required Widget child,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.primaryGreen.withValues(alpha: 0.1), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Center(child: child),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppTheme.primaryGreen,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  // Scan Banner
  // ────────────────────────────────────────────────────────────
  Widget _buildScanBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: AppTheme.accentGradient,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryGreen.withValues(alpha: 0.25),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Yuk, Scan Kesehatan Padimu!',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Deteksi cepat hama padi, rawat sawah jadi mudah, panen makin mantap!',
                    style: GoogleFonts.outfit(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 13,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    elevation: 4,
                    shadowColor: Colors.black26,
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                        child: Text(
                          'Scan Sekarang',
                          style: GoogleFonts.outfit(
                            color: AppTheme.primaryGreen,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Hero(
              tag: 'ai_illustration',
              child: Image.asset('assets/images/AI.png', width: 100, height: 100, fit: BoxFit.contain),
            ),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  // News / Trending
  // ────────────────────────────────────────────────────────────
  Widget _buildNewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trending',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryGreen,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NewsListScreen()),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Lihat Semua',
                      style: TextStyle(
                          color: AppTheme.primaryGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_circle_right_outlined, color: Colors.orange, size: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _isLoadingNews
        ? const Center(child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(color: AppTheme.primaryGreen),
          ))
        : ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _trendingNews.length,
          itemBuilder: (_, i) => _newsCard(_trendingNews[i]),
        ),
      ],
    );
  }

  Widget _newsCard(dynamic item) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NewsDetailScreen(newsData: item as Map<String, dynamic>),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 110,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppTheme.lightGreen,
                  ),
                  child: Image.network(
                    item['image'] ?? 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=200&fit=crop',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.image_outlined,
                      color: AppTheme.primaryGreen,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            (item['source'] ?? 'Berita').toUpperCase(),
                            style: const TextStyle(
                              color: AppTheme.orange,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item['pubDate'] ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['title'] ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  // Welcome Popup (Multi-State PageView)
  // ────────────────────────────────────────────────────────────
  Widget _buildWelcomeOverlay() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64),
          child: AspectRatio(
            aspectRatio: 2288 / 1856, // Match the exact dimensions of screen.png
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Render explicitly with smooth AnimatedSwitcher
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: _popupPageIndex == 0
                      // Slide 1: Welcome (Custom Graphic)
                      ? ClipRRect(
                          key: const ValueKey('slide1'),
                          borderRadius: BorderRadius.circular(24),
                          child: Image.asset(
                            'assets/images/screen.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryGreen,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: const Center(
                                child: Icon(Icons.image_not_supported_rounded, color: Colors.white, size: 48),
                              ),
                            ),
                          ),
                        )
                      // Slide 2: Weather Forecast
                      : Container(
                          key: const ValueKey('slide2'),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGreen,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: _buildWeatherIntro(),
                        ),
                ),
                // Close button overlaid on top right
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () {
                      if (_popupPageIndex == 0) {
                        setState(() => _popupPageIndex = 1);
                      } else {
                        setState(() => _showWelcomePopup = false);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.black26, 
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Pure widget for the Weather layout to keep it clean
  Widget _buildWeatherIntro() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: _isLoadingWeather
                    ? const SizedBox(width: 40, height: 40, child: CircularProgressIndicator(color: AppTheme.gold))
                    : Image.network(
                        'https://openweathermap.org/img/wn/$_weatherIcon@2x.png',
                        width: 54, height: 54,
                        errorBuilder: (_, __, ___) => const Icon(Icons.wb_sunny_rounded, color: AppTheme.gold, size: 54),
                      ),
              ),
              const SizedBox(height: 16),
              FittedBox(
                child: Text(
                  '$_weatherTemp°C',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _weatherDesc,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Saran: Penanaman & pemupukan di pagi hari untuk hasil maksimal.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
