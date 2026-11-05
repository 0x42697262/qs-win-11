# Store only user overrides in settings.json

Status: accepted

## Context

Persisting every default means changing a default needs a migration for everyone.

## Decision

`settings.json` holds `schemaVersion` and only keys the user changed. Defaults come from `settingsSchema.mjs`. Renames and restructures are migrations; changed defaults reach every user who never touched the key.

## Consequences

Smaller files, safer default changes. A deliberate deviation from 'persisted defaults need a backfill', because defaults are never persisted.
