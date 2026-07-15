import '../entities/weather.dart';

abstract interface class WeatherRepository {
  Future<Weather> getCurrentWeather({required String cityName});
}
