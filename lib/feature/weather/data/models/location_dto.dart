import 'package:weather_today/feature/weather/data/utils/json_reader.dart';

class LocationDto {
  const LocationDto({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  final String name;
  final double latitude;
  final double longitude;

  factory LocationDto.fromJson(Map<String, dynamic> json) {
    return LocationDto(
      name: JsonReader.readString(json, 'name'),
      latitude: JsonReader.readDouble(json, 'latitude'),
      longitude: JsonReader.readDouble(json, 'longitude'),
    );
  }
}
