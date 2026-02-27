import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../models/weather_model.dart';
import '../../../core/theme/app_theme.dart';

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryColor.withValues(alpha: 0.8),
              AppTheme.secondaryColor.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: Column(
          children: [
            Text(
              weather.cityName,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ).animate().fadeIn().slideY(begin: 0.2),
            const SizedBox(height: 8),
            Text(
              weather.description.toUpperCase(),
              style: const TextStyle(fontSize: 16, letterSpacing: 1.2),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  'https://openweathermap.org/img/wn/${weather.icon}@4x.png',
                  width: 100,
                  height: 100,
                ).animate().scale(delay: 200.ms),
                const SizedBox(width: 8),
                Text(
                  '${weather.temp.round()}°C',
                  style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w300),
                ).animate().fadeIn(delay: 300.ms),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem(Icons.water_drop, '${weather.humidity}%', 'Humidité'),
                _buildInfoItem(Icons.air, '${weather.wind.speed} km/h', 'Vent'),
                _buildInfoItem(Icons.thermostat, '${weather.feelsLike.round()}°C', 'Ressenti'),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.9, 0.9));
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.white70),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
      ],
    );
  }
}
