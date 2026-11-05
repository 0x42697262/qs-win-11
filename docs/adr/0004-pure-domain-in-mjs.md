# Pure domain logic in ES modules checked by tsc

Status: accepted

## Context

QML cannot express generics or be unit tested without Qt.

## Decision

Domain logic is written as `.mjs` with JSDoc types, checked by `tsc --strict --checkJs` and tested with `node --test`. QML imports these modules directly.

## Consequences

Strict types and fast tests for every rule. Domain code cannot use Qt APIs, which is the point.
