import 'package:weather_today/feature/weather/data/dataSources/open_meteo_remote_data_source.dart';
import 'package:weather_today/feature/weather/data/exceptions/weather_exceptions.dart';

import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  WeatherRepositoryImpl({required this.remoteDataSource});

  final OpenMeteoRemoteDataSource remoteDataSource;

  @override
  Future<Weather> getCurrentWeather({required String cityName}) async {
    final locations = await remoteDataSource.searchLocations(cityName);

    if (locations.isEmpty) {
      throw WeatherLocationNotFoundException(cityName);
    }

    final weatherDto = await remoteDataSource.fetchCurrentWeather(
      locations.first,
    );

    return weatherDto.toEntity();
  }
}
