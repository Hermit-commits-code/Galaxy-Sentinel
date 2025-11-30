# Galaxy Sentinel

[![CI](https://github.com/Hermit-commits-code/Galaxy-Sentinel/actions/workflows/flutter.yml/badge.svg)](https://github.com/Hermit-commits-code/Galaxy-Sentinel/actions/workflows/flutter.yml)
[![Release](https://github.com/Hermit-commits-code/Galaxy-Sentinel/actions/workflows/release.yml/badge.svg)](https://github.com/Hermit-commits-code/Galaxy-Sentinel/releases)
[![Coverage](https://img.shields.io/badge/coverage-unknown-yellow.svg)](https://github.com/Hermit-commits-code/Galaxy-Sentinel)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A premium, highly visual system-health and diagnostics dashboard for Android (Galaxy) devices built with Flutter.

Table of contents

- [About](#about)
- [Features](#features)
- [Screenshots](#screenshots)
- [Quick start](#quick-start)
- [Development workflow](#development-workflow)
- [Testing](#testing)
- [Releases](#releases)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)

## About

Galaxy Sentinel collects device and system metrics, persisting historical data and rendering polished visualizations (charts, gauges). The project uses a small Kotlin bridge where necessary for low-level system access and keeps most logic in Dart.

## Features

- Real-time battery & device information
- Persisted battery history with charts (fl_chart + shared_preferences)
- Service-oriented architecture: Models, Services, UI
- CI-driven releases via GitHub Actions
- Test coverage: unit + widget tests

## Screenshots

Replace with real screenshots in `/assets/screenshots/` and update this section.

## Quick start

1. Clone
   ```bash
   git clone git@github.com:Hermit-commits-code/Galaxy-Sentinel.git
   cd Galaxy-Sentinel
   ```
2. Install dependencies
   ```bash
   flutter pub get
   ```
3. Run (Android emulator / device)
   ```bash
   flutter run
   ```

## Development workflow

- Branches
  - main — trunk (protected)
  - feat/\* — short-lived feature branches
  - release/stable — optional pointer to last release (use for hotfixes)
- Commits: Conventional Commits (feat/, fix/, chore/, docs/, test/, refactor/)
- PRs: Open a PR from a feature branch to main, include linked issue, add tests and CI should pass before merge
- Merge strategy: squash-and-merge recommended for clean main history (or local signed squash merge for auditability)

Example: create a feature branch

```bash
git checkout main
git pull origin main
git checkout -b feat/your-feature
git push -u origin feat/your-feature
```

## Testing

- Run analyzer and tests locally:

```bash
flutter pub get
flutter analyze
flutter test --reporter expanded
```

## Building Samsung flavor (local)

If you need to build the Samsung-targeted flavor (contains vendor telemetry
worker), run:

```bash
flutter build appbundle --flavor samsung -t lib/main.dart --release
# or for a quick APK
flutter build apk --flavor samsung -t lib/main.dart --release
```

The CI creates a PR artifact for the `samsung` flavor when the branch is
`feat/data-streams`. See `.github/workflows/build_samsung.yml` for details.

- Tests include unit tests for services and widget tests for UI components. Use `SharedPreferences.setMockInitialValues()` for prefs tests.

## Releases

Release flow (recommended)

1. Update `CHANGELOG.md` — move Unreleased into `## [X.Y.Z] - YYYY-MM-DD`
2. Update `version:` in `pubspec.yaml`
3. Commit signed: `git commit -S -m "chore(release): vX.Y.Z"`
4. Tag signed: `git tag -s vX.Y.Z -m "vX.Y.Z — short note"`
5. Push commit and tag:
   ```bash
   git push origin main
   git push origin vX.Y.Z
   ```
   Pushing the tag will trigger the release workflow (`.github/workflows/release.yml`) which runs tests and creates the GitHub Release.

Automation: optionally use `scripts/release.sh` to prepare changelog/pubspec and create a signed tag locally.

## Roadmap

See [ROADMAP.md](./ROADMAP.md) for staged goals (native method channel for CPU temp, DataStreamManager, dashboard visualizations, premium features, and deployment checklist).

## Contributing

- Open an issue first for major features.
- Keep PRs focused and small. Reference the issue with `Closes #<issue>`.
- Add tests for new logic and UI where possible.
- Follow Conventional Commits.
- Please sign your commits if you require GPG provenance.

Suggested labels: `enhancement`, `bug`, `wip`, `tests`, `docs`. Suggested milestone: `v0.2.0`.

## License

MIT — see [LICENSE](./LICENSE) for details.
