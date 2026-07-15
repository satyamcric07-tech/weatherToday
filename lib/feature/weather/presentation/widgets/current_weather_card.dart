import 'package:flutter/material.dart';

class CurrentWeatherCard extends StatelessWidget {
  const CurrentWeatherCard({
    super.key,
    required this.temperature,
    required this.condition,
    required this.feelsLike,
    required this.windSpeed,
  });

  final String temperature;
  final String condition;
  final String feelsLike;
  final String windSpeed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.cloud_outlined, size: 48, color: colorScheme.primary),
            const SizedBox(height: 24),
            Text(temperature, style: textTheme.displayMedium),
            const SizedBox(height: 4),
            Text(condition, style: textTheme.titleMedium),
            const SizedBox(height: 24),
            Text(feelsLike),
            const SizedBox(height: 8),
            Text(windSpeed),
          ],
        ),
      ),
    );
  }
}
