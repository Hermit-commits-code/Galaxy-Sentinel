# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added

- Platform detection improvements (planned).

## [0.1.3] - 2025-11-28

### Added

- Battery monitoring UI (WIP): lib/screens/battery_screen.dart — basic battery level + state, chart placeholder.
- Unit tests: test/screens/device_info_screen_test.dart — widget smoke test for Device Info screen.

## [0.1.2] - 2025-11-28

### Added

- Device Info screen: lib/screens/device_info_screen.dart — exposes device model, OS and version using `device_info_plus`. Basic Android support implemented; other platforms to be expanded.

## [0.1.0] - 2025-11-28

### Added

- Initial project scaffold created by `flutter create`.
- Added dependencies: `device_info_plus`, `battery_plus`, `shared_preferences`, `fl_chart`, `permission_handler`.

### Notes

- Versioning follows semver. Small changes will be recorded under an Unreleased section and promoted on release.
