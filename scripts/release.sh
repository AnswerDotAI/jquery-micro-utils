#!/usr/bin/env bash

set -euo pipefail

# Release script for jquery-micro-utils
# - Creates a GitHub release for the current version
# - Bumps patch version in package.json
# - Syncs runtime version in src/jquery-micro-utils.js
# - Commits and pushes the bump

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: not inside a git repository." >&2
  exit 1
fi

# Ensure working tree is clean to avoid accidental releases of uncommitted code
if ! git diff-index --quiet HEAD --; then
  echo "Error: working tree has uncommitted changes. Please commit or stash before releasing." >&2
  exit 1
fi

BRANCH="$(git rev-parse --abbrev-ref HEAD)"
HEAD_SHA="$(git rev-parse HEAD)"

PKG_JSON="package.json"
SRC_FILE="src/jquery-micro-utils.js"

if [[ ! -f "$PKG_JSON" ]]; then
  echo "Error: $PKG_JSON not found." >&2
  exit 1
fi

# Read version from package.json; initialize if missing
CURRENT_VERSION="$(node -e "try{const v=require('./package.json').version||'';process.stdout.write(String(v||''))}catch(e){process.stdout.write('')}")"

init_if_missing() {
  local init_ver="$1"
  echo "Initializing package version to $init_ver"
  npm version "$init_ver" --no-git-tag-version >/dev/null

  # Sync runtime version in source file if present
  if [[ -f "$SRC_FILE" ]]; then
    node - <<'NODE' "$init_ver" "$SRC_FILE"
const fs = require('fs');
const path = process.argv[3];
const ver = process.argv[2];
let s = fs.readFileSync(path, 'utf8');
s = s.replace(/(jQuery\s+Micro\s+Utils\s+v)(\d+\.\d+\.\d+)/, `$1${ver}`);
s = s.replace(/(\$\.microUtils\s*=\s*\{\s*version:\s*['"])([^'"]+)(['"]\s*\})/, `$1${ver}$3`);
fs.writeFileSync(path, s);
NODE
    git add "$PKG_JSON" "$SRC_FILE"
  else
    git add "$PKG_JSON"
  fi
  git commit -m "chore(version): initialize to v$init_ver" >/dev/null
}

if [[ -z "$CURRENT_VERSION" ]]; then
  # Default initial version
  init_if_missing "0.1.0"
  CURRENT_VERSION="0.1.0"
  # Update HEAD SHA after the init commit
  HEAD_SHA="$(git rev-parse HEAD)"
fi

TAG="v$CURRENT_VERSION"

# Ensure the tag doesn't already exist remotely as a release
if gh release view "$TAG" >/dev/null 2>&1; then
  echo "Error: release $TAG already exists on GitHub." >&2
  exit 1
fi

echo "Creating GitHub release $TAG from $BRANCH@$HEAD_SHA"
gh release create "$TAG" --title "$TAG" --generate-notes --target "$HEAD_SHA"

# Bump patch version in package.json without creating a git tag
echo "Bumping patch version"
npm version patch --no-git-tag-version >/dev/null

NEW_VERSION="$(node -p "require('./package.json').version")"

# Sync runtime version in source file
if [[ -f "$SRC_FILE" ]]; then
  node - <<'NODE' "$NEW_VERSION" "$SRC_FILE"
const fs = require('fs');
const path = process.argv[3];
const ver = process.argv[2];
let s = fs.readFileSync(path, 'utf8');
s = s.replace(/(jQuery\s+Micro\s+Utils\s+v)(\d+\.\d+\.\d+)/, `$1${ver}`);
s = s.replace(/(\$\.microUtils\s*=\s*\{\s*version:\s*['"])([^'"]+)(['"]\s*\})/, `$1${ver}$3`);
fs.writeFileSync(path, s);
NODE
  git add "$PKG_JSON" "$SRC_FILE"
else
  git add "$PKG_JSON"
fi

git commit -m "chore(version): bump to v$NEW_VERSION" >/dev/null

echo "Pushing changes to origin/$BRANCH"
git push origin "$BRANCH"

echo "Done. Released $TAG and bumped to v$NEW_VERSION"

