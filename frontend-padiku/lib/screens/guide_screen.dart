import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/rice_plant_widget.dart';
import '../widgets/fade_in_slide.dart';
import 'guide_detail_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  String _activeCategory = 'Semua';

  final Map<String, String> _categoryHeaderImages = {
    'Padi': 'http://192.168.100.56:8000/storage/backgrounds/padi_bg.jpg',
    'Hama': 'http://192.168.100.56:8000/storage/backgrounds/hama_bg.jpg',
  };

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRiceVarieties();
  }

  Future<void> _fetchRiceVarieties() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.100.56:8000/api/rice-varieties'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> varieties = data['data'];
        
        String _getImageForGroup(String group) {
          final g = group.toLowerCase();
          if (g.contains('gogo')) return 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=600&fit=crop';
          if (g.contains('rawa')) return 'https://images.unsplash.com/photo-1530507629858-e4977d30e9e0?w=600&fit=crop';
          if (g.contains('hibrida')) return 'https://images.unsplash.com/photo-1628352081506-83c43123ed6d?w=600&fit=crop';
          if (g.contains('lokal')) return 'https://images.unsplash.com/photo-1590602847861-f357a9332bbc?w=600&fit=crop';
          if (g.contains('khusus')) return 'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=600&fit=crop';
          return 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=600&fit=crop';
        }

        final List<Map<String, String>> fetchedPadi = varieties.map<Map<String, String>>((v) => {
          'id': v['code']?.toString() ?? '',
          'title': (v['name']?.toString() ?? '').toLowerCase().startsWith('padi') 
              ? v['name']?.toString() ?? ''
              : 'Padi ${v['name']?.toString() ?? ''}',
          'category': 'Padi',
          'imageUrl': (v['image'] != null && v['image'].toString().isNotEmpty) 
              ? 'http://192.168.100.56:8000/storage/${v['image']}'
              : _getImageForGroup(v['group']?.toString() ?? ''),
          'description': 'Kelompok: ${v['group'] ?? '-'}\nEkosistem: ${v['ecosystem'] ?? '-'}\nPotensi Hasil: ${v['yield_potential'] ?? '-'} Ton/Ha\nUmur Tanaman: ${v['plant_age'] ?? '-'} Hari\nTekstur Nasi: ${v['texture'] ?? '-'}\nKetahanan Hama: ${v['pest_resistance'] ?? '-'}\nRekomendasi: ${v['region_recommendation'] ?? '-'}',
          'metric1_title': 'Potensi Hasil',
          'metric1_value': '${v['yield_potential'] ?? '-'} Ton/Ha',
          'metric2_title': 'Umur Tanaman',
          'metric2_value': '${v['plant_age'] ?? '-'} Hari',
          'metric3_title': 'Tekstur Nasi',
          'metric3_value': v['texture']?.toString() ?? '-',
        }).toList();

        // Fetch Hama (Diseases)
        final hamaResponse = await http.get(Uri.parse('http://192.168.100.56:8000/api/diseases'));
        List<Map<String, String>> fetchedHama = [];
        if (hamaResponse.statusCode == 200) {
          final hamaData = json.decode(hamaResponse.body);
          final List<dynamic> diseases = hamaData['data'];
          fetchedHama = diseases.map<Map<String, String>>((d) => {
            'id': 'h_${d['id']}',
            'title': d['name']?.toString() ?? '',
            'category': 'Hama',
            'imageUrl': (d['image'] != null && d['image'].toString().isNotEmpty)
                ? 'http://192.168.100.56:8000/storage/${d['image']}'
                : 'https://images.unsplash.com/photo-1585314062340-f1a5a7c9328d?w=800&fit=crop',
            'description': '${d['description'] ?? '-'}\n\nSolusi:\n${d['solution'] ?? '-'}',
            'metric1_title': 'Tingkat Bahaya',
            'metric1_value': 'Tinggi',
            'metric2_title': 'Siklus Hidup',
            'metric2_value': 'Cepat',
            'metric3_title': 'Penyebaran',
            'metric3_value': 'Masif',
          }).toList();
        }

        if (mounted) {
          setState(() {
            _allGuides.clear(); // Hapus semua hardcoded data
            _allGuides.addAll(fetchedPadi);
            if (fetchedHama.isNotEmpty) _allGuides.addAll(fetchedHama);
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Error fetching varieties: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  final List<Map<String, String>> _allGuides = [
    {
      'id': 'p1',
      'title': 'Padi Sawah',
      'category': 'Padi',
      'imageUrl': 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=400&fit=crop',
      'description': 'Padi sawah merupakan jenis padi yang ditanam di lahan tergenang air. Membutuhkan irigasi yang stabil dan pengolahan tanah yang intensif untuk hasil maksimal.',
    },
    {
      'id': 'p2',
      'title': 'Padi Ladang',
      'category': 'Padi',
      'imageUrl': 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=400&fit=crop',
      'description': 'Padi ladang atau padi gogo ditanam di lahan kering tanpa penggenangan air. Jenis ini lebih tahan terhadap kekeringan namun membutuhkan pemilihan benih yang tepat.',
    },
    {
      'id': 'p3',
      'title': 'Padi Hibrida',
      'category': 'Padi',
      'imageUrl': 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=401&fit=crop',
      'description': 'Padi hibrida adalah varietas hasil persilangan yang memiliki keunggulan heterosis, seperti produktivitas lebih tinggi dan ketahanan penyakit yang lebih baik.',
    },
    {
      'id': 'p4',
      'title': 'Padi Inbrida',
      'category': 'Padi',
      'imageUrl': 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=401&fit=crop',
      'description': 'Varietas padi yang dikembangkan dari galur murni. Sangat stabil dalam mewariskan sifat unggul dari generasi ke generasi.',
    },
    {
      'id': 'p5',
      'title': 'Padi Organik',
      'category': 'Padi',
      'imageUrl': 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=402&fit=crop',
      'description': 'Padi yang dibudidayakan secara alami tanpa bahan kimia sintetis. Lebih sehat dan bernilai jual tinggi di pasaran.',
    },
    {
      'id': 'p6',
      'title': 'Padi Ketan',
      'category': 'Padi',
      'imageUrl': 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=402&fit=crop',
      'description': 'Jenis beras yang memiliki kandungan amilopektin tinggi sehingga sangat lengket setelah dimasak. Banyak digunakan untuk jajanan pasar.',
    },
    {
      'id': 'h1',
      'title': 'Wereng Cokelat',
      'category': 'Hama',
      'imageUrl': 'https://images.unsplash.com/photo-1585314062340-f1a5a7c9328d?w=400&fit=crop',
      'description': 'Hama wereng cokelat menghisap cairan batang padi, menyebabkan tanaman menguning dan mati (hopperburn). Sangat berbahaya karena bisa menularkan virus.',
    },
    {
      'id': 'h2',
      'title': 'Wereng Hijau',
      'category': 'Hama',
      'imageUrl': 'https://images.unsplash.com/photo-1585314062340-f1a5a7c9328d?w=401&fit=crop',
      'description': 'Wereng hijau adalah vektor utama penyakit Tungro. Mengendalikan populasi wereng hijau sejak dini sangat penting untuk mencegah gagal panen.',
    },
    {
      'id': 'h3',
      'title': 'Gabus/Siput Murbai',
      'category': 'Hama',
      'imageUrl': 'https://images.unsplash.com/photo-1585314062340-f1a5a7c9328d?w=402&fit=crop',
      'description': 'Siput murbei atau keong mas menyerang batang padi muda yang baru ditanam. Pengendalian bisa dilakukan secara manual maupun hayati.',
    },
    {
      'id': 'h4',
      'title': 'Walang Sangit',
      'category': 'Hama',
      'imageUrl': 'https://images.unsplash.com/photo-1585314062340-f1a5a7c9328d?w=403&fit=crop',
      'description': 'Hama pengisap bulir padi pada fase masak susu. Menyebabkan beras yang dihasilkan menjadi hampa atau berwana kecokelatan dan berbau.',
    },
    {
      'id': 'h5',
      'title': 'Penggerek Batang',
      'category': 'Hama',
      'imageUrl': 'https://images.unsplash.com/photo-1585314062340-f1a5a7c9328d?w=404&fit=crop',
      'description': 'Larva hama ini memakan dan merusak jaringan bagian dalam batang padi (sundep pada fase vegetatif, beluk pada fase generatif).',
    },
    {
      'id': 'h6',
      'title': 'Tikus Sawah',
      'category': 'Hama',
      'imageUrl': 'https://images.unsplash.com/photo-1585314062340-f1a5a7c9328d?w=405&fit=crop',
      'description': 'Hama pengerat yang merusak sangat cepat pada semua stadium pertumbuhan padi. Dapat menyebabkan gagal panen total.',
    },
  ];

  List<Map<String, String>> get _padiGuides =>
      _allGuides.where((item) => item['category'] == 'Padi').toList();

  List<Map<String, String>> get _hamaGuides =>
      _allGuides.where((item) => item['category'] == 'Hama').toList();

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      switchInCurve: Curves.easeOutQuart,
      switchOutCurve: Curves.easeInQuart,
      transitionBuilder: (child, animation) {
        // Create a delayed entrance for the new child
        final delayedAnimation = CurvedAnimation(
          parent: animation,
          curve: const Interval(0.3, 1.0, curve: Curves.easeOutQuart),
        );

        return FadeTransition(
          opacity: delayedAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -0.2), // More pronounced slide
              end: Offset.zero,
            ).animate(delayedAnimation),
            child: child,
          ),
        );
      },
      child: _activeCategory == 'Semua'
          ? _buildSemuaView(context)
          : _buildCategorizedView(context),
    );
  }

  Widget _buildSemuaView(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildBrandingHeader(context),
          _buildCategoryFilter(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchRiceVarieties,
              color: AppTheme.primaryGreen,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DelayedFadeInSlide(
                    delay: const Duration(milliseconds: 200),
                    child: _sectionHeader(
                      title: 'Jenis Padi',
                      onTap: () => setState(() => _activeCategory = 'Padi'),
                    ),
                  ),
                  DelayedFadeInSlide(
                    delay: const Duration(milliseconds: 300),
                    child: _buildPadiCarousel(),
                  ),
                  const SizedBox(height: 16),
                  DelayedFadeInSlide(
                    delay: const Duration(milliseconds: 400),
                    child: _sectionHeader(
                      title: 'Jenis Hama',
                      onTap: () => setState(() => _activeCategory = 'Hama'),
                    ),
                  ),
                  DelayedFadeInSlide(
                    delay: const Duration(milliseconds: 500),
                    child: _buildHamaCarousel(),
                  ),
                ],
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorizedView(BuildContext context) {
    final items = _activeCategory == 'Padi' ? _padiGuides : _hamaGuides;
    final headerImage = _categoryHeaderImages[_activeCategory]!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Fixed Image Header
          Stack(
            children: [
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(headerImage),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Text(
                        'Jenis-Jenis $_activeCategory',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          shadows: [Shadow(color: Colors.black45, blurRadius: 10)],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Back Button on Image
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                left: 20,
                child: GestureDetector(
                  onTap: () => setState(() => _activeCategory = 'Semua'),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
                    ),
                    child: const Icon(Icons.arrow_back_rounded, color: AppTheme.gold, size: 24),
                  ),
                ),
              ),
            ],
          ),
          
          // Fixed Category Filter
          _buildCategoryFilter(),
          
          // Scrollable Grid View
          Expanded(
            child: DelayedFadeInSlide(
              delay: const Duration(milliseconds: 200),
              child: RefreshIndicator(
                onRefresh: _fetchRiceVarieties,
                color: AppTheme.primaryGreen,
                child: GridView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: _activeCategory == 'Padi' ? 0.72 : 0.68,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _activeCategory == 'Padi' ? _padiCard(item, 'grid') : _hamaCard(item, 'grid');
                },
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final categories = ['Semua', 'Padi', 'Hama'];
    final activeIndex = categories.indexOf(_activeCategory);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: DelayedFadeInSlide(
        delay: const Duration(milliseconds: 100),
        child: Container(
          height: 52,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final pillWidth = (width / 3) - 2;

              return Stack(
                children: [
                  // Individual background pills with AnimatedOpacity and Scale for 'fading' effect
                  Row(
                    children: categories.map((cat) {
                      final isActive = _activeCategory == cat;
                      return Expanded(
                        child: AnimatedScale(
                          scale: isActive ? 1.0 : 0.9,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutCubic,
                          child: AnimatedOpacity(
                            opacity: isActive ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                            child: Container(
                              margin: const EdgeInsets.all(2), // Slight inward margin
                              decoration: BoxDecoration(
                                color: AppTheme.primaryGreen,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  // Button labels
                  Row(
                    children: categories.map((cat) {
                      final isActive = _activeCategory == cat;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _activeCategory = cat),
                          behavior: HitTestBehavior.opaque,
                          child: Center(
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeInOut,
                              style: GoogleFonts.outfit(
                                color: isActive ? Colors.white : Colors.grey.shade500,
                                fontWeight: isActive ? FontWeight.w900 : FontWeight.w700,
                                fontSize: 14,
                              ),
                              child: Text(cat),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBrandingHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 14,
        left: 20,
        right: 20,
        bottom: 24,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.primaryGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
              ),
              child: const Icon(Icons.arrow_back_rounded, color: AppTheme.gold, size: 24),
            ),
          ),
          
          // Logo
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'PAD',
                style: TextStyle(
                  color: AppTheme.gold,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: RicePlantWidget(height: 38, width: 22),
              ),
              Text(
                'KU',
                style: TextStyle(
                  color: AppTheme.gold,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          
          // Invisible spacer to balance the back button
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _sectionHeader({required String title, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppTheme.primaryGreen,
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Text(
                  'Lihat Semua',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_circle_right_outlined,
                  color: AppTheme.gold,
                  size: 28,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // _categoryChip is no longer used, logic moved to _buildCategoryFilter context
  Widget _unused_categoryChip({required String label}) {
    return const SizedBox();
  }

  Widget _buildPadiCarousel() {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _padiGuides.length,
        itemBuilder: (context, index) {
          final item = _padiGuides[index];
          return _padiCard(item, 'carousel');
        },
      ),
    );
  }

  Widget _padiCard(Map<String, String> item, String heroPrefix) {
    return Container(
      width: 190,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: '$heroPrefix-${item['id']}',
              child: Image.network(
                item['imageUrl']!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade100),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppTheme.primaryGreen.withValues(alpha: 0.85),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title']!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GuideDetailScreen(
                            guide: item,
                            heroTag: '$heroPrefix-${item['id']}',
                          ),
                        ),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Text(
                            'Lihat Selengkapnya',
                            style: TextStyle(
                              color: AppTheme.primaryGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
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

  Widget _buildHamaCarousel() {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _hamaGuides.length,
        itemBuilder: (context, index) {
          final item = _hamaGuides[index];
          return _hamaCard(item, 'carousel');
        },
      ),
    );
  }

  Widget _hamaCard(Map<String, String> item, String heroPrefix) {
    return Container(
      width: 190,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Hero(
                tag: '$heroPrefix-${item['id']}',
                child: Image.network(
                  item['imageUrl']!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade100),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                color: AppTheme.primaryGreen.withValues(alpha: 0.9),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title']!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GuideDetailScreen(
                            guide: item,
                            heroTag: '$heroPrefix-${item['id']}',
                          ),
                        ),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Text(
                            'Lihat Selengkapnya',
                            style: TextStyle(
                              color: AppTheme.primaryGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
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
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _StickyHeaderDelegate({required this.child});

  @override
  double get minExtent => 90.0;
  @override
  double get maxExtent => 90.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) => false;
}
