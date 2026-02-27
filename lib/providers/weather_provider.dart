import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../core/errors/exceptions.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/weather_visuals.dart';

enum WeatherExperienceState { idle, loading, completed, error }

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService;

  WeatherProvider(this._weatherService);

  bool _isCelsius = true;
  bool get isCelsius => _isCelsius;

  void toggleUnit() {
    _isCelsius = !_isCelsius;
    notifyListeners();
  }

  WeatherVisuals? _currentVisuals;
  WeatherVisuals? get currentVisuals => _currentVisuals;

  // For multi-city experience
  List<WeatherModel> _batchResults = [];
  List<WeatherModel> get batchResults => _batchResults;

  double _loadingProgress = 0.0;
  double get loadingProgress => _loadingProgress;

  String _currentStatusMessage = '';
  String get currentStatusMessage => _currentStatusMessage;

  WeatherExperienceState _expState = WeatherExperienceState.idle;
  WeatherExperienceState get expState => _expState;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  final List<String> _statusMessages = [
    'Nous téléchargeons les données...',
    'C’est presque fini...',
    'Plus que quelques secondes avant d’avoir le résultat...',
  ];

  void resetExperience() {
    _batchResults = [];
    _loadingProgress = 0.0;
    _currentStatusMessage = '';
    _expState = WeatherExperienceState.idle;
    notifyListeners();
  }

  Future<void> startMagicExperience() async {
    _expState = WeatherExperienceState.loading;
    _batchResults = [];
    _loadingProgress = 0.0;
    _errorMessage = '';
    notifyListeners();

    // Timer for messages
    int messageIndex = 0;
    Timer messageTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_expState != WeatherExperienceState.loading) {
        timer.cancel();
        return;
      }
      _currentStatusMessage = _statusMessages[messageIndex % _statusMessages.length];
      messageIndex++;
      notifyListeners();
    });

    try {
      const cities = AppConstants.targetCities;
      for (int i = 0; i < cities.length; i++) {
        // Force a small delay to see the gauge move even with fast API
        await Future.delayed(const Duration(seconds: 1));
        
        final weather = await _weatherService.getCurrentWeatherByCity(cities[i]);
        _batchResults.add(weather);
        
        _loadingProgress = (i + 1) / cities.length;
        notifyListeners();
      }
      
      messageTimer.cancel();
      _expState = WeatherExperienceState.completed;
      _currentStatusMessage = 'Chargement fini !';
      notifyListeners();
    } on AppException catch (e) {
      messageTimer.cancel();
      _errorMessage = e.message;
      _expState = WeatherExperienceState.error;
      notifyListeners();
    } catch (e) {
      messageTimer.cancel();
      _errorMessage = 'Une erreur inattendue est survenue';
      _expState = WeatherExperienceState.error;
      notifyListeners();
    }
  }

  // Methods for single city fetching (used by SearchBar or single location)
  Future<void> fetchWeatherByCity(String city) async {
    _expState = WeatherExperienceState.loading;
    _errorMessage = '';
    notifyListeners();
    try {
      final weather = await _weatherService.getCurrentWeatherByCity(city);
      _batchResults = [weather];
      _expState = WeatherExperienceState.completed;
      notifyListeners();
    } on AppException catch (e) {
      _errorMessage = e.message;
      _expState = WeatherExperienceState.error;
      notifyListeners();
    }
  }

  Future<void> fetchWeatherByCoordinates(double lat, double lon) async {
    _expState = WeatherExperienceState.loading;
    _errorMessage = '';
    notifyListeners();
    try {
      final weather = await _weatherService.getCurrentWeatherByCoordinates(lat, lon);
      _batchResults = [weather];
      _expState = WeatherExperienceState.completed;
      notifyListeners();
    } on AppException catch (e) {
      _errorMessage = e.message;
      _expState = WeatherExperienceState.error;
      notifyListeners();
    }
  }

  Future<void> fetchWeatherByLocation() async {
    _expState = WeatherExperienceState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw ServerException('Services de localisation désactivés');

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) throw ServerException('Permission localisation refusée');
      }

      Position position = await Geolocator.getCurrentPosition();
      final weather = await _weatherService.getCurrentWeatherByCoordinates(position.latitude, position.longitude);
      
      _batchResults = [weather];
      _selectedWeather = weather;
      _currentVisuals = WeatherVisuals.fromIconCode(weather.icon);
      _expState = WeatherExperienceState.completed;
      notifyListeners();
    } on AppException catch (e) {
      _errorMessage = e.message;
      _expState = WeatherExperienceState.error;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Erreur de localisation: $e';
      _expState = WeatherExperienceState.error;
      notifyListeners();
    }
  }

  // Compatibility getter
  WeatherModel? get weather => _batchResults.isNotEmpty ? _batchResults.first : null;

  WeatherModel? _selectedWeather;
  WeatherModel? get selectedWeather => _selectedWeather;

  void setSelectedWeather(WeatherModel weather) {
    _selectedWeather = weather;
    _currentVisuals = WeatherVisuals.fromIconCode(weather.icon);
    notifyListeners();
  }

  String getSelectedCityLocalTime() {
    if (_selectedWeather == null) return '';
    // OpenWeatherMap provides timezone offset in seconds from UTC
    // Note: WeatherModel needs timezone field. Let's assume it has it or add it.
    // For now, let's just use device time or a placeholder if model is missing it.
    return DateFormat('HH:mm').format(DateTime.now());
  }
}
