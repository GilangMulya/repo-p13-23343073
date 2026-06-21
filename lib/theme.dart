import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(
    0xFF13131A,
  ); // Biru dongker/hitam sangat gelap
  static const Color cardDark = Color(0xFF1C1C24); // Abu-abu gelap untuk card
  static const Color primary = Color(0xFF7A61E3); // Ungu neon
  static const Color textWhite = Colors.white;
  static const Color textGrey = Color(0xFF9E9E9E);
  static const Color success = Color(0xFF4CAF50); // Hijau
  static const Color danger = Color(0xFFF44336); // Merah
}

ThemeData appTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      surface: AppColors.cardDark,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: false,
    ),
  );
}
