class JsonReader {
  const JsonReader._();

  static String readString(Map<String, dynamic> json, String key) {
    final value = json[key];

    if (value is String && value.isNotEmpty) {
      return value;
    }

    throw FormatException('Missing or invalid "$key" in API response.');
  }

  static double readDouble(Map<String, dynamic> json, String key) {
    final value = json[key];

    if (value is num) {
      return value.toDouble();
    }

    throw FormatException('Missing or invalid "$key" in API response.');
  }

  static int readInt(Map<String, dynamic> json, String key) {
    final value = json[key];

    if (value is int) {
      return value;
    }

    throw FormatException('Missing or invalid "$key" in API response.');
  }

  static DateTime readDateTime(Map<String, dynamic> json, String key) {
    final value = json[key];

    if (value is String) {
      final parsedDateTime = DateTime.tryParse(value);

      if (parsedDateTime != null) {
        return parsedDateTime;
      }
    }

    throw FormatException('Missing or invalid "$key" in API response.');
  }
}
