# Working on qs-win-11

Rules for humans and coding agents. **(hard rule)** items fail review or CI.
Architecture is in [`docs/architecture.md`](docs/architecture.md); decisions are
in [`docs/adr/`](docs/adr/).

## Layers

```
ipc/ + ui/ events  ->  services/  ->  domain/ (pure .mjs)  ->  adapters/
```

| Layer | Job | Must not |
|---|---|---|
| `src/ipc`, UI event handlers | Parse input, call one service function | Hold rules or talk to adapters |
| `src/services` | One use case area each; expose read-only state, own actions | Draw UI |
| `src/domain` | Pure functions, enums, schemas, catalogs (`.mjs`) | Import Qt, read env, clock or files |
| `src/adapters` | Compositor, storage, processes, HTTP | Make product decisions |
| `src/config` | `Environment` (only reader of env vars), `Tuning`, `Settings` | Be bypassed |
| `src/ui` | Theme, components, feature surfaces | Import `Quickshell.Hyprland`, `Pipewire` or other system modules |

## Hard rules

1. **No explanatory comments.** Names explain *what*; `docs/` explains *why*.
   JSDoc type annotations are allowed. (hard rule)
2. **No magic values.** Numbers live in `Tuning.qml` or theme tokens, colors
   only in `src/domain/theme/tokens.mjs`, user text in
   `src/domain/text/strings.mjs`, log event names in `logEvents.mjs`, icons in
   `icons.mjs`, IPC names in `ipcCatalog.mjs`, settings in
   `settingsSchema.mjs`. (hard rule)
3. **No single-character names**, including loop counters and lambda
   parameters. (hard rule)
4. **One source of truth.** Every piece of state has one owner listed in
   [`docs/state.md`](docs/state.md). Never cache a system value in the UI.
   (hard rule)
5. **Strict types.** `.mjs` is checked by `tsc --strict` through JSDoc. QML
   uses typed properties, typed function signatures, `required property` and
   `pragma ComponentBehavior: Bound`; `var` only for plain data from domain.
   qmllint runs with zero warnings. (hard rule)
6. **Persisted data is versioned** with `schemaVersion` and migrated on read.
   (hard rule)
7. **Degrade, never crash.** A missing service, binary or invalid setting turns
   off one feature, logs the reason and keeps the shell running.
8. **The shell never binds keys.** Everything is reachable over IPC; examples
   are generated for users to copy. (hard rule)
9. American English everywhere.

## Commands

| Command | Does |
|---|---|
| `npm run verify` | Type check, banned patterns, domain tests, generated files |
| `npm run gen` | Regenerate `docs/configuration.md`, `docs/keybinds.md`, `examples/` |
| `tools/ci/qml-check.sh` | Load the shell headless, screenshot scenes, qmllint (needs Quickshell, sway, grim) |

Generated files are never edited by hand.

## Confirmed facts

| Fact | Verified in |
|---|---|
| Quickshell exposes `ToplevelManager` (wlr-foreign-toplevel) with `activate`, `close`, `minimized`, `maximized` | quickshell `src/wayland/toplevel/qml.hpp` |
| `Hyprland.refreshToplevels()`, `refreshWorkspaces()`, `refreshMonitors()` force a resync | quickshell `src/wayland/hyprland/ipc/qml.hpp` |
| Quickshell ships `Networking`, `Bluetooth`, `UPower`, `PowerProfiles`, `Pipewire`, `Mpris`, `NotificationServer`, `SystemTray`, `Pam`, `WlSessionLock`, `IdleMonitor` | quickshell `src/` tree, 0.3.2 |
| Files with `pragma Singleton` under the shell dir are importable as `qs.<path>` | Quickshell 0.3.2 VFS output |
| qmllint reports `PanelWindow` as uncreatable; this is a false positive and the check is disabled | qmllint 6.12 against Quickshell 0.3.2 |
| QML imports `.mjs` ES modules directly | Quickshell 0.3.2 runtime |

Add a row whenever you rely on a third-party behavior.

## Verification checklist

Every PR adds one line per behavior change: what to do, what to see.

| Feature | Check | Expected |
|---|---|---|
| Foundation | `npm run verify` | All green |
| Foundation | `qs -p .` | Shell loads with no warnings in the log |
