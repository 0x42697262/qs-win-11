# Sources of truth

Each row has exactly one owner. Everything else reads it or derives from it.

| State | Owner | Others |
|---|---|---|
| User preferences, including Quick Settings tiles | `settings.json` via `Settings` | Read only; writes go through `Settings.update()` |
| Shell data: pinned apps, do not disturb, cached location | `state.json` via `ShellData` | Read only; writes through the owning service |
| Theme colors, sizes, motion | Derived in `Theme` from settings and the clock | Never stored |
| Effective features | Derived by `resolveFeatures()` in `Features` | UI reads `Features` only |
| Windows, workspaces, monitors | Compositor, through the active `CompositorAdapter` | Mirrored by events; resynced on reconnect |
| Most recently used window order | `WindowsService` (no system owns it) | Read only |
| Volume, sinks | PipeWire | Sliders preview locally, then follow PipeWire |
| Wi-Fi, networks | NetworkManager | Same |
| Bluetooth | BlueZ | Same |
| Battery, power profile | UPower, power-profiles-daemon | Same |
| Brightness | `/sys/class/backlight` (polled every second) | Written through `commands.brightness` |
| Airplane mode | Derived: Wi-Fi off and Bluetooth off | Toggling sets both |
| Night light | The running `commands.nightLight` process | Tile reflects whether it runs |
| Media | MPRIS players | Playing player first |
| Do not disturb | `state.json` `doNotDisturb` | Notifications read it |
| Installed apps | `.desktop` files via `DesktopEntries` | Pinned lists store app ids only |
| Notifications | `NotificationServer` | Toasts and the center are two views of one list |
| Open surface and its payload | `ShellState.state` | Surfaces, taskbar button states and the flyout host bind to it |
| Tooltip text and position | `ToolTips` | One click-through `ToolTipLayer` per screen draws it |
| Taskbar and Start pins | `state.json` (`taskbarPinnedApps`, `startPinnedApps`); before the first change, `taskbar.initialPinned` / `startMenu.initialPinned` settings | `Apps` filters to installed entries |

## Rebuilding derived state

| Derived | Rebuild |
|---|---|
| Theme | Recomputed on every settings or clock change |
| Features | Recomputed on settings or capability change |
| Theme QML token groups (`src/ui/theme/Theme*Metrics.qml`, `ThemeColors.qml`) | `npm run gen` from `tokens.mjs` |
| Window mirror | `CompositorAdapter.resync()` |
| Cached location | Delete `location` from `state.json`, it is fetched again |
