# 🚀 Galaxy Sentinel: Development Roadmap (Merged)

Current version: 0.1.7+1  
Current phase: Mid-Term

**App Goal:** Create a premium, highly visual, and comprehensive system health and diagnostics dashboard for Android/Galaxy devices.

---

## Release history

- [x] v0.1.0 — initial scaffold
- [x] v0.1.2 — Device Info screen (lib/screens/device_info_screen.dart)
- [x] v0.1.3 — Battery monitoring release
- [x] v0.1.4 — App scaffold & navigation
- [x] v0.1.6 — Battery history initial work
- [x] v0.1.7 — Battery history: persisted readings + chart

---

## Stage 0: Project setup & dependencies

- [x] Create Flutter project
- [x] Add core packages for data fetching, charting, and logic (device_info_plus, battery_plus, fl_chart, shared_preferences)
- [x] AndroidManifest permissions: ensure required permissions present
- [x] Ensure Kotlin toolchain compatibility in android build files
- [x] Establish project structure (Models / Services / UI / Features)

---

## Stage 1: Native Data Access (Kotlin Method Channel)

- [ ] 1.1 MainActivity.kt: MethodChannel 'com.galaxysentinel.data'
- [ ] 1.2 ThermalReader.kt: safely read CPU temperature from /sys/class/thermal
- [ ] 1.3 MainActivity.kt: wire MethodChannel to ThermalReader
- [ ] 1.4 SystemDataChannel.dart: Dart wrapper for method channel calls

---

## Stage 2: Core Data Services (Dart logic)

- [x] 2.1 SystemSnapshot model (skeleton / plan)
- [x] 2.2 BatteryService: real-time battery monitoring & cycle tracking (initial)
- [x] 2.3 PerformanceService: device info + memory/disk sampling (planned)
- [x] 2.4 DataStreamManager: combine services into a timed stream (planned)

Notes: core services exist as scaffolds and are iteratively expanding. Thermal Method Channel still TODO.

---

## Stage 3: Dashboard UI & Visualization

- [x] 3.1 HomeScreen & navigation scaffold
- [x] 3.2 GaugeWidget: design planned (fl_chart based)
- [x] 3.3 ThermalChart: live line chart for CPU temp (planned)
- [x] 3.4 BatteryHealthScreen: secondary screen skeleton

Progress: Battery History (BatteryHistoryScreen + LineChart) implemented; polish and feature-gating (Pro) remain.

---

## Stage 4: Premium Features & Monetization

- [ ] 4.1 ProUnlockManager: store Pro status (shared_preferences)
- [ ] 4.2 PaywallScreen: design & UX
- [ ] 4.3 AlertService: custom alerts & background checks
- [ ] 4.4 UI integration: restrict extended history behind Pro

---

## Stage 5: Final polish, testing & deployment

- [ ] 5.1 Performance profiling & memory/CPU checks
- [ ] 5.2 Platform reliability testing on Samsung devices (MethodChannel)
- [ ] 5.3 Marketing: store assets & screenshots
- [ ] 5.4 Deployment: build/sign/submission checklist

---

## Short-term / Sprint checklist

- [x] Merge `feat/replace-demo-home` → `main`
- [x] Start `feat/battery-history`
- [x] Implement battery chart + history (fl_chart) — done (basic)
- [x] Persist readings with shared_preferences — done
- [x] Unit & widget tests for battery features — added
- [ ] Permission flows using permission_handler (next)
- [ ] Polish UI, add more tests, add pro/alerts

---

## Project tooling & process

- [x] Use Conventional Commits
- [x] Maintain CHANGELOG.md with Unreleased section
- [x] CI (GitHub Actions) active: PR checks + release workflow
- [x] README.md present
- [ ] CONTRIBUTING.md (create or expand)
- [ ] Issue templates & labels; milestone v0.2.0 (create/confirm)
- [ ] Automated release script (optional) — add after CI stabilizes

---

## Notes / conventions

- Work on features in dedicated branches: `feat/...`, `fix/...`, `chore/...`.
- Keep Unreleased changelog notes minimal inside feature branches; finalize notes on `main` before tagging.
- Tag releases with canonical semver (vX.Y.Z) pointing to the merge commit.
- Do not bump pubspec to the next dev version until after tagging the release commit.

---

## Quick commands

- Create feature branch:
  - git checkout -b feat/your-feature
  - git push -u origin feat/your-feature
- Release flow (on `main` after merge):
  - update CHANGELOG.md -> move Unreleased into `## [X.Y.Z] - YYYY-MM-DD`
  - set `version:` in pubspec.yaml
  - git add CHANGELOG.md pubspec.yaml
  - git commit -S -m "chore(release): vX.Y.Z"
  - git tag -s vX.Y.Z -m "vX.Y.Z — short note"
  - git push origin main
  - git push origin vX.Y.Z

Keep this file as the single source of truth for next tasks and release targets.
