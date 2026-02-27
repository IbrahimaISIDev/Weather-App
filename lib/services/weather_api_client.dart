import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../core/constants/api_constants.dart';

part 'weather_api_client.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class WeatherApiClient {
  factory WeatherApiClient(Dio dio, {String baseUrl}) = _WeatherApiClient;

  @GET(ApiConstants.currentWeatherEndpoint)
  Future<WeatherModel> getCurrentWeatherByCity(@Query('q') String city);

  @GET(ApiConstants.currentWeatherEndpoint)
  Future<WeatherModel> getCurrentWeatherByCoordinates(
    @Query('lat') double lat,
    @Query('lon') double lon,
  );

  @GET(ApiConstants.forecastEndpoint)
  Future<ForecastModel> getForecastByCity(@Query('q') String city);
}
