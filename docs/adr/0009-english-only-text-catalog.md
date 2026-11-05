# English-only text catalog

Status: accepted

## Context

Translations are out of scope, but inline text is still banned.

## Decision

All user-facing text lives in `src/domain/text/strings.mjs`, American English. No `qsTr`.

## Consequences

One place to edit copy. Adding translation later means swapping the catalog for a lookup.
