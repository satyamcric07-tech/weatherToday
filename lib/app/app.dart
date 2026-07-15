import 'package:flutter/material.dart';
import 'package:weather_today/feature/weather/presentation/pages/weather_page.dart';

class SkyBriefApp extends StatelessWidget {
  const SkyBriefApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkyBrief',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF246BFD),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8AB4FF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const WeatherPage(),
    );
  }
}
