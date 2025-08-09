# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

- `npm run serve` - Start development server at localhost:8080/examples/
- `npm install` - Install dev dependencies

## Architecture

This is a lightweight jQuery utility library that extends jQuery with micro-utilities for efficient DOM traversal and manipulation. The project follows these key patterns:

### Core Structure
- Single source file: `src/jquery-micro-utils.js` - UMD module that extends `$.fn` and `$.microUtils`
- Plugin methods use camelCase naming (nextMatch, findFirst, containsText, etc.)
- All utilities focus on performance by returning first matches rather than collecting all matches

### Plugin Design Patterns
- Use `toPred()` helper to convert selectors or functions to predicate functions
- Use `toUnq()` helper to return unique jQuery collections
- Methods should return jQuery objects to maintain chainability
- Version tracking via `$.microUtils.version`

## Code Style
- 2-space indentation, semicolons required
- Modern JavaScript (var preferred)
- jQuery 3.x compatibility
- Modern browser support only
- Maintain UMD wrapper pattern for compatibility

## File Organization
- `src/`: Source code (single UMD module)
- `scripts/`: Development helpers
- `examples/`: Demo HTML for testing utilities

When modifying utilities, ensure backward compatibility and update version in both the source file and package.json.

