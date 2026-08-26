#!/bin/sh
# Build upload archives into build/.
#
#   build/<repo-folder>.zip        the whole plugin, for Settings > Plugins
#   build/skills/<name>.zip        one skill each, for Settings > Skills
#
# The plugin archive excludes build/ so it never contains a nested zip.
# The uploader rejects an archive that holds another archive.
#
# Usage: ./scripts/package.sh

set -e
root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
name=$(basename "$root")
out="$root/build"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

rm -rf "$out"
mkdir -p "$out/skills"

# Whole plugin: one top-level folder, no build output, no VCS or OS cruft.
(cd "$root/.." && zip -q -r -X "$tmp/$name.zip" "$name" \
  -x "$name/build/*" \
  -x "$name/.git/*" \
  -x "*/.DS_Store" \
  -x "*/__MACOSX/*")
mv "$tmp/$name.zip" "$out/$name.zip"

# One archive per skill, for uploading a single skill on its own.
(cd "$root/skills" && for skill in */*/; do
  s=${skill%/}
  [ -f "$s/SKILL.md" ] || continue
  base=$(basename "$s")
  (cd "$(dirname "$s")" && zip -q -r -X "$tmp/$base.zip" "$base" -x "*/.DS_Store" -x "*/__MACOSX/*")
  mv "$tmp/$base.zip" "$out/skills/$base.zip"
done)

echo "build/$name.zip"
for z in "$out"/skills/*.zip; do echo "build/skills/$(basename "$z")"; done
