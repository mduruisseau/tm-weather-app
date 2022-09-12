import 'package:json_annotation/json_annotation.dart';
import 'package:weather_app/models/weather_current.dart';
import 'package:weather_app/models/weather_daily.dart';

part 'weather_data.g.dart';

@JsonSerializable()
class WeatherData {
  final double latitude;
  final double longitude;

  @JsonKey(name: 'generationtime_ms')
  final double generationTimeMs;
  final String timezone;
  @JsonKey(name: 'timezone_abbreviation')
  final String timezoneAbbreviation;
  final double elevation;

  @JsonKey(name: 'current_weather')
  final WeatherCurrent? currentWeather;

  final WeatherDaily? daily;

  WeatherData({
    required this.latitude,
    required this.longitude,
    required this.generationTimeMs,
    required this.timezone,
    required this.timezoneAbbreviation,
    required this.elevation,
    this.currentWeather,
    this.daily,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) =>
      _$WeatherDataFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherDataToJson(this);
}
