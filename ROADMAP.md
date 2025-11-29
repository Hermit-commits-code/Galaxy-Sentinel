# Roadmap — galaxy_sentinel

Current version: 0.1.4+1  
Current phase: Mid-Term

This file tracks high-level goals, release targets and the status of work items. Check items as they complete and keep entries short.

## Release history

- [x] v0.1.0 — initial scaffold
- [x] v0.1.2 — Device Info screen (lib/screens/device_info_screen.dart)
- [x] v0.1.3 — Battery monitoring release
- [x] v0.1.4 — Current release (lib/screens/\* updates; app scaffold)

## Ongoing / Next

- [x] Replace demo home with app scaffold and navigation (feat/replace-demo-home)
- [x] Battery screen scaffold (lib/screens/battery_screen.dart) — added on feature branch
- [x] Device Info widget smoke test (test/screens/device_info_screen_test.dart)

## Short-term (this sprint)

- [x] Merge `feat/replace-demo-home` → `main` (open PR, review, merge)
- [x] Release v0.1.3 after merge: update CHANGELOG, set pubspec, tag `v0.1.3`, push
- [x] Confirm tag and create GitHub Release for v0.1.3
- [ ] Start feature branch: `feat/battery-history` (battery chart + persistence)

## Mid-term

- [ ] Implement battery chart + history using `fl_chart`
- [ ] Persist settings with `shared_preferences`
- [ ] Permission flows using `permission_handler`
- [ ] Unit & widget tests for battery features (CI-friendly)

## Project tooling & process

- [x] Use Conventional Commits for all commits
- [x] Maintain CHANGELOG.md with an Unreleased section
- [ ] Add README.md & CONTRIBUTING.md (keep short & actionable)
- [ ] Issue templates & labels; create milestone for v0.2.0
- [ ] CI (GitHub Actions) — deferred until releases are routine
- [ ] Automated release script (optional) — create after CI stabilizes

## Notes / conventions

- Work on features in dedicated branches: `feat/...`, `fix/...`, `chore/...`.
- Keep Unreleased changelog entries minimal inside feature branches; final release notes edited on `main`.
- Tag releases with canonical semver (e.g., `v0.1.4`) pointing to the merge commit.
- Do not bump pubspec to the next dev version until after tagging the release commit.

## Quick commands

- Create feature branch:
  - git checkout -b feat/your-feature
  - git push -u origin feat/your-feature
- Release flow (on `main` after merge):
  - update CHANGELOG.md -> move Unreleased into `## [X.Y.Z] - YYYY-MM-DD`
  - set `version:` in pubspec.yaml
  - git add CHANGELOG.md pubspec.yaml
  - git commit -m "chore(release): vX.Y.Z"
  - git tag -a vX.Y.Z -m "vX.Y.Z — short note"
  - git push origin main
  - git push origin vX.Y.Z

Keep this file up-to-date; it should reflect the single source of truth for next tasks and release targets.
