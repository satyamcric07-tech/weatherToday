# SkyBrief roadmap

SkyBrief is a small, production-style weather app built as a learning project.
We will work in small steps: make one change, understand it, discuss it, then
continue.

## Progress

- [x] Step 0 — Remove Flutter's generated counter-app starter code.
- [x] Step 1 — Define the application entry point and theme.
- [x] Step 2 — Add Riverpod and explain dependency injection.
- [x] Step 3 — Establish the feature-first project structure.
- [x] Step 4 — Model weather data and API boundaries.
- [ ] Step 5 — Build the current-weather experience.
- [ ] Step 6 — Add city search and forecasts using Open-Meteo.
- [ ] Step 7 — Add resilient states, cache, favourites, and tests.

## Working agreement

Each step remains intentionally small. Code is explained line by line, with
the reason for every decision documented before we move to the next step.

## Step 1 notes

`SkyBriefApp` owns the global application configuration: its name, theme mode,
and light/dark Material 3 themes. Screens will receive these colors and text
styles through Flutter's inherited theme system instead of defining their own
inconsistent visual values. The current `Scaffold` is intentionally empty; it
is a valid, neutral home screen until we build the weather feature.

## Step 2 notes

Riverpod is the source of truth for app state and dependency wiring. Its
`ProviderScope` sits above `SkyBriefApp`, making a scoped provider container
available to all descendant widgets. Later, a weather controller can obtain a
repository through this container instead of creating dependencies directly in
the UI. This keeps UI state, API access, and tests independent.

## Step 3 notes

`main.dart` is the bootstrap file: it starts Flutter and configures app-wide
providers. `lib/app/app.dart` owns the global Flutter application configuration,
such as themes and navigation. Feature code will be added only when it has a
real responsibility, keeping the project feature-first without speculative
empty folders.

## Step 4 notes

The first domain entity is `Weather`. It represents the app's stable,
API-independent view of a current weather reading: a city, measurements,
condition, and observation time. `WeatherCondition` intentionally avoids
Open-Meteo numeric codes; the data layer will translate those external values
at its boundary.

`WeatherRepository` is the feature's domain contract. Presentation code depends
on it rather than an HTTP client or Open-Meteo. A later data-layer implementation
will fulfil the contract and translate API responses into domain entities.

## Step 5 notes

`WeatherPage` is the entry screen for the weather feature. It owns page-level
layout such as the app bar and safe screen area. The first presentation change
uses static display data deliberately, so layout and component design can be
understood before asynchronous state is introduced.

`CurrentWeatherCard` is a reusable, presentation-only component. Its required
constructor values make its inputs explicit and prevent it from fetching data
or owning business state. This makes the card easy to reuse with a loading,
error, or live-weather state in the next step, and easy to test in isolation.

## Step 6 notes
`WeatherPage` is a `ConsumerWidget` that watches `currentWeatherProvider` and
renders loading, data, and error states. 

Formatting `Weather` into display
strings (temperature, condition label, feels-like, wind) lives in a private
`_WeatherContent` widget in `weather_page.dart`, kept separate from the
domain entity and from `CurrentWeatherCard`.

Retry on error calls `ref.invalidate(currentWeatherProvider)`, which re-runsthe controller's `build()` and reloads the default city (Bengaluru).

## Step 7 notes
`WeatherPage` is a `ConsumerStatefulWidget`. It owns a `TextEditingController`
for a city-search `TextField` (search action on the keyboard, disposed in
`dispose()`).

Submitting a non-empty, trimmed city name calls
`ref.read(currentWeatherProvider.notifier).loadWeather(cityName)`, which sets
`AsyncLoading()` and then uses `AsyncValue guard` to fetch and update state.

All failures (bad city name, network error, etc.) currently collapse into
one generic `AsyncError`, rendered by the existing `_WeatherError` widget.
Distinguishing failure types is the next milestone, not yet implemented.


`_WeatherError` distinguishes `WeatherLocationNotFoundException` (shows the
  searched city name in the message) from all other failures (generic
  network/parsing message). This is presentation importing a concrete
  data-layer exception type directly — a deliberate, narrow exception to the
  `presentation -> domain <- data` rule, since Dart exceptions propagate
  untyped through `AsyncValue.guard`. If more failure types accumulate,
  consider a domain-level `WeatherFailure` sealed type that the repository
  maps into, so presentation matches on a domain type instead.