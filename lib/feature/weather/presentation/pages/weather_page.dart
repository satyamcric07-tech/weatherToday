import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/weather.dart';
import '../controller/current_weather_controller.dart';
import '../widgets/current_weather_card.dart';
import '../../data/exceptions/weather_exceptions.dart';

class WeatherPage extends ConsumerStatefulWidget {
  const WeatherPage({super.key});

  @override
  ConsumerState<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends ConsumerState<WeatherPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearchSubmitted(String value) {
    final cityName = value.trim();
    if (cityName.isEmpty) return;

    ref.read(currentWeatherProvider.notifier).loadWeather(cityName);
  }

  @override
  Widget build(BuildContext context) {
    final weatherAsync = ref.watch(currentWeatherProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('SkyBrief')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  hintText: 'Search for a city',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onSubmitted: _handleSearchSubmitted,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: weatherAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => _WeatherError(
                    error: error,
                    onRetry: () => ref.invalidate(currentWeatherProvider),
                  ),
                  data: (weather) => _WeatherContent(weather: weather),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeatherContent extends StatelessWidget {
  const _WeatherContent({required this.weather});

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          weather.cityName,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 4),
        Text(
          'Your weather, at a glance.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        CurrentWeatherCard(
          temperature: '${weather.temperatureCelsius.round()}°',
          condition: _conditionLabel(weather.condition),
          feelsLike:
              'Feels like ${weather.apparentTemperatureCelsius.round()}°',
          windSpeed: 'Wind ${weather.windSpeedKph.round()} km/h',
        ),
      ],
    );
  }

  String _conditionLabel(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.clear:
        return 'Clear';
      case WeatherCondition.partlyCloudy:
        return 'Partly cloudy';
      case WeatherCondition.cloudy:
        return 'Cloudy';
      case WeatherCondition.foggy:
        return 'Foggy';
      case WeatherCondition.drizzle:
        return 'Drizzle';
      case WeatherCondition.rainy:
        return 'Rainy';
      case WeatherCondition.snowy:
        return 'Snowy';
      case WeatherCondition.thunderstorm:
        return 'Thunderstorm';
      case WeatherCondition.unknown:
        return 'Unknown';
    }
  }
}

class _WeatherError extends StatelessWidget {
  const _WeatherError({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _messageFor(error),
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }

  String _messageFor(Object error) {
    if (error is WeatherLocationNotFoundException) {
      return "We couldn't find \"${error.cityName}\". Check the spelling and try again.";
    }
    return 'Could not load the weather. Please try again.';
  }
}
