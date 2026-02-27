import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/weather_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/lottie_weather_icon.dart';
import '../../widgets/premium_gauge_painter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(AppConstants.appName, style: Theme.of(context).appBarTheme.titleTextStyle),
        actions: [
          Consumer<WeatherProvider>(
            builder: (context, provider, _) => TextButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                provider.toggleUnit();
              },
              child: Text(
                provider.isCelsius ? '°C' : '°F',
                style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Consumer<WeatherProvider>(
            builder: (context, provider, _) => IconButton(
              icon: Icon(
                provider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: Colors.white,
              ),
              onPressed: () {
                HapticFeedback.mediumImpact();
                provider.toggleTheme();
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.my_location, color: Colors.white),
            onPressed: () {
              HapticFeedback.heavyImpact();
              context.read<WeatherProvider>().fetchWeatherByLocation();
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pushReplacementNamed(context, '/welcome');
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
            colors: provider.isDarkMode 
              ? [
                  const Color(0xFF0F172A),
                  AppTheme.primaryColor.withValues(alpha: 0.4),
                  const Color(0xFF1E293B),
                ]
              : [
                  const Color(0xFFF1F5F9),
                  AppTheme.primaryColor.withValues(alpha: 0.1),
                  const Color(0xFFE2E8F0),
                ],
          ),
        ),
        child: SafeArea(
          child: Consumer<WeatherProvider>(
            builder: (context, provider, child) {
              switch (provider.expState) {
                case WeatherExperienceState.idle:
                  return _buildIdleState(context, provider);
                case WeatherExperienceState.loading:
                  return _buildLoadingState(provider);
                case WeatherExperienceState.completed:
                  return _buildCompletedState(context, provider);
                case WeatherExperienceState.error:
                  return ErrorDisplayWidget(
                    message: provider.errorMessage,
                    onRetry: () => provider.startMagicExperience(),
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildIdleState(BuildContext context, WeatherProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.auto_awesome, size: 80, color: Colors.purpleAccent),
          const SizedBox(height: 32),
          Text(
            'Choisissez votre destination',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFilterChip(
                context, 
                'Sénégal', 
                RegionFilter.senegal, 
                provider
              ),
              const SizedBox(width: 12),
              _buildFilterChip(
                context, 
                'Reste du monde', 
                RegionFilter.world, 
                provider
              ),
            ],
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () => provider.startMagicExperience(),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              backgroundColor: AppTheme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              'Lancer la Récupération',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, 
    String label, 
    RegionFilter filter, 
    WeatherProvider provider,
    {VoidCallback? onChanged}
  ) {
    final isSelected = provider.selectedRegion == filter;
    return GestureDetector(
      onTap: () {
        if (isSelected) return;
        HapticFeedback.selectionClick();
        provider.setRegion(filter);
        onChanged?.call();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppTheme.primaryColor.withValues(alpha: 0.3) 
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
                ? AppTheme.primaryColor 
                : Colors.white.withValues(alpha: 0.1),
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            color: isSelected ? Colors.white : Colors.white60,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(WeatherProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Initialisation de la magie...',
              style: GoogleFonts.outfit(
                fontSize: 24, 
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ).animate().fadeIn().slideY(begin: -0.2),
            const SizedBox(height: 64),
            // Premium Gauge
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 240,
                  height: 240,
                  child: CustomPaint(
                    painter: PremiumGaugePainter(
                      progress: provider.loadingProgress,
                      primaryColor: AppTheme.primaryColor,
                      secondaryColor: AppTheme.secondaryColor,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(provider.loadingProgress * 100).toInt()}%',
                      style: GoogleFonts.outfit(
                        fontSize: 48, 
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                    Text(
                      'COMPLÉTÉ',
                      style: GoogleFonts.outfit(
                        fontSize: 12, 
                        letterSpacing: 2,
                        color: Colors.white54
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 80),
            GlassCard(
              opacity: 0.05,
              blur: 10,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Text(
                provider.currentStatusMessage,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 16, 
                  fontStyle: FontStyle.italic,
                  color: Colors.white.withValues(alpha: 0.9)
                ),
              ).animate(key: ValueKey(provider.currentStatusMessage)).fadeIn().slideY(begin: 0.1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedState(BuildContext context, WeatherProvider provider) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFilterChip(
              context, 
              'Sénégal', 
              RegionFilter.senegal, 
              provider,
              onChanged: () => provider.startMagicExperience(),
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              context, 
              'Monde', 
              RegionFilter.world, 
              provider,
              onChanged: () => provider.startMagicExperience(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'EXPÉRIENCE TERMINÉE !',
          style: GoogleFonts.outfit(
            fontSize: 22, 
            fontWeight: FontWeight.bold, 
            color: AppTheme.accentColor,
            letterSpacing: 1.5
          ),
        ).animate().shake().shimmer(),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: provider.batchResults.length,
            itemBuilder: (context, index) {
              final weather = provider.batchResults[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      provider.setSelectedWeather(weather);
                      Navigator.pushNamed(context, '/detail');
                    },
                    borderRadius: BorderRadius.circular(24),
                    child: GlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      opacity: 0.1,
                      blur: 10,
                      child: Row(
                        children: [
                          Hero(
                            tag: 'icon_${weather.cityName}',
                            child: LottieWeatherIcon(iconCode: weather.icon, size: 60),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  weather.cityName,
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  weather.description.toUpperCase(),
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.orangeAccent,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
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
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ),
                ),
              ).animate(delay: (index * 100).ms).fadeIn().slideX(begin: 0.2);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: ElevatedButton.icon(
            onPressed: () => provider.resetExperience(),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('RECOMMENCER L\'AVENTURE'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 60),
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
              ),
              elevation: 0,
            ),
          ),
        ).animate(delay: 600.ms).fadeIn(),
      ],
    );
  }
}
