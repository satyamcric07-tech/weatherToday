class WeatherRemoteException implements Exception {
  const WeatherRemoteException(this.message);

  final String message;

  @override
  String toString() => 'WeatherRemoteException: $message';
}

class WeatherLocationNotFoundException implements Exception {
  const WeatherLocationNotFoundException(this.cityName);

  final String cityName;

  @override
  String toString() => 'WeatherLocationNotFoundException: $cityName';
}
