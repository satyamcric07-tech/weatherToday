import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_today/feature/weather/data/exceptions/weather_exceptions.dart';
import 'package:weather_today/feature/weather/data/models/weather_dto.dart';

import '../models/location_dto.dart';

class OpenMeteoRemoteDataSource {
  OpenMeteoRemoteDataSource({required this.client});

  final http.Client client;

  Future<List<LocationDto>> searchLocations(String query) async {
    final normalizedQuery = query.trim();

    if (normalizedQuery.length < 2) {
      return [];
    }

    final uri = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
      'name': normalizedQuery,
      'count': '10',
      'language': 'en',
      'format': 'json',
    });

    final response = await client.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw WeatherRemoteException(
        'Location search failed with status ${response.statusCode}.',
      );
    }

    final decodedResponse = jsonDecode(response.body);

    if (decodedResponse is! Map<String, dynamic>) {
      throw const WeatherRemoteException(
        'Location search returned an invalid response.',
      );
    }

    final results = decodedResponse['results'];

    if (results == null) {
      return [];
    }

    if (results is! List) {
      throw const WeatherRemoteException(
        'Location search returned invalid results.',
      );
    }

    return results.map((result) {
      if (result is! Map<String, dynamic>) {
        throw const WeatherRemoteException(
          'Location search contained an invalid location.',
        );
      }

      return LocationDto.fromJson(result);
    }).toList();
  }

  Future<WeatherDto> fetchCurrentWeather(LocationDto location) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': location.latitude.toString(),
      'longitude': location.longitude.toString(),
      'current':
          'temperature_2m,apparent_temperature,wind_speed_10m,weather_code',
      'timezone': 'auto',
      'temperature_unit': 'celsius',
      'wind_speed_unit': 'kmh',
    });

    final response = await client.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw WeatherRemoteException(
        'Current-weather request failed with status ${response.statusCode}.',
      );
    }

    final decodedResponse = jsonDecode(response.body);

    if (decodedResponse is! Map<String, dynamic>) {
      throw const WeatherRemoteException(
        'Current-weather request returned an invalid response.',
      );
    }

    final currentWeather = decodedResponse['current'];

    if (currentWeather is! Map<String, dynamic>) {
      throw const WeatherRemoteException(
        'Current-weather response is missing current conditions.',
      );
    }

    return WeatherDto.fromJson(cityName: location.name, json: currentWeather);
  }
}
