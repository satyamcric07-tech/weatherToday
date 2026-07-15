enum WeatherCondition {
  clear,
  partlyCloudy,
  cloudy,
  foggy,
  drizzle,
  rainy,
  snowy,
  thunderstorm,
  unknown,
}

class Weather {
  const Weather({
    required this.cityName,
    required this.temperatureCelsius,
    required this.apparentTemperatureCelsius,
    required this.windSpeedKph,
    required this.condition,
    required this.observedAt,
  });

  final String cityName;
  final double temperatureCelsius;
  final double apparentTemperatureCelsius;
  final double windSpeedKph;
  final WeatherCondition condition;
  final DateTime observedAt;
}
