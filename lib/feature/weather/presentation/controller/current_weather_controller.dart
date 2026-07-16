import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_today/feature/weather/domain/repositories/weather_repository.dart';

import '../../domain/entities/weather.dart';
import '../providers/weather_providers.dart';

final currentWeatherProvider =
    AsyncNotifierProvider<CurrentWeatherController, Weather>(
      CurrentWeatherController.new,
    );

class CurrentWeatherController extends AsyncNotifier<Weather> {
  late final WeatherRepository _repository;

  @override
  Future<Weather> build() {
    _repository = ref.watch(weatherRepositoryProvider);

    return _repository.getCurrentWeather(cityName: 'Bengaluru');
  }

  Future<void> loadWeather(String cityName) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => _repository.getCurrentWeather(cityName: cityName),
    );
  }
}