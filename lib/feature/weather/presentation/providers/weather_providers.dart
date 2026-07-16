import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:weather_today/feature/weather/data/repositories/weather_repository_impl.dart';

import '../../data/datasources/open_meteo_remote_data_source.dart';
import '../../domain/repositories/weather_repository.dart';

final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();

  ref.onDispose(client.close);

  return client;
});

final openMeteoRemoteDataSourceProvider = Provider<OpenMeteoRemoteDataSource>((
  ref,
) {
  return OpenMeteoRemoteDataSource(client: ref.watch(httpClientProvider));
});

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepositoryImpl(
    remoteDataSource: ref.watch(openMeteoRemoteDataSourceProvider),
  );
});
