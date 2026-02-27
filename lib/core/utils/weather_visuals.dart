import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WeatherVisuals {
  final List<Color> gradientColors;
  final IconData? overlayIcon;
  final String weatherState;

  WeatherVisuals({
    required this.gradientColors,
    this.overlayIcon,
    required this.weatherState,
  });

  factory WeatherVisuals.fromIconCode(String code) {
    final isNight = code.endsWith('n');
    final baseCode = code.substring(0, 2);

    // Default Dark/Clear
    List<Color> colors = [
      const Color(0xFF0F172A),
      AppTheme.primaryColor.withValues(alpha: 0.4),
      const Color(0xFF1E293B),
    ];

    if (isNight) {
      colors = [
        const Color(0xFF020617),
        const Color(0xFF1E1B4B),
        const Color(0xFF0F172A),
      ];
    } else {
      switch (baseCode) {
        case '01': // Clear
          colors = [
            const Color(0xFF0EA5E9),
            const Color(0xFF38BDF8),
            const Color(0xFF7DD3FC),
          ];
          break;
        case '02': // Few clouds
        case '03': // Scattered
        case '04': // Broken
          colors = [
            const Color(0xFF64748B),
            const Color(0xFF94A3B8),
            const Color(0xFFCBD5E1),
          ];
          break;
        case '09': // Rain
        case '10': // Shower
          colors = [
            const Color(0xFF1E293B),
            const Color(0xFF334155),
            const Color(0xFF475569),
          ];
          break;
        case '11': // Thunderstorm
          colors = [
            const Color(0xFF020617),
            const Color(0xFF1E293B),
            const Color(0xFF000000),
          ];
          break;
        case '13': // Snow
          colors = [
            const Color(0xFFF1F5F9),
            const Color(0xFFE2E8F0),
            const Color(0xFFCBD5E1),
          ];
          break;
        case '50': // Mist
          colors = [
            const Color(0xFF475569),
            const Color(0xFF94A3B8),
            const Color(0xFFE2E8F0),
          ];
          break;
      }
    }

    return WeatherVisuals(
      gradientColors: colors,
      weatherState: baseCode,
    );
  }
}
