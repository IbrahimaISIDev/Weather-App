import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF673AB7);
  static const Color secondaryColor = Color(0xFF03A9F4);
  static const Color accentColor = Color(0xFFFFD700);

  // Dark Theme Colors
  static const Color darkBg = Color(0xFF0F172A);
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkText = Colors.white;

  // Light Theme Colors
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightCard = Colors.white;
  static const Color lightText = Color(0xFF0F172A);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkBg,
      cardTheme: const CardTheme(
        color: darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          color: darkText,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(color: darkText, fontWeight: FontWeight.bold, fontSize: 36),
        displayMedium: GoogleFonts.outfit(color: darkText, fontWeight: FontWeight.bold, fontSize: 28),
        bodyLarge: GoogleFonts.inter(color: darkText, fontSize: 16),
        bodyMedium: GoogleFonts.inter(color: darkText.withValues(alpha: 0.7), fontSize: 14),
        labelLarge: GoogleFonts.outfit(color: secondaryColor, fontWeight: FontWeight.w600, fontSize: 14),
      ),
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: darkCard,
        onSurface: darkText,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: lightBg,
      cardTheme: CardTheme(
        color: lightCard,
        elevation: 2,
        shadowColor: primaryColor.withValues(alpha: 0.1),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: primaryColor),
        titleTextStyle: GoogleFonts.outfit(
          color: lightText,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(color: lightText, fontWeight: FontWeight.bold, fontSize: 36),
        displayMedium: GoogleFonts.outfit(color: lightText, fontWeight: FontWeight.bold, fontSize: 28),
        bodyLarge: GoogleFonts.inter(color: lightText, fontSize: 16),
        bodyMedium: GoogleFonts.inter(color: lightText.withValues(alpha: 0.7), fontSize: 14),
        labelLarge: GoogleFonts.outfit(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 14),
      ),
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: lightCard,
        onSurface: lightText,
      ),
    );
  }
}
