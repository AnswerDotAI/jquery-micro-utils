#!/usr/bin/env bash

set -euo pipefail

# Release script for jquery-micro-utils
# - Creates a GitHub release for the current version
# - Bumps patch version in package.json, src file, and README CDN link
# - Commits and pushes the bump

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: not inside a git repository." >&2
  exit 1
fi

# Ensure working tree is clean
if ! git diff-index --quiet HEAD --; then
  echo "Error: working tree has uncommitted changes. Please commit or stash before releasing." >&2
  exit 1
fi

BRANCH="$(git rev-parse --abbrev-ref HEAD)"
HEAD_SHA="$(git rev-parse HEAD)"

# Read current version from package.json
CURRENT_VERSION="$(perl -ne 'print $1 if /"version":\s*"([^"]+)"/' package.json)"

if [[ -z "$CURRENT_VERSION" ]]; then
  echo "Initializing package version to 0.1.0"
  npm version "0.1.0" --no-git-tag-version >/dev/null
  update_version "0.1.0"
  git add package.json src/jquery-micro-utils.js README.md
  git commit -m "chore(version): initialize to v0.1.0" >/dev/null
  CURRENT_VERSION="0.1.0"
  HEAD_SHA="$(git rev-parse HEAD)"
fi

TAG="v$CURRENT_VERSION"

# Ensure the tag doesn't already exist remotely
if gh release view "$TAG" >/dev/null 2>&1; then
  echo "Error: release $TAG already exists on GitHub." >&2
  exit 1
fi

echo "Creating GitHub release $TAG from $BRANCH@$HEAD_SHA"
gh release create "$TAG" --title "$TAG" --generate-notes --target "$HEAD_SHA"

# Bump patch version
echo "Bumping patch version"
npm version patch --no-git-tag-version >/dev/null

NEW_VERSION="$(perl -ne 'print $1 if /"version":\s*"([^"]+)"/' package.json)"

update_version() {
  local ver="$1"
  # Update source file version
  perl -pi -e 's/(jQuery Micro Utils v)\d+\.\d+\.\d+/\1'"$ver"'/g' src/jquery-micro-utils.js
  perl -pi -e 's/(\$\.microUtils = \{ version: ['\''"])([^'\''"]+)(['\''"] \})/\1'"$ver"'\3/g' src/jquery-micro-utils.js
  # Update README CDN link
  perl -pi -e 's/(cdn\.jsdelivr\.net\/gh\/AnswerDotAI\/jquery-micro-utils@)\d+\.\d+\.\d+/\1'"$ver"'/g' README.md
}

update_version "$NEW_VERSION"
git add package.json src/jquery-micro-utils.js README.md
git commit -m "chore(version): bump to v$NEW_VERSION" >/dev/null

echo "Pushing changes to origin/$BRANCH"
git push origin "$BRANCH"

echo "Done. Released $TAG and bumped to v$NEW_VERSION"

