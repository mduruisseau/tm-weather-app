import 'package:json_annotation/json_annotation.dart';

part 'weather_daily.g.dart';

@JsonSerializable()
class WeatherDaily {
  final List<String> time;

  @JsonKey(name: 'weathercode')
  final List<double>? weatherCode;

  @JsonKey(name: 'temperature_2m_min')
  final List<double>? temperature2mMin;

  @JsonKey(name: 'temperature_2m_max')
  final List<double>? temperature2mMax;

  WeatherDaily({
    required this.time,
    this.weatherCode,
    this.temperature2mMin,
    this.temperature2mMax,
  });

  factory WeatherDaily.fromJson(Map<String, dynamic> json) =>
      _$WeatherDailyFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherDailyToJson(this);
}
