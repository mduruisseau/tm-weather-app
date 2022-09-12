import 'package:json_annotation/json_annotation.dart';

part 'weather_current.g.dart';

@JsonSerializable()
class WeatherCurrent {
  final double temperature;

  @JsonKey(name: 'windspeed')
  final double windSpeed;

  @JsonKey(name: 'winddirection')
  final double windDirection;

  @JsonKey(name: 'weathercode')
  final double weatherCode;

  WeatherCurrent({
    required this.temperature,
    required this.windSpeed,
    required this.windDirection,
    required this.weatherCode,
  });

  factory WeatherCurrent.fromJson(Map<String, dynamic> json) =>
      _$WeatherCurrentFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherCurrentToJson(this);
}
