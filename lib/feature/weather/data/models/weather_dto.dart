import 'package:weather_today/feature/weather/data/utils/json_reader.dart';

import '../../domain/entities/weather.dart';

class WeatherDto {
  const WeatherDto({
    required this.cityName,
    required this.temperatureCelsius,
    required this.apparentTemperatureCelsius,
    required this.windSpeedKph,
    required this.weatherCode,
    required this.observedAt,
  });

  final String cityName;
  final double temperatureCelsius;
  final double apparentTemperatureCelsius;
  final double windSpeedKph;
  final int weatherCode;
  final DateTime observedAt;

  factory WeatherDto.fromJson({
    required String cityName,
    required Map<String, dynamic> json,
  }) {
    return WeatherDto(
      cityName: cityName,
      temperatureCelsius: JsonReader.readDouble(json, 'temperature_2m'),
      apparentTemperatureCelsius: JsonReader.readDouble(
        json,
        'apparent_temperature',
      ),
      windSpeedKph: JsonReader.readDouble(json, 'wind_speed_10m'),
      weatherCode: JsonReader.readInt(json, 'weather_code'),
      observedAt: JsonReader.readDateTime(json, 'time'),
    );
  }

  Weather toEntity() {
    return Weather(
      cityName: cityName,
      temperatureCelsius: temperatureCelsius,
      apparentTemperatureCelsius: apparentTemperatureCelsius,
      windSpeedKph: windSpeedKph,
      condition: _mapWeatherCode(weatherCode),
      observedAt: observedAt,
    );
  }

  static WeatherCondition _mapWeatherCode(int code) {
    return switch (code) {
      0 => WeatherCondition.clear,
      1 || 2 => WeatherCondition.partlyCloudy,
      3 => WeatherCondition.cloudy,
      45 || 48 => WeatherCondition.foggy,
      51 || 53 || 55 || 56 || 57 => WeatherCondition.drizzle,
      61 || 63 || 65 || 66 || 67 || 80 || 81 || 82 => WeatherCondition.rainy,
      71 || 73 || 75 || 77 || 85 || 86 => WeatherCondition.snowy,
      95 || 96 || 99 => WeatherCondition.thunderstorm,
      _ => WeatherCondition.unknown,
    };
  }
}
