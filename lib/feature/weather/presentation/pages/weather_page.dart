import 'package:flutter/material.dart';

import '../widgets/current_weather_card.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SkyBrief')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bengaluru',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Your weather, at a glance.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              const CurrentWeatherCard(
                temperature: '24°',
                condition: 'Partly cloudy',
                feelsLike: 'Feels like 25°',
                windSpeed: 'Wind 11 km/h',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
