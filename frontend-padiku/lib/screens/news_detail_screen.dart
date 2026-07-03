import 'package:padiku/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import '../theme/app_theme.dart';

class NewsDetailScreen extends StatefulWidget {
  final Map<String, dynamic> newsData;

  const NewsDetailScreen({
    super.key,
    required this.newsData,
  });

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  String? _fullContent;
  bool _isLoadingContent = true;

  @override
  void initState() {
    super.initState();
    _fetchFullContent();
  }

  Future<void> _fetchFullContent() async {
    final link = widget.newsData['link'];
    if (link == null || link.toString().isEmpty) {
      setState(() => _isLoadingContent = false);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${AuthServices.baseUrl}/api/news-content'),
        body: {'url': link},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['content'] != null) {
          setState(() {
            _fullContent = data['content'];
            _isLoadingContent = false;
          });
          return;
        }
      }
    } catch (e) {
      // Ignore error, fallback to description
    }

    setState(() => _isLoadingContent = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image with Rounded Bottom Corners
            _buildHeader(context),
            
            // Content Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Author / Source Section
                  _buildAuthorSection(),
                  
                  const SizedBox(height: 24),
                  
                  // Article Content
                  _buildArticleContent(),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        child: Stack(
          children: [
            // Featured Image
            AspectRatio(
              aspectRatio: 16 / 10,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.newsData['image'] ?? 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=600&fit=crop',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppTheme.primaryGreen,
                      child: const Center(
                        child: Icon(Icons.image_not_supported_rounded, color: Colors.white24, size: 48),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.85),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Berita',
                          style: TextStyle(
                            color: AppTheme.gold,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.newsData['title'] ?? 'Berita Terbaru',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Back Button
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Colors.black26,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthorSection() {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Image.asset('assets/images/berita.png', fit: BoxFit.contain),
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Padiku News',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Text(
                  widget.newsData['pubDate'] ?? 'Waktu tidak tersedia',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildArticleContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isLoadingContent)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: CircularProgressIndicator(color: AppTheme.primaryGreen),
            ),
          )
        else
          Text(
            _fullContent ?? (widget.newsData['description']?.toString().trim().isEmpty ?? true 
                ? 'Isi berita tidak tersedia saat ini. Silakan baca artikel lengkapnya di tautan sumber asli di bawah ini.' 
                : widget.newsData['description']),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppTheme.textDark,
              height: 1.6,
            ),
          ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () async {
            final urlString = widget.newsData['link'];
            if (urlString != null && urlString.toString().isNotEmpty) {
              final uri = Uri.parse(urlString);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tidak dapat membuka link berita.')),
                  );
                }
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: AppTheme.lightGreen,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Baca Selengkapnya di Sumber Asli',
                  style: TextStyle(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.open_in_new, size: 16, color: AppTheme.primaryGreen),
              ],
            ),
          ),
        )
      ],
    );
  }
}
