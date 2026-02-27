import 'package:dio/dio.dart';
import 'weather_api_client.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../core/errors/exceptions.dart';

class WeatherService {
  final WeatherApiClient _apiClient;

  WeatherService(this._apiClient);

  Future<WeatherModel> getCurrentWeatherByCity(String city) async {
    try {
      return await _apiClient.getCurrentWeatherByCity(city);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ServerException('Erreur lors de la récupération de la météo');
    }
  }

  Future<WeatherModel> getCurrentWeatherByCoordinates(double lat, double lon) async {
    try {
      return await _apiClient.getCurrentWeatherByCoordinates(lat, lon);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ServerException('Erreur lors de la récupération de la météo');
    }
  }

  Future<ForecastModel> getForecastByCity(String city) async {
    try {
      return await _apiClient.getForecastByCity(city);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ServerException('Erreur lors de la récupération des prévisions');
    }
  }
}
