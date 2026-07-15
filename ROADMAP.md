# SkyBrief roadmap

SkyBrief is a small, production-style weather app built as a learning project.
We will work in small steps: make one change, understand it, discuss it, then
continue.

## Progress

- [x] Step 0 — Remove Flutter's generated counter-app starter code.
- [x] Step 1 — Define the application entry point and theme.
- [x] Step 2 — Add Riverpod and explain dependency injection.
- [ ] Step 3 — Establish the feature-first project structure.
- [ ] Step 4 — Model weather data and API boundaries.
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
