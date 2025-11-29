#!/usr/bin/env bash
set -euo pipefail
if [ $# -lt 1 ]; then
  echo "Usage: $0 <semver> (e.g. 0.1.6)"; exit 2
fi
VER="$1"
TAG="v${VER}"
DATE=$(date +%F)

if [ -n "$(git status --porcelain)" ]; then
  echo "Working tree not clean. Commit or stash changes first."
  git status --porcelain
  exit 3
fi

# bump pubspec version (simple replace)
sed -E -i.bak "s/^version: .*/version: ${VER}+1/" pubspec.yaml
rm -f pubspec.yaml.bak

# move Unreleased -> version section (naive)
awk -v ver="$VER" -v d="$DATE" '
  BEGIN{p=1}
  /^## \[Unreleased\]/{print; next}
  /^## \[/{ if(p==1){ print "## ["ver"] - "d"\n\n### Added\n\n- Release "ver"\n"; p=0 } }
  {print}
' CHANGELOG.md > CHANGELOG.md.tmp && mv CHANGELOG.md.tmp CHANGELOG.md

git add pubspec.yaml CHANGELOG.md ROADMAP.md || true
git commit -m "chore(release): ${TAG}" || true

# create annotated (or signed) tag
if git config user.signingkey >/dev/null 2>&1; then
  git tag -s "${TAG}" -m "${TAG}"
else
  git tag -a "${TAG}" -m "${TAG}"
fi

git push origin HEAD
git push origin "${TAG}"

# create GH release notes if gh is available
if command -v gh >/dev/null 2>&1; then
  awk "/^## \\[${VER}\\]/{p=1;next} /^## \\[/{p=0} p{print}" CHANGELOG.md > /tmp/release-notes-${VER}.md || true
  gh release create "${TAG}" --title "${TAG}" --notes-file /tmp/release-notes-${VER}.md || true
  rm -f /tmp/release-notes-${VER}.md
fi

echo "Released ${TAG}"