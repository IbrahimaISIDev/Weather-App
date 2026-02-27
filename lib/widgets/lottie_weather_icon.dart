import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieWeatherIcon extends StatelessWidget {
  final String iconCode;
  final double size;

  const LottieWeatherIcon({
    super.key,
    required this.iconCode,
    this.size = 100,
  });

  String _getLottieAsset(String code) {
    // Mapping OpenWeatherMap icon codes to Lottie animation URLs
    // Using reliable public URLs for demonstration
    final isNight = code.endsWith('n');
    final baseCode = code.substring(0, 2);

    switch (baseCode) {
      case '01': // Clear sky
        return isNight 
            ? 'https://assets10.lottiefiles.com/packages/lf20_xl86uclf.json' // Night
            : 'https://assets1.lottiefiles.com/private_files/lf30_moat7pkr.json'; // Sun
      case '02': // Few clouds
        return 'https://assets1.lottiefiles.com/private_files/lf30_on4s4mqr.json';
      case '03': // Scattered clouds
      case '04': // Broken clouds
        return 'https://assets1.lottiefiles.com/private_files/lf30_on4s4mqr.json';
      case '09': // Shower rain
      case '10': // Rain
        return 'https://assets1.lottiefiles.com/private_files/lf30_kj9m8u65.json';
      case '11': // Thunderstorm
        return 'https://assets1.lottiefiles.com/private_files/lf30_8as9vlvf.json';
      case '13': // Snow
        return 'https://assets1.lottiefiles.com/private_files/lf30_9vpvvrt8.json';
      case '50': // Mist
        return 'https://assets1.lottiefiles.com/private_files/lf30_on4s4mqr.json';
      default:
        return 'https://assets1.lottiefiles.com/private_files/lf30_moat7pkr.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Lottie.network(
        _getLottieAsset(iconCode),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.wb_cloudy_rounded,
          size: size * 0.6,
          color: Colors.white,
        ),
      ),
    );
  }
}
