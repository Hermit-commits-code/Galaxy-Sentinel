#!/usr/bin/env bash
set -euo pipefail
VER="$1"
DATE="$(date +%F)"

# update pubspec version line
sed -E -i.bak "s/^version: .*/version: ${VER}+1/" pubspec.yaml
rm -f pubspec.yaml.bak

# move Unreleased to a new release header (naive implementation)
awk -v ver="$VER" -v d="$DATE" '
  BEGIN{in_unreleased=0; done=0}
  /^## \[Unreleased\]/{print; next}
  /^## \[/{ if(done==0){ print "## ["ver"] - "d"\n\n### Added\n\n- Release "ver"\n"; done=1 } }
  {print}
' CHANGELOG.md > CHANGELOG.md.tmp && mv CHANGELOG.md.tmp CHANGELOG.md

echo "Bumped to $VER"
