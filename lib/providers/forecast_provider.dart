import 'package:flutter/material.dart';
import '../models/forecast_model.dart';
import '../services/weather_service.dart';
import '../core/errors/exceptions.dart';

enum WeatherState { loading, success, error }

class ForecastProvider extends ChangeNotifier {
  final WeatherService _weatherService;

  ForecastProvider(this._weatherService);

  ForecastModel? _forecast;
  ForecastModel? get forecast => _forecast;

  WeatherState _state = WeatherState.loading;
  WeatherState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> fetchForecast(String city) async {
    _setLoading();
    try {
      _forecast = await _weatherService.getForecastByCity(city);
      _state = WeatherState.success;
      notifyListeners();
    } on AppException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('Une erreur inattendue est survenue');
    }
  }

  void _setLoading() {
    _state = WeatherState.loading;
    _errorMessage = '';
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _state = WeatherState.error;
    notifyListeners();
  }
}
