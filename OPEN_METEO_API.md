# Open-Meteo API reference

This is the API contract used by SkyBrief. The app uses two Open-Meteo APIs:

1. **Geocoding API**: turn a city search term into one or more locations.
2. **Forecast API**: request current weather for a selected location's
   latitude and longitude.

The two-step flow matters: a city name is ambiguous, while coordinates identify
the location to forecast.

```text
"London" -> matching locations -> user selects one -> coordinates -> weather
```

## 1. Geocoding API

### Endpoint

```text
GET https://geocoding-api.open-meteo.com/v1/search
```

### Request

| Parameter | Required | SkyBrief value | Meaning |
| --- | --- | --- | --- |
| `name` | Yes | User-entered city query | Search text; use at least two characters. |
| `count` | No | `10` | Maximum number of matches to return. |
| `language` | No | `en` | Preferred language for returned names. |
| `format` | No | `json` | Response format. JSON is the default. |

Example request:

```text
https://geocoding-api.open-meteo.com/v1/search?name=Bengaluru&count=10&language=en&format=json
```

### Successful response

The `results` key is a list. An empty or missing `results` value means there
were no matching locations.

```json
{
  "results": [
    {
      "id": 1277333,
      "name": "Bengaluru",
      "latitude": 12.97194,
      "longitude": 77.59369,
      "country": "India",
      "admin1": "Karnataka",
      "timezone": "Asia/Kolkata"
    }
  ]
}
```

SkyBrief currently reads only the values below into `LocationDto`:

| JSON field | Dart field | Why it is needed |
| --- | --- | --- |
| `name` | `name` | Display the selected city. |
| `latitude` | `latitude` | Required by the forecast request. |
| `longitude` | `longitude` | Required by the forecast request. |

`country` and `admin1` are useful future additions for distinguishing places
with the same name, such as London in the UK and Canada.

## 2. Forecast API: current weather

### Endpoint

```text
GET https://api.open-meteo.com/v1/forecast
```

### Request

| Parameter | Required | SkyBrief value | Meaning |
| --- | --- | --- | --- |
| `latitude` | Yes | Selected location latitude | WGS84 coordinate. |
| `longitude` | Yes | Selected location longitude | WGS84 coordinate. |
| `current` | No | Requested current variables | Comma-separated variable names. |
| `timezone` | No | `auto` | Return time in the location's time zone. |
| `temperature_unit` | No | `celsius` | Keep temperatures in Celsius. |
| `wind_speed_unit` | No | `kmh` | Keep wind speeds in km/h. |

SkyBrief's current-weather variables:

```text
temperature_2m,apparent_temperature,wind_speed_10m,weather_code
```

Example request:

```text
https://api.open-meteo.com/v1/forecast?latitude=12.97194&longitude=77.59369&current=temperature_2m,apparent_temperature,wind_speed_10m,weather_code&timezone=auto&temperature_unit=celsius&wind_speed_unit=kmh
```

### Successful response

`current` contains only the variables requested in the `current` parameter.
`time` is the moment the current reading is valid.

```json
{
  "latitude": 12.97,
  "longitude": 77.59,
  "timezone": "Asia/Kolkata",
  "current_units": {
    "time": "iso8601",
    "temperature_2m": "°C",
    "apparent_temperature": "°C",
    "wind_speed_10m": "km/h",
    "weather_code": "wmo code"
  },
  "current": {
    "time": "2026-07-16T10:30",
    "temperature_2m": 25.4,
    "apparent_temperature": 27.2,
    "wind_speed_10m": 11.8,
    "weather_code": 2
  }
}
```

SkyBrief converts the `current` object into `WeatherDto`, then maps it to the
API-independent domain `Weather` entity.

```text
API JSON -> WeatherDto -> Weather -> UI
```

## Weather-code mapping

Open-Meteo uses WMO weather interpretation codes. SkyBrief groups these detailed
codes into its smaller `WeatherCondition` enum for UI use.

| Open-Meteo codes | Meaning | SkyBrief condition |
| --- | --- | --- |
| `0` | Clear sky | `clear` |
| `1`, `2` | Mainly clear or partly cloudy | `partlyCloudy` |
| `3` | Overcast | `cloudy` |
| `45`, `48` | Fog | `foggy` |
| `51`, `53`, `55`, `56`, `57` | Drizzle or freezing drizzle | `drizzle` |
| `61`, `63`, `65`, `66`, `67`, `80`, `81`, `82` | Rain, freezing rain, or showers | `rainy` |
| `71`, `73`, `75`, `77`, `85`, `86` | Snow or snow showers | `snowy` |
| `95`, `96`, `99` | Thunderstorm, optionally with hail | `thunderstorm` |
| Any other value | Unsupported or future code | `unknown` |

The fallback to `unknown` is intentional. It keeps the app functional if the
provider introduces a code that SkyBrief has not mapped yet.

## Failure behaviour

| Situation | Expected app behaviour |
| --- | --- |
| City is not found | Return an empty location list; this is not a crash. |
| HTTP response is not `200` | Throw `WeatherRemoteException`; a later repository/controller will show a recoverable error state. |
| Response JSON has an unexpected shape | Throw `FormatException`; the API contract was not met. |
| Request takes longer than 10 seconds | The request times out; the later UI can offer retry and cached data. |

## Sources

- [Open-Meteo Geocoding API documentation](https://open-meteo.com/en/docs/geocoding-api)
- [Open-Meteo Weather Forecast API documentation](https://open-meteo.com/en/docs)

Checked: 16 July 2026.
