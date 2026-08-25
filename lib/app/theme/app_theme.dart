import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Brand Colors - Cyan & Teal Palette matching reference design
  static const Color primary = Color(0FF0D9488); // Deep Cyan/Teal
  static const Color primaryLight = Color(0FF2DD4BF); // Bright Teal Accent
  static const Color secondary = Color(0FF6366F1); // Soft Indigo Badge
  static const Color accent = Color(0FF38BDF8); // Electric Sky Blue

  // Light Mode Palette
  static const Color lightBackground = Color(0FFF8FAFC);
  static const Color lightSurface = Color(0FFFFFFFF);
  static const Color lightCardBorder = Color(0FFE2E8F0);
  static const Color lightTextPrimary = Color(0FF0F172A);
  static const Color lightTextSecondary = Color(0FF64748B);

  // Dark Mode Palette
  static const Color darkBackground = Color(0FF0F172A);
  static const Color darkSurface = Color(0FF1E293B);
  static const Color darkCardBorder = Color(0FF334155);
  static const Color darkTextPrimary = Color(0FFF8FAFC);
  static const Color darkTextSecondary = Color(0FF94A3B8);

  // System & Status Colors
  static const Color success = Color(0FF10B981);
  static const Color warning = Color(0FFF59E0B);
  static const Color error = Color(0FFEF4444);
}

class AppTheme {
  static ThemeData get lightTheme {
    final baseText = GoogleFonts.interTextTheme();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightTextPrimary,
        error: AppColors.error,
      ),
      cardTheme: CardTheme(
        color: AppColors.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.lightCardBorder, width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),
        titleTextStyle: GoogleFonts.inter(
          color: AppColors.lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      textTheme: baseText.copyWith(
        displayLarge: GoogleFonts.inter(
          color: AppColors.lightTextPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.inter(
          color: AppColors.lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: GoogleFonts.inter(
          color: AppColors.lightTextPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.inter(
          color: AppColors.lightTextPrimary,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.inter(
          color: AppColors.lightTextSecondary,
          fontSize: 14,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final baseText = GoogleFonts.interTextTheme(ThemeData.dark().textTheme);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryLight,
        secondary: AppColors.secondary,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkTextPrimary,
        error: AppColors.error,
      ),
      cardTheme: CardTheme(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.darkCardBorder, width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
        titleTextStyle: GoogleFonts.inter(
          color: AppColors.darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      textTheme: baseText.copyWith(
        displayLarge: GoogleFonts.inter(
          color: AppColors.darkTextPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.inter(
          color: AppColors.darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: GoogleFonts.inter(
          color: AppColors.darkTextPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.inter(
          color: AppColors.darkTextPrimary,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.inter(
          color: AppColors.darkTextSecondary,
          fontSize: 14,
        ),
      ),
    );
  }
}
