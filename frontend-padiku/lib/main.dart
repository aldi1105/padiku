import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const PadikuApp());
}

class PadikuApp extends StatelessWidget {
  const PadikuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PADIKU',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
