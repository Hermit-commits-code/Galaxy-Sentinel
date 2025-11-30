Summary

This PR adds the initial data-streams infrastructure for v0.2.0:

- `lib/models/system_snapshot.dart`: model aggregating system metrics.
- `lib/services/performance_service.dart`: placeholder sampling API for RAM/CPU/disk.
- `lib/services/data_stream_manager.dart`: periodic sampling and a `Stream<SystemSnapshot>`.
- `lib/services/system_data_channel.dart`: MethodChannel wrapper for native CPU temperature.
- Tests: unit tests for `PerformanceService` and `DataStreamManager` that mock platform channels and `SharedPreferences`.

Why

Preparing v0.2.0: provide a foundation for continuous system metric sampling and streaming that will power dashboards, alerts, and export features.

Testing

- `flutter pub get`
- `flutter test --reporter expanded`
- `flutter analyze`

Notes & Follow-ups

- Confirm Android `package` in `android/app/src/main/AndroidManifest.xml` matches the Kotlin `ThermalReader` `package` declaration.
- The `PerformanceService` currently contains placeholders for native sampling — next step is to implement platform-specific hooks via MethodChannels or a small plugin.
- Version bumped to `0.2.0` and `CHANGELOG.md` promoted accordingly; signed commit and annotated tag `v0.2.0` were created and pushed.

Checklist

- [x] Code compiles and tests run locally
- [x] `pubspec.yaml` bumped to `0.2.0`
- [x] `CHANGELOG.md` updated
- [x] Signed commit and tag created
- [ ] CI passes on GitHub Actions
- [ ] Review and merge (squash)

Requesting review from the team.

