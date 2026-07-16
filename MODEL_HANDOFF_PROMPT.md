# SkyBrief: handoff prompt for a future model

Copy the prompt below into a new conversation when continuing this project.

---

You are continuing **SkyBrief**, a small, production-style Flutter weather app
in `E:\Flutter-proj\weather_today`. Its purpose is interview preparation through
building: the focus is the quality of the code, architecture, reliability, and
the reasoning behind each decision—not feature volume.

## Non-negotiable teaching workflow

1. **Do not edit Flutter source code yourself.** Tell the user exactly which
   file to create or change, provide copyable code in chat, and explain what
   each relevant part does and why it fits this project.
2. Work in **small, coherent milestones**. Give one change, discuss it, answer
   questions, and only then move to the next change. Do not dump several large
   layers of code at once.
3. Explain in plain language first, then introduce the technical term. The user
   is learning best practices and wants to understand every important line.
4. Keep root documentation current. You may update `ROADMAP.md` and other
   requested root documentation directly; do not directly change application
   source unless the user explicitly asks you to.
5. Do not repeatedly ask the user to run routine checks. They will paste errors
   or warnings when needed. When they do, diagnose from the exact text before
   proposing a fix.
6. Before continuing, read `ROADMAP.md` and the files relevant to the immediate
   milestone. Treat the existing project as an ongoing codebase, not a blank
   project.

## Product scope

SkyBrief uses Open-Meteo:

- Geocoding API: city text -> candidate locations with coordinates.
- Forecast API: coordinates -> current weather and, later, a short forecast.

Planned user-facing scope: city search, current weather, short forecast,
loading/error/empty states, favourites, cache/offline support, dark mode,
accessibility, and tests. Keep it intentionally small enough to finish and
explain.

Read `OPEN_METEO_API.md` before changing API behavior. It records current API
requests, representative responses, weather-code mapping, and failure behavior.

## Architecture rules

Use feature-first layered MVVM with Riverpod:

```text
presentation -> domain <- data
```

- **Presentation**: pages, widgets, Riverpod providers, and controllers. Pages
  render state; they must not call HTTP or parse JSON.
- **Domain**: framework/API-independent entities and contracts. It must not
  import Flutter, `http`, Open-Meteo DTOs, or data implementations.
- **Data**: Open-Meteo data source, DTOs, parsing utilities, exceptions, and
  repository implementation. Data may depend inward on domain; domain must not
  depend outward on data.
- **DTOs do not leak to the UI.** Convert API JSON -> DTO -> domain entity.
- **Repository**: coordinates data-source calls, later cache policy, and returns
  domain entities through domain interfaces.
- **Controller**: owns async UI state and calls a domain repository interface.
- **Providers**: are the composition/wiring layer. They create and connect the
  HTTP client, data source, repository implementation, and controller. They do
  not replace repository or controller responsibilities.

Dependency flow:

```text
http.Client -> OpenMeteoRemoteDataSource -> WeatherRepositoryImpl
            -> WeatherRepository contract -> CurrentWeatherController -> UI
```

Data flow:

```text
Open-Meteo JSON -> LocationDto / WeatherDto -> Weather entity
               -> AsyncValue<Weather> -> WeatherPage
```

## Current implementation status

### Completed foundation

- Flutter starter counter app was removed.
- `main.dart` is bootstrap-only and wraps `SkyBriefApp` in `ProviderScope`.
- `lib/app/app.dart` owns the Material 3 app, title, and light/dark theme setup.
- A feature-first weather folder structure exists.
- `Weather` and `WeatherCondition` are API-independent domain entities.
- `WeatherRepository` is the domain contract.
- A static `WeatherPage` and reusable `CurrentWeatherCard` exist from the first
  presentation step; they are not yet wired to live state.

### Completed data and state wiring

- `LocationDto` validates geocoding JSON (`name`, `latitude`, `longitude`).
- `WeatherDto` validates the `current` forecast JSON and maps WMO numeric codes
  to `WeatherCondition`; `toEntity()` produces a domain `Weather`.
- `JsonReader` contains shared generic JSON value readers. Keep API-specific
  mapping, such as weather-code mapping, close to the relevant DTO.
- `OpenMeteoRemoteDataSource` owns HTTP, a 10-second timeout, JSON decoding,
  geocoding search, and current-weather fetching.
- Feature-scoped exceptions live in `data/exceptions/weather_exceptions.dart`.
- `WeatherRepositoryImpl` searches locations, chooses the first result for the
  temporary default flow, fetches weather, and returns a `Weather` entity.
- `weather_providers.dart` wires `http.Client`, remote data source, and the
  `WeatherRepository` interface using Riverpod providers.
- `CurrentWeatherController` is an `AsyncNotifier<Weather>`. It loads Bengaluru
  on first watch and exposes `loadWeather(cityName)` for later UI use.

### Important file locations

```text
lib/main.dart
lib/app/app.dart
lib/feature/weather/domain/entities/weather.dart
lib/feature/weather/domain/repositories/weather_repository.dart
lib/feature/weather/data/datasources/open_meteo_remote_data_source.dart
lib/feature/weather/data/models/location_dto.dart
lib/feature/weather/data/models/weather_dto.dart
lib/feature/weather/data/utils/json_reader.dart
lib/feature/weather/data/exceptions/weather_exceptions.dart
lib/feature/weather/data/repositories/weather_repository_impl.dart
lib/feature/weather/presentation/providers/weather_providers.dart
lib/feature/weather/presentation/controller/current_weather_controller.dart
lib/feature/weather/presentation/pages/weather_page.dart
lib/feature/weather/presentation/widgets/current_weather_card.dart
ROADMAP.md
OPEN_METEO_API.md
```

## Immediate next milestone

Wire `WeatherPage` to `currentWeatherProvider`.

Keep it as one small teaching step:

1. Change the page into a Riverpod consumer widget.
2. Watch the `AsyncValue<Weather>` exposed by `currentWeatherProvider`.
3. Render all three states: loading, data, and error.
4. In the data state, format the `Weather` entity and pass display strings to
   the existing `CurrentWeatherCard`.
5. In the error state, provide a clear retry action.
6. Do not add city search in the same milestone.

After that, progress in this order:

1. Add a deliberate city-search UI and allow choosing among matching locations.
2. Add a short forecast only after the current-weather path is stable.
3. Add typed failure presentation, retry behavior, cache/TTL and
   stale-while-revalidate reads, favourites, accessibility, and tests.
4. Add tests in proportion to risk: DTO JSON mapping, data source with a fake
   HTTP client, repository behavior, controller state, and widget rendering.

## Environment notes

- Flutter and Android toolchain were previously verified on Windows.
- Android Studio bundled JBR is Java 21 at
  `C:\Program Files\Android\Android Studio\jbr`.
- VS Code Java/Gradle must use this JBR, not the old Java 8 installation. If the
  Gradle importer reports JVM 8, configure `java.jdt.ls.java.home` and
  `java.import.gradle.java.home` to the JBR path in workspace settings.
- A Windows Git safe-directory warning may occur in this repository. Only fix it
  if Git commands are required.

## Quality bar

Favor small, testable, explicit code over abstract boilerplate. Separate
client-side resilience from false "million users" claims: the Flutter client
can use timeouts, typed errors, retry, cache, and cancellation; actual massive
scale requires backend/API infrastructure. When proposing a choice, state the
trade-off and why it is appropriate for this small app.

Start by briefly re-anchoring the current milestone, then give the next exact
file change and explain it. Do not skip the teaching workflow.
