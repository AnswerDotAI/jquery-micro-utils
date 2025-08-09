# Repository Guidelines

## Project Structure & Module Organization
- `src/`: Source UMD module (`jquery-micro-utils.js`). Extends `$.fn` and `$.microUtils`.
- `scripts/`: helpers

## Build, Test, and Development Commands
- `npm i`: Install dev dependencies.

## Coding Style & Naming Conventions
- Indentation: 2 spaces; include semicolons; prefer `const`/`let`.
- Compatibility: jQuery 3.x; keep the UMD wrapper intact.
- Naming: plugin methods are camelCase (e.g., `nextMatch`, `findFirst`); files use kebab-case.
- API surface: extend via `$.fn.method` and update `$.microUtils.version` on releases.
- Only modern browser compatibility needed

## Commit & Pull Request Guidelines
- Scope: reference utilities when relevant (e.g., `feat(nextMatch): support predicate`).
- PRs: include a concise description, linked issues, and before/after snippets if DOM output changes.
- Checklist: tests updated, README/API examples updated, build passes.

