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
2. **No magic values.** Numbers, colors, user text, icon glyphs, log event
   names, IPC names and settings live only in `src/domain/catalog/`
   (`tuning.mjs`, `tokens.mjs`, `strings.mjs`, `icons.mjs`, `logEvents.mjs`,
   `ipcCatalog.mjs`, `settingsSchema.mjs`, `shellDataSchema.mjs`,
   `features.mjs`). Elsewhere only `0`, `1`, `2`, `-1` and `0.5` appear as
   literals. Setting labels and descriptions live with their schema entry.
   (hard rule)
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
| `tools/ci/qml-check.sh` | Load the shell headless, run the IPC scenes in `tools/ci/scenes.txt`, screenshot each, qmllint (needs Quickshell, sway, grim) |
| `QS_WIN11_GALLERY=1 qs -c qs-win-11` | Debug-only component gallery, off unless the variable is set |

Generated files are never edited by hand: `docs/configuration.md`, `docs/keybinds.md`, `examples/`, and `src/ui/theme/ThemeColors.qml` plus `Theme*Metrics.qml`.

## Confirmed facts

| Fact | Verified in |
|---|---|
| Quickshell exposes `ToplevelManager` (wlr-foreign-toplevel) with `activate`, `close`, `minimized`, `maximized` | quickshell `src/wayland/toplevel/qml.hpp` |
| `Hyprland.refreshToplevels()`, `refreshWorkspaces()`, `refreshMonitors()` force a resync | quickshell `src/wayland/hyprland/ipc/qml.hpp` |
| Quickshell ships `Networking`, `Bluetooth`, `UPower`, `PowerProfiles`, `Pipewire`, `Mpris`, `NotificationServer`, `SystemTray`, `Pam`, `WlSessionLock`, `IdleMonitor` | quickshell `src/` tree, 0.3.2 |
| Files with `pragma Singleton` under the shell dir are importable as `qs.<path>` | Quickshell 0.3.2 VFS output |
| qmllint reports `PanelWindow` as uncreatable; this is a false positive and the check is disabled | qmllint 6.12 against Quickshell 0.3.2 |
| QML imports `.mjs` ES modules directly | Quickshell 0.3.2 runtime |
| The QML engine lacks object spread, optional catch binding, `flatMap`, `flat`, `replaceAll`, `matchAll`, `at`, `trimEnd`, `Object.fromEntries`, `structuredClone`, `Intl`. `src/` is type-checked against the ES2017 library and `check-banned` rejects the syntax | Probe script under Quickshell 0.3.2 / Qt 6.12 |
| Quickshell's tooling VFS symlinks files, so qmllint resolves them to the source folder and misses the generated `qmldir`. CI lints a copy with the `qmldir` files placed next to the sources | qmllint 6.12 |
| qmllint still reports "not declared as singleton in qmldir" for singleton files in that copy although the `qmldir` declares them; CI filters only that message | qmllint 6.12 |
| CI has a session bus but no system bus, so UPower logs "Could not connect to DBus"; CI ignores only that line | CI container |

Add a row whenever you rely on a third-party behavior.

## Verification checklist

Every PR adds one line per behavior change: what to do, what to see.

| Feature | Check | Expected |
|---|---|---|
| Foundation | `npm run verify` | All green |
| Foundation | `qs -p .` | Shell loads with no warnings in the log |
| Settings | Write `{"schemaVersion":1,"values":{"theme":{"mode":"light"}}}` to `settings.json` | Log shows no `settings.invalid`; theme flips to light live |
| Settings | Set `"taskbar":{"alignment":"diagonal"}` | One `settings.invalid` line for `taskbar.alignment`, shell keeps running |
| Features | Uninstall or rename `hyprsunset` | `feature.disabled` with `missingCapability` for `nightLight` |
| Settings IPC | `qs -c qs-win-11 ipc call settings set theme.mode light` | Prints `true`; theme switches live; `settings get theme.mode` prints `"light"` |
| Components | `QS_WIN11_GALLERY=1 qs -c qs-win-11` | Gallery panel shows every control; matches CI screenshots in both themes |
| Theme sync | Switch theme mode | `gsettings get org.gnome.desktop.interface color-scheme` follows |
