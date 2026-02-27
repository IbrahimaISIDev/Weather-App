import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/weather_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/lottie_weather_icon.dart';

class CityDetailScreen extends StatelessWidget {
  const CityDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    final weather = provider.selectedWeather;
    final visuals = provider.currentVisuals;

    if (weather == null) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: const Center(child: Text('Aucune donnée sélectionnée')),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Column(
          children: [
            Text(weather.cityName),
            Text(
              provider.getSelectedCityLocalTime(),
              style: GoogleFonts.inter(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: visuals?.gradientColors ?? [
              const Color(0xFF0F172A),
              AppTheme.primaryColor.withValues(alpha: 0.4),
              const Color(0xFF1E293B),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: 'temp_${weather.cityName}',
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              provider.isCelsius 
                                  ? '${weather.temp.round()}°C'
                                  : '${(weather.temp * 9/5 + 32).round()}°F',
                              style: GoogleFonts.outfit(
                                fontSize: 64, 
                                fontWeight: FontWeight.w200, 
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        Text(
                          weather.description.toUpperCase(),
                          style: GoogleFonts.outfit(
                            fontSize: 16, 
                            fontWeight: FontWeight.bold, 
                            color: AppTheme.accentColor,
                            letterSpacing: 2
                          ),
                        ),
                      ],
                    ),
                    Hero(
                      tag: 'icon_${weather.cityName}',
                      child: LottieWeatherIcon(iconCode: weather.icon, size: 120),
                    ),
                  ],
                ).animate().fadeIn().slideX(begin: -0.1),
                
                const SizedBox(height: 32),
                
                // Weather Details Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                  children: [
                    _buildPremiumDetail(Icons.water_drop, '${weather.humidity}%', 'Humidité'),
                    _buildPremiumDetail(Icons.air, '${weather.wind.speed} km/h', 'Vent'),
                    _buildPremiumDetail(Icons.thermostat, '${weather.feelsLike.round()}°C', 'Ressenti'),
                    _buildPremiumDetail(Icons.visibility, '${(weather.visibility / 1000).toStringAsFixed(1)} km', 'Visibilité'),
                  ],
                ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.9, 0.9)),

                const SizedBox(height: 32),

                // Temperature Chart (Sparkline)
                Text(
                  'TENDANCE TEMPÉRATURE',
                  style: GoogleFonts.outfit(
                    fontSize: 14, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.white54,
                    letterSpacing: 1.5
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 100,
                  child: GlassCard(
                    padding: const EdgeInsets.all(12),
                    opacity: 0.1,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: const FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              const FlSpot(0, 18),
                              const FlSpot(1, 22),
                              const FlSpot(2, 21),
                              FlSpot(3, weather.temp),
                              const FlSpot(4, 25),
                              const FlSpot(5, 23),
                            ],
                            isCurved: true,
                            color: AppTheme.secondaryColor,
                            barWidth: 3,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: AppTheme.secondaryColor.withValues(alpha: 0.2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 400.ms),

                const SizedBox(height: 32),

                // Map Section
                Text(
                  'LOCALISATION PRÉCISE',
                  style: GoogleFonts.outfit(
                    fontSize: 14, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.white54,
                    letterSpacing: 1.5
                  ),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: SizedBox(
                    height: 250,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(weather.coord.lat, weather.coord.lon),
                        zoom: 12,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId(weather.cityName),
                          position: LatLng(weather.coord.lat, weather.coord.lon),
                        ),
                      },
                      zoomControlsEnabled: false,
                      mapToolbarEnabled: false,
                    ),
                  ),
                ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumDetail(IconData icon, String value, String label) {
    return GlassCard(
      opacity: 0.1,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppTheme.secondaryColor, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 18, 
              fontWeight: FontWeight.bold, 
              color: Colors.white
            ),
          ),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12, 
              color: Colors.white54
            ),
          ),
        ],
      ),
    );
  }
}
