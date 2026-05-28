import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class RouteScreen extends StatefulWidget {
  final Map<String, String> shopData;

  const RouteScreen({super.key, required this.shopData});

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  bool isNavigating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F4EC), // Light map background color
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Simulated Map Roads
          Positioned.fill(
            child: CustomPaint(
              painter: _MapRoadPainter(),
            ),
          ),
          
          // "Karawang Timur" Label
          Positioned(
            top: 340,
            left: 170,
            child: Text(
              'Karawang\nTimur',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
                height: 1.1,
              ),
            ),
          ),
          
          // "GURO II" Label
          Positioned(
            top: 400,
            left: 100,
            child: Text(
              'GURO II',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.black54,
                letterSpacing: 1.2,
              ),
            ),
          ),
          
          if (!isNavigating)
            // Blue Route Line
            Positioned.fill(
              child: CustomPaint(
                painter: _RouteLinePainter(),
              ),
            ),

          if (isNavigating)
            // Active Green Route Line
            Positioned.fill(
              child: CustomPaint(
                painter: _ActiveRoutePainter(),
              ),
            ),

          if (isNavigating)
            // Start Navigation Marker (Solid Green Dot)
            Positioned(
              top: 395,
              left: 45,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                  ]
                ),
              ),
            ),

          if (isNavigating)
            // Destination Aura
            Positioned(
              top: 450,
              left: 125,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),

          // Destination Marker (Green - Sumber Tani)
          Positioned(
            top: 490,
            left: 160,
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                    ]
                  ),
                  child: Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Sumber Tani',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          
          // Origin Marker (Red - PD. Tani Subur)
          Positioned(
            top: 450,
            left: 90,
            child: Row(
              children: [
                Text(
                  'PD. Tani Subur',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                    ]
                  ),
                  child: const Icon(Icons.storefront, color: Colors.white, size: 12),
                ),
                const SizedBox(width: 4),
                // Small red dot
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                    ]
                  ),
                  child: Center(
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Top Red Store (Dini Tani Kios Pupuk)
          if (isNavigating)
            Positioned(
              top: 100,
              right: 60,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                      ]
                    ),
                    child: const Icon(Icons.shopping_bag, color: Colors.white, size: 12),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Dini Tani Kios\nPupuk Resmi',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),

          // Summarecon Marker (Blue)
          Positioned(
            top: 550,
            right: 40,
            child: Row(
              children: [
                Text(
                  'Summarecon\nVillaggio Outlets',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueAccent,
                    height: 1.1,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                    ]
                  ),
                  child: const Icon(Icons.shopping_bag, color: Colors.white, size: 14),
                ),
              ],
            ),
          ),
          
          // School Marker (Grey)
          Positioned(
            top: 330,
            left: 310,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.blueGrey[400],
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                ]
              ),
              child: const Icon(Icons.school, color: Colors.white, size: 16),
            ),
          ),

          // Back Button
          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () {
                    if (isNavigating) {
                      setState(() {
                        isNavigating = false;
                      });
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                  ),
                ),
              ),
            ),
          ),

          // Bottom Sheet Card
          if (!isNavigating)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Shop Name
                      Text(
                        widget.shopData['name'] ?? 'Toko Sumber Tani',
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Rating and Distance
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.orange, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            widget.shopData['rating'] ?? '4.9 (700)',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text('|', style: TextStyle(color: Colors.grey[400])),
                          const SizedBox(width: 12),
                          const Icon(Icons.location_on, color: Colors.orange, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            widget.shopData['dist'] ?? '500 m',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Address
                      Text(
                        'Jl. Surotokunto No.97, Adiarsa Tim., Kec. Karawang Tim., Karawang, Jawa Barat 41313',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: Colors.grey[500],
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      const Divider(height: 1, color: Colors.black12),
                      
                      const SizedBox(height: 24),

                      // Time / Mode Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.electric_moped, color: AppTheme.primaryGreen),
                          label: Text(
                            '3 Menit',
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.primaryGreen,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: AppTheme.primaryGreen, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),

                      // Start Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              isNavigating = true;
                            });
                          },
                          icon: const Icon(Icons.turn_right_rounded, color: Colors.white, size: 28),
                          label: const Text('Mulai'),
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
              ),
            ),
        ],
      ),
    );
  }
}

class _MapRoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueGrey.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    final paintWhite = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;
      
    final paintThick = Paint()
      ..color = Colors.blueGrey.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round;

    // Road 1 (Top Left to Bottom Right)
    var path1 = Path();
    path1.moveTo(0, 150);
    path1.lineTo(150, 250);
    path1.lineTo(250, 350);
    path1.lineTo(300, 500);
    path1.lineTo(320, 600);
    
    canvas.drawPath(path1, paintThick);
    
    // Road 2 (Left to Center)
    var path2 = Path();
    path2.moveTo(0, 420);
    path2.lineTo(100, 450);
    path2.lineTo(180, 500);
    
    canvas.drawPath(path2, paint);
    canvas.drawPath(path2, paintWhite);
    
    // Road 3 (Small streets)
    var path3 = Path();
    path3.moveTo(100, 450);
    path3.lineTo(100, 550);
    path3.lineTo(50, 600);
    path3.moveTo(300, 500);
    path3.lineTo(380, 550);
    
    // Road 4 (Top Left Navigation route underlying road)
    path3.moveTo(30, 380);
    path3.lineTo(100, 450);
    
    canvas.drawPath(path3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RouteLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = Colors.blue.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;
      
    final paint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round;

    // Route from Red to Green marker
    var path = Path();
    path.moveTo(170, 455); // Red dot center
    path.quadraticBezierTo(180, 480, 175, 505); // Curve to green dot
    
    canvas.drawPath(path, borderPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ActiveRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = Colors.green.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
      
    final paint = Paint()
      ..color = Colors.green.shade500
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Active Navigation Route (Top Left Green dot to Bottom Right Green dot)
    var path = Path();
    path.moveTo(60, 410); // Start Green Dot
    path.lineTo(95, 435); 
    path.lineTo(90, 470);
    path.lineTo(150, 480);
    path.lineTo(175, 505); // End Green Dot
    
    canvas.drawPath(path, borderPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
