# Architecture

## Data flow

```
keybind -> qs ipc call -> src/ipc handler ─┐
click / key in a surface ──────────────────┤
                                           v
                                    src/services  ── reads ──> src/domain (pure)
                                           │
                                           v
                                    src/adapters  ──> compositor, PipeWire, NetworkManager,
                                                      BlueZ, UPower, files, processes, HTTP
```

State flows back the other way: adapters expose what the system reports,
services derive view state through domain functions, surfaces bind to it.

## Folders

| Path | Holds |
|---|---|
| `shell.qml` | Composition root: one `Variants` per screen, mounts surfaces |
| `src/config` | `Environment`, `Paths`, `Tuning`, `Settings` |
| `src/domain` | Pure `.mjs`: schema, migrations, feature resolution, ranking, grouping, calendar, theme tokens, catalogs |
| `src/adapters` | `compositor/`, `storage/`, `system/` |
| `src/services` | One singleton per area: windows, apps, audio, network, power… |
| `src/ipc` | `IpcHandler`s, one per target in the IPC catalog |
| `src/ui/theme` | `Theme` singleton: derives tokens from settings |
| `src/ui/components` | Shared controls |
| `src/ui/features/<feature>` | Surfaces: taskbar, start, quick settings, … |
| `tests/domain` | `node --test` for every domain module |
| `tools` | Banned-pattern check, generators, CI scripts |

## Surfaces and the flyout host

Only one transient surface is open at a time. `ShellState.openSurface`
(enum) plus `ShellState.openScreen` is the single record of it. Each screen
has one `FlyoutHost`: a full-screen transparent layer that exists only while
something is open on that screen, positions the open surface, closes it on an
outside click or Escape, and takes keyboard focus. Taskbar buttons toggle
through `ShellState`, so a second click closes.

## Compositor support

See [ADR 0002](adr/0002-compositor-adapter.md). UI checks capability flags,
never the compositor name.
