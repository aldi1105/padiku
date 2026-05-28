import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'route_screen.dart';

class ShopDetailScreen extends StatelessWidget {
  final Map<String, String> shopData;

  const ShopDetailScreen({super.key, required this.shopData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Image with Back Button
            Stack(
              children: [
                Hero(
                  tag: 'shop_img_${shopData['name']}',
                  child: Image.network(
                    shopData['img']!,
                    width: double.infinity,
                    height: 350,
                    fit: BoxFit.cover,
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shop Name
                  Text(
                    shopData['name']!,
                    style: GoogleFonts.outfit(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Rating and Distance
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        shopData['rating']!,
                        style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.grey),
                      ),
                      const SizedBox(width: 12),
                      const Text('|', style: TextStyle(color: Colors.grey)),
                      const SizedBox(width: 12),
                      const Icon(Icons.location_on, color: Colors.orange, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        shopData['dist']!,
                        style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.grey),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Address
                  Text(
                    'Jl. Surotokunto No.97, Adiarsa Tim., Kec. Karawang Tim., Karawang, Jawa Barat 41313',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: Colors.black38,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Phone Number
                  Text(
                    '+(62) 858-8432-4099',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.orange,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Operational Hours
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.primaryGreen.withValues(alpha: 0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jam Operasional',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: Colors.black26,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '08.00 - 21.00',
                          style: GoogleFonts.outfit(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Route Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RouteScreen(shopData: shopData),
                          ),
                        );
                      },
                      icon: const Icon(Icons.near_me_rounded, color: Colors.white),
                      label: const Text('Rute'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        textStyle: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
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
