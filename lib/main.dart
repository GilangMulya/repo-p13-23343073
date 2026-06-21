import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const SmartFocusTrackerApp());
}

class SmartFocusTrackerApp extends StatelessWidget {
  const SmartFocusTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Focus Tracker',
      debugShowCheckedModeBanner:
          false, // Menghilangkan pita "DEBUG" di pojok kanan atas
      theme: appTheme(), // Mengambil tema dari theme.dart
      home: const LoginScreen(), // Memulai aplikasi dari layar Login
    );
  }
}
