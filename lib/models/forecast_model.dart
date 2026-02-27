import 'package:json_annotation/json_annotation.dart';
import 'weather_model.dart';

part 'forecast_model.g.dart';

@JsonSerializable()
class ForecastModel {
  @JsonKey(name: 'list')
  final List<ForecastItem> list;

  @JsonKey(name: 'city')
  final CityInfo city;

  ForecastModel({
    required this.list,
    required this.city,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) => _$ForecastModelFromJson(json);
  Map<String, dynamic> toJson() => _$ForecastModelToJson(this);
}

@JsonSerializable()
class ForecastItem {
  @JsonKey(name: 'dt_txt')
  final String dateTime;

  @JsonKey(name: 'main')
  final MainWeatherData main;

  @JsonKey(name: 'weather')
  final List<WeatherDescription> weather;

  ForecastItem({
    required this.dateTime,
    required this.main,
    required this.weather,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> json) => _$ForecastItemFromJson(json);
  Map<String, dynamic> toJson() => _$ForecastItemToJson(this);
  
  String get description => weather.isNotEmpty ? weather[0].description : '';
  String get icon => weather.isNotEmpty ? weather[0].icon : '';
}

@JsonSerializable()
class CityInfo {
  final String name;
  final Coordinates coord;

  CityInfo({required this.name, required this.coord});

  factory CityInfo.fromJson(Map<String, dynamic> json) => _$CityInfoFromJson(json);
  Map<String, dynamic> toJson() => _$CityInfoToJson(this);
}
