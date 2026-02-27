import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../providers/forecast_provider.dart';
import '../../../providers/weather_provider.dart';
import '../../../widgets/loading_indicator.dart';
import '../../../widgets/error_widget.dart';
import 'widgets/forecast_tile.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  @override
  void initState() {
    super.initState();
    _fetchForecast();
  }

  void _fetchForecast() {
    final weatherProvider = context.read<WeatherProvider>();
    final cityName = weatherProvider.weather?.cityName;
    if (cityName != null) {
      context.read<ForecastProvider>().fetchForecast(cityName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<WeatherProvider>(
          builder: (context, weather, _) => Text(
            'Prévisions : ${weather.weather?.cityName ?? ""}',
          ),
        ),
      ),
      body: Consumer<ForecastProvider>(
        builder: (context, provider, child) {
          switch (provider.state) {
            case WeatherState.loading:
              return const LoadingIndicator(message: 'Chargement des prévisions...');
            case WeatherState.error:
              return ErrorDisplayWidget(
                message: provider.errorMessage,
                onRetry: _fetchForecast,
              );
            case WeatherState.success:
              final forecast = provider.forecast;
              if (forecast == null) return const Center(child: Text('Aucune donnée'));
              
              return ListView.builder(
                itemCount: forecast.list.length,
                itemBuilder: (context, index) {
                  return ForecastTile(item: forecast.list[index])
                      .animate()
                      .fadeIn(delay: (index * 50).ms)
                      .slideX(begin: 0.2);
                },
              );
          }
        },
      ),
    );
  }
}
