import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Brand Header & Nav
  static const Color primaryGreen = Color(0xFF0C5D37);
  static const Color primaryGreenDark = Color(0xFF08482A);
  static const Color primaryGreenLight = Color(0xFF147A49);
  static const Color navBarActivePill = Color(0xFF177448);

  // Logo colors
  static const Color logoDayRed = Color(0xFFE53935);
  static const Color logoFreshGreen = Color(0xFF22C55E);

  // Backgrounds
  static const Color scaffoldBackground = Color(0xFFF6F8F7);
  static const Color cardBackground = Colors.white;

  // Text
  static const Color textDark = Color(0xFF1A202C);
  static const Color textMuted = Color(0xFF718096);
  static const Color textLight = Color(0xFFA0AEC0);

  // Badges & Status
  static const Color priorityHighText = Color(0xFFEF4444);
  static const Color priorityHighBg = Color(0xFFFFECEC);

  static const Color priorityMedText = Color(0xFFF59E0B);
  static const Color priorityMedBg = Color(0xFFFFF7ED);

  static const Color priorityLowText = Color(0xFF10B981);
  static const Color priorityLowBg = Color(0xFFECFDF5);

  static const Color statusPendingText = Color(0xFFF97316);
  static const Color statusPendingBg = Color(0xFFFFF7ED);

  static const Color statusCompletedText = Color(0xFF10B981);
  static const Color statusCompletedBg = Color(0xFFECFDF5);

  // Card stats
  static const Color statTotal = Color(0xFF1A202C);
  static const Color statPending = Color(0xFFDC2626);
  static const Color statSubmitted = Color(0xFF16A34A);
  static const Color statProgress = Color(0xFF16A34A);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.scaffoldBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryGreen,
        primary: AppColors.primaryGreen,
        surface: AppColors.cardBackground,
      ),
      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
      textTheme: ThemeData.light().textTheme.apply(
        fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
        bodyColor: AppColors.textDark,
        displayColor: AppColors.textDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
        ),
        hintStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.textLight,
          fontSize: 14,
        ),
      ),
    );
  }
}
