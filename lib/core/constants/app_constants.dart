class AppConstants {
  static const String appName = 'Météo Magique';
  static const String defaultCity = 'Dakar';
  
  static const List<String> senegalCities = [
    'Dakar',
    'Saint-Louis',
    'Thiès',
    'Ziguinchor',
    'Touba'
  ];

  static const List<String> worldCities = [
    'Paris',
    'Tokyo',
    'New York',
    'Londres',
    'Dubaï'
  ];

  static const List<String> targetCities = senegalCities; // Default
  
  static const String apiKeyEnvVar = 'OPENWEATHER_API_KEY';
  static const String googleMapsKeyEnvVar = 'GOOGLE_MAPS_API_KEY';
}
