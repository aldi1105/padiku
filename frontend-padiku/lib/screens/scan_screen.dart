import 'dart:ui';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import '../theme/app_theme.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => ScanScreenState();
}

class ScanScreenState extends State<ScanScreen> {
  bool isScanning = false;
  File? _image;
  String _scanResult = "";
  
  CameraController? _cameraController;
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _cameraController = CameraController(
          cameras.first,
          ResolutionPreset.medium,
          enableAudio: false,
        );
        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint("Camera initialization error: $e");
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> takePictureAndScan() async {
    if (!isCameraInitialized || _cameraController == null || _cameraController!.value.isTakingPicture) return;

    try {
      final XFile image = await _cameraController!.takePicture();
      
      setState(() {
        _image = File(image.path);
        isScanning = true;
        _scanResult = "";
      });
      
      await _cameraController!.pausePreview();

      // Ubah gambar ke base64
      final bytes = await _image!.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Konfigurasi endpoint Groq LLaVA / Vision
      final url = Uri.parse('https://api.groq.com/openai/v1/chat/completions');
      const apiKey = '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';

      // Request ke AI
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'llama-3.2-90b-vision-preview',
          'messages': [
            {
              'role': 'user',
              'content': [
                {
                  'type': 'text', 
                  'text': 'Bertindaklah sebagai ahli pertanian padi. Tolong identifikasi apakah daun tanaman padi di gambar ini sehat atau memiliki penyakit. Jika berpenyakit, sebutkan nama penyakitnya (contoh: Tungro, Hawar Daun Bakteri, Bercak Coklat, dll) dan berikan 1 kalimat solusinya dalam bahasa Indonesia.'
                },
                {
                  'type': 'image_url',
                  'image_url': {
                    'url': 'data:image/jpeg;base64,$base64Image',
                  }
                }
              ]
            }
          ],
          'temperature': 0.4,
          'max_tokens': 150
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final answer = data['choices'][0]['message']['content'];
        
        setState(() {
          _scanResult = answer;
          isScanning = false;
        });
        
        // Menampilkan Hasil AI
        _showResultDialog(answer);
      } else {
        setState(() {
          isScanning = false;
          // Capture the exact error from Groq API
          _scanResult = "Gagal memindai (Error ${response.statusCode})\nDetail: ${response.body}";
        });
        _showResultDialog(_scanResult);
      }
    } catch (e) {
      setState(() {
        isScanning = false;
        _scanResult = "Terjadi kesalahan jaringan.";
      });
      _showResultDialog(_scanResult);
    }
  }

  void _showResultDialog(String result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.psychology, color: AppTheme.primaryGreen),
            const SizedBox(width: 8),
            Text('Hasil Analisis AI', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(
            result, 
            style: GoogleFonts.inter(fontSize: 14, height: 1.5, color: Colors.black87),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _image = null;
                isScanning = false;
              });
              _cameraController?.resumePreview();
            },
            child: const Text('Tutup', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera Feed or Image
            Positioned.fill(
              child: _image != null
                  ? Image.file(_image!, fit: BoxFit.cover)
                  : (isCameraInitialized && _cameraController != null)
                      ? CameraPreview(_cameraController!)
                      : const Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen)),
            ),
            
            // Focus Frame Overlay
            if (!isScanning && _image == null)
              Positioned.fill(
                child: CustomPaint(
                  painter: FocusFramePainter(),
                ),
              ),

            // Top Gradient & Text (Ayo Pindai Padi Kamu)
            if (!isScanning && _image == null)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.only(top: 40, bottom: 60),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
                    ),
                  ),
                  child: Text(
                    'Ayo Pindai\nPadi Kamu',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Shutter Button
            if (!isScanning && _image == null)
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: takePictureAndScan,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        color: Colors.transparent,
                      ),
                      child: Center(
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // Scanning AI Overlay
            if (isScanning) ...[
              Positioned.fill(
                child: Container(color: Colors.black.withValues(alpha: 0.4)),
              ),
              Center(
                child: ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.2),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.6),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Memindai AI...',
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.5),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],

            // Close Button
            Positioned(
              top: 16,
              left: 16,
              child: GestureDetector(
                onTap: () {
                  if (isScanning) {
                    setState(() {
                      isScanning = false;
                      _image = null;
                    });
                    _cameraController?.resumePreview();
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter for the Camera Focus Frame
class FocusFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final double width = size.width;
    final double height = size.height;
    
    // Focus box dimensions
    final double boxWidth = width * 0.7;
    final double boxHeight = boxWidth;
    
    final double left = (width - boxWidth) / 2;
    final double top = (height - boxHeight) / 2;
    
    final double cornerLength = 30.0;

    // Top Left
    canvas.drawLine(Offset(left, top), Offset(left + cornerLength, top), paint);
    canvas.drawLine(Offset(left, top), Offset(left, top + cornerLength), paint);

    // Top Right
    canvas.drawLine(Offset(left + boxWidth, top), Offset(left + boxWidth - cornerLength, top), paint);
    canvas.drawLine(Offset(left + boxWidth, top), Offset(left + boxWidth, top + cornerLength), paint);

    // Bottom Left
    canvas.drawLine(Offset(left, top + boxHeight), Offset(left + cornerLength, top + boxHeight), paint);
    canvas.drawLine(Offset(left, top + boxHeight), Offset(left, top + boxHeight - cornerLength), paint);

    // Bottom Right
    canvas.drawLine(Offset(left + boxWidth, top + boxHeight), Offset(left + boxWidth - cornerLength, top + boxHeight), paint);
    canvas.drawLine(Offset(left + boxWidth, top + boxHeight), Offset(left + boxWidth, top + boxHeight - cornerLength), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
