# Effects level as a budget

Status: accepted

## Context

Users want a single slider from battery saver to maximum, plus full control
over each effect, plus a flat style, without the three fighting each other.

## Decision

`appearance.level` picks a bundle (editable under `appearance.levels.*`) that
sets the most expensive value each effect may use. `appearance.style` and
`appearance.override.*` choose values inside that budget; a choice above it
falls back to the level value and is shown as "limited by level".
`appearance.levelOnBattery` swaps the budget while on battery. The resolution
is one pure function, `resolveAppearance()`, with tests.

## Consequences

Battery saver always saves, explicit choices come back on AC, and the Settings
app can show exactly why each effect has its value.
