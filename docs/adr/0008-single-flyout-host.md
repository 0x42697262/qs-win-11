# One open surface, one host per screen

Status: accepted

## Context

Each flyout as its own window leads to several open at once and duplicated dismiss logic.

## Decision

`ShellState.openSurface` and `openScreen` are the only record of what is open. A `FlyoutHost` per screen renders it, handles outside clicks, Escape and keyboard focus. Opening another surface replaces the current one.

## Consequences

One place for dismissal, focus and animation. Surfaces are plain items.
