import 'package:json_annotation/json_annotation.dart';

part 'weather_model.g.dart';

@JsonSerializable()
class WeatherModel {
  @JsonKey(name: 'name')
  final String cityName;

  @JsonKey(name: 'main')
  final MainWeatherData main;

  @JsonKey(name: 'weather')
  final List<WeatherDescription> weather;

  @JsonKey(name: 'wind')
  final WindData wind;

  @JsonKey(name: 'coord')
  final Coordinates coord;

  final int visibility;

  WeatherModel({
    required this.cityName,
    required this.main,
    required this.weather,
    required this.wind,
    required this.coord,
    required this.visibility,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) => _$WeatherModelFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherModelToJson(this);

  String get description => weather.isNotEmpty ? weather[0].description : '';
  String get icon => weather.isNotEmpty ? weather[0].icon : '';
  double get temp => main.temp;
  double get feelsLike => main.feelsLike;
  int get humidity => main.humidity;
}

@JsonSerializable()
class MainWeatherData {
  final double temp;
  @JsonKey(name: 'feels_like')
  final double feelsLike;
  final int humidity;
  final int pressure;

  MainWeatherData({
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    required this.pressure,
  });

  factory MainWeatherData.fromJson(Map<String, dynamic> json) => _$MainWeatherDataFromJson(json);
  Map<String, dynamic> toJson() => _$MainWeatherDataToJson(this);
}

@JsonSerializable()
class WeatherDescription {
  final String main;
  final String description;
  final String icon;

  WeatherDescription({
    required this.main,
    required this.description,
    required this.icon,
  });

  factory WeatherDescription.fromJson(Map<String, dynamic> json) => _$WeatherDescriptionFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherDescriptionToJson(this);
}

@JsonSerializable()
class WindData {
  final double speed;

  WindData({required this.speed});

  factory WindData.fromJson(Map<String, dynamic> json) => _$WindDataFromJson(json);
  Map<String, dynamic> toJson() => _$WindDataToJson(this);
}

@JsonSerializable()
class Coordinates {
  final double lat;
  final double lon;

  Coordinates({required this.lat, required this.lon});

  factory Coordinates.fromJson(Map<String, dynamic> json) => _$CoordinatesFromJson(json);
  Map<String, dynamic> toJson() => _$CoordinatesToJson(this);
}
