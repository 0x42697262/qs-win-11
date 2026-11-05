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
2. **Every value is a setting.** Sizes, colors, motion, effects, tuning,
   user text and icons have their defaults, bounds and units in
   `src/domain/catalog/` (`tokens.mjs`, `tuning.mjs`, `strings.mjs`,
   `icons.mjs`, …). `valueDefinitions.mjs` turns them into settings, and code
   reads the resolved value from `Settings.values` or `Theme`, never from the
   catalogs (`check-banned` enforces this). Identifiers that are not
   preferences (D-Bus names, IPC names, file formats, unit conversions in
   `units.mjs`) stay constants. Elsewhere only `0`, `1`, `2`, `-1` and `0.5`
   appear as literals. (hard rule)
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
| `PopupWindow` anchors and `QsMenuAnchor` do not resolve cleanly in qmllint 6.12; tooltips use a click-through layer and tray menus use `SystemTrayItem.display()` | qmllint 6.12 against Quickshell 0.3.2 |
| Quickshell ships `Networking`, `Bluetooth`, `UPower`, `PowerProfiles`, `Pipewire`, `Mpris`, `NotificationServer`, `SystemTray`, `Pam`, `WlSessionLock`, `IdleMonitor` | quickshell `src/` tree, 0.3.2 |
| Files with `pragma Singleton` under the shell dir are importable as `qs.<path>` | Quickshell 0.3.2 VFS output |
| qmllint reports `PanelWindow` as uncreatable; this is a false positive and the check is disabled | qmllint 6.12 against Quickshell 0.3.2 |
| QML imports `.mjs` ES modules directly | Quickshell 0.3.2 runtime |
| The QML engine lacks object spread, optional catch binding, `flatMap`, `flat`, `replaceAll`, `matchAll`, `at`, `trimEnd`, `Object.fromEntries`, `structuredClone`, `Intl`. `src/` is type-checked against the ES2017 library and `check-banned` rejects the syntax | Probe script under Quickshell 0.3.2 / Qt 6.12 |
| Quickshell's tooling VFS symlinks files, so qmllint resolves them to the source folder and misses the generated `qmldir`. CI lints a copy with the `qmldir` files placed next to the sources | qmllint 6.12 |
| qmllint still reports "not declared as singleton in qmldir" for singleton files in that copy although the `qmldir` declares them; CI filters only that message | qmllint 6.12 |
| Hyprland's Lua config mode changes dispatcher syntax; Quickshell exposes `Hyprland.usingLua` and `HyprlandWorkspace.activate()` handles both forms. Our Hyprland adapter focuses, closes and minimizes through each window's Wayland handle, so it needs no dispatcher strings | quickshell `src/wayland/hyprland/ipc/workspace.cpp`, `qml.hpp` |
| `qs ipc call` drops square brackets from arguments, so `["foot"]` arrives as `"foot"`; list settings accept comma-separated text over IPC instead | Quickshell 0.3.2 IPC, CI scene run |
| Arrays passed through `var` parameters of QML functions arrive as sequence objects, not JS arrays; domain validation copies array-likes | Quickshell 0.3.2 runtime |
| `WlSessionLock` needs ext-session-lock; sway and Hyprland support it. The lock screen authenticates with `PamContext` using the default `login` PAM config | Quickshell 0.3.2, CI run under sway |
| sway ignores foreign-toplevel minimize requests, so show desktop cannot be verified in CI | CI run under sway |
| GeoClue is used through its `where-am-i` demo binary (`/usr/lib/geoclue-2.0/demos/where-am-i`) when present; Open-Meteo needs no API key; ipwho.is returns `success`, `latitude`, `longitude`, `city` | GeoClue 2 packaging, live requests from the CI container |
| Qt's Wayland text-input logs "QWaylandTextInputv3::disableSurface … 0x0 is focused" when a focused field's window hides under sway; it is harmless and CI ignores only that line | Qt 6.12 under sway |
| Hyprland Lua mode: `hl.dsp.window.move/resize({ x, y, relative?, window? })` and `hl.dsp.window.float({ action?, window? })`, window selector `address:0x…`; Quickshell's `Hyprland.dispatch()` sends Lua expressions as-is. **Unverified:** the float `action` value `"set"` (taken from the fullscreen dispatcher's toggle/set/unset) and that the socket accepts these strings outside `hl.dispatch()` | Hyprland wiki 0.56 dispatchers page (summary), quickshell `workspace.cpp` |
| Snap placement runs only on Hyprland; sway in CI cannot exercise it | CI run under sway |
| `MultiEffect` (QtQuick.Effects) provides blur, saturation, brightness and masking without custom shaders; Mica blurs the wallpaper image in-process, so it works on compositors without blur | Qt 6.12, CI screenshots |
| `wf-recorder` records the headless sway output for the README demo; it cannot capture a locked session, so the lock screen appears only in screenshots. `wtype` drops the first key of each call under sway, so demo typing starts with a space | Demo recording runs |
| Nested Qt Quick layouts default to filling width; side-by-side columns need `Layout.fillWidth: false` and explicit widths | Start search details pane bug |
| In `on<Property>Changed` handlers, other bindings derived from the same property may not have updated yet; read the source property directly (the flyout host bug) | Qt 6.12 binding evaluation |
| CI has a session bus but no system bus, so UPower logs "Could not connect to DBus" and Networking finds no backend; CI ignores only those lines. PipeWire runs with a null sink so audio paths are exercised | CI container |
| `IdleInhibitor` (Quickshell.Wayland) inhibits idle while its window is mapped; Stay awake uses a 1×1 background-layer window. **Unverified:** that every compositor honors idle-inhibit on layer surfaces | Quickshell 0.3.2 qmltypes |
| `nmcli -t` escapes `:` inside fields as `\:`; VPNs have type `vpn` or `wireguard` | NetworkManager nmcli(1) |
| `ddcutil detect --brief` prints `Display N` blocks with `I2C bus: /dev/i2c-N` and `Monitor: MFG:MODEL:SERIAL`; `getvcp 10 --brief` prints `VCP 10 C <current> <max>` | ddcutil 2.x man page |
| Hyprland: `hyprctl devices -j` lists keyboards with `active_keymap`, `main`, `capsLock`, `numLock`; `getoption input:kb_layout -j` returns `str`; the `activelayout` event carries `keyboard,layout` | Hyprland wiki (IPC, hyprctl) |
| A `required property` list bound from a singleton may still be empty in `Component.onCompleted`; the capability probe re-runs on `onBinariesChanged` via `Qt.callLater` (before this fix no binary capability was ever detected) | CI log `capability.probed` |
| ImageMagick 7 `magick <img> -resize WxH! -depth 8 txt:-` prints `x,y: (r,g,b,a)` per pixel; IM6 ships the same as `convert` | ImageMagick txt coder, CI container |
| Without a GPU render node `ScreencopyView` logs "Failed to find render device" and falls back to SHM buffers; it still works, and CI ignores only those two lines | CI container |
| `grim -g "x,y wxh"` takes global logical coordinates; `grim -o <output>` captures one output; `notify-send -A name=Label` waits and prints the chosen action | grim(1), libnotify 0.8 |
| `Quickshell.clipboardText` is read/write; setting it copies text to the Wayland clipboard | Quickshell 0.3.2 qmltypes |
| Some Quickshell models are typed `UntypedObjectModel` in qmltypes that qmllint cannot follow across modules; casting with `as ObjectModel` resolves `values` | qmllint 6.12 |

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
| Compositor | Start under Hyprland, then under sway | Log shows `compositor.selected` with `hyprland`, then `generic` |
| Compositor | `qs -c qs-win-11 ipc call settings set compositor.kind '"generic"'` on Hyprland | Switches to the generic adapter live; windows still listed |
| Taskbar | Open two windows of one app | One taskbar button with a short dash; focusing it widens the dash to an accent pill |
| Taskbar | Click the button of the active single window | Window minimizes (generic adapter) or stays focused (Hyprland, no minimize capability) |
| Taskbar | Right-click an app button | Context menu with New window, Pin/Unpin, Close; pin state survives a restart in `state.json` |
| Taskbar | `settings set taskbar.alignment '"left"'` | Buttons slide to the left edge |
| Taskbar | `settings set taskbar.autoHide true` | Taskbar hides after the pointer leaves and returns at the bottom edge; windows use the full height |
| Tray | Start an app with a tray icon, click the chevron | Overflow flyout lists it; left click activates, right click opens its menu |
| Start | `qs -c qs-win-11 ipc call start toggle` | Start opens above the taskbar with Pinned, Recommended and your avatar; typing searches; Enter launches the best match |
| Start | Open Start, scroll | One page: Pinned (two rows, "Show all" expands), Recommended, then All with Category / Grid / List; the choice persists in `startMenu.allAppsView` |
| Start | `ipc call start allApps` | Start opens scrolled to the All section |
| Start | Right-click a pinned tile | Pin/Unpin to Start and taskbar; change persists in `state.json` |
| Start | Power button in Start | Lock, Sign out, Sleep, Shut down, Restart |
| Search | `qs -c qs-win-11 ipc call search toggle`, type part of an app name | Best match first, details pane with Open and pin actions; arrow keys move the selection |
| Search | Type `sqrt(144)+2^3` in Start or Search | Calculator result `20` first; Enter copies it to the clipboard; `startMenu.searchCalculator false` hides it |
| Search | Type `accent` | A Settings group lists matching settings; Enter opens the Settings app filtered to that key |
| Run | `ipc call run toggle` (or Quick Link → Run), type a command, Enter | Command runs; reopening lists it under recent commands; Up/Down recall history (`tuning.runHistoryLimit`) |
| Quick Link | Right-click Start or `ipc call quickLink toggle` | Menu with terminal, task manager, file manager, network, search, lock and power entries |
| Session | `qs -c qs-win-11 ipc call session lock` with `features.lockScreen.enabled` off | Runs `commands.lock` (default `loginctl lock-session`) |
| Quick Settings | `ipc call quickSettings toggle` or click the network/volume/battery cluster | Flyout bottom-right with available tiles only, brightness and volume sliders, battery in the footer |
| Quick Settings | Drag the volume slider, then run `wpctl get-volume @DEFAULT_AUDIO_SINK@` | Value matches; the slider follows external changes too |
| Quick Settings | Scroll over the taskbar cluster | Volume steps by 5% |
| Quick Settings | Wi-Fi chevron, pick an unknown secured network | Password field and Connect button; known networks connect directly |
| Quick Settings | Pencil, toggle tiles, Done | `quickSettings.tiles` in `settings.json` updates; hidden tiles stay hidden after restart |
| Quick Settings | Dark mode tile | `theme.mode` flips; whole shell re-themes live |
| Quick Settings | Stay awake tile or `ipc call modes toggleStayAwake` | Coffee icon in the taskbar cluster; idle stages and compositor idle daemons stop until it is turned off |
| Quick Settings | Game mode tile or `ipc call modes toggleGameMode` | Effects drop to level 0 (or your `game` profile applies, above your own settings); banners pause; turning it off restores everything |
| Quick Settings | With a NetworkManager VPN configured | VPN tile shows its name; clicking connects or disconnects (`quickSettings.vpnConnection` picks which) |
| Quick Settings | With `ddcutil` working on an external monitor | One extra brightness slider per monitor; the value lands on the monitor after `tuning.displayBrightnessDelayMs` |
| Taskbar | Hyprland with `kb_layout = us,de` | "ENG US" button left of the cluster; click or `ipc call keyboard nextLayout` switches layout and the label follows |
| OSD | Bind the generated Caps_Lock release example, press Caps Lock | Pill reads "Caps Lock on" / "Caps Lock off" (read from `/sys/class/leds`) |
| Notifications | `notify-send -a Mail "Hello" "Body"` | Toast bottom-right for `notifications.toastSeconds`; hovering keeps it; it also appears in the center |
| Notifications | `notify-send -u critical "Battery low"` | Toast with red border stays until dismissed, even with do not disturb on |
| Notifications | Turn on do not disturb, send a normal notification | No toast; it still appears in the center; taskbar cluster shows the snooze bell |
| Notifications | Run mako or dunst first, then start the shell | `feature.disabled` with `busNameTaken`; no toasts from the shell; calendar still opens from the clock |
| Notification center | Click the clock or `ipc call notifications toggle` | Notifications grouped by app with relative times, Clear all, calendar with today highlighted and month navigation |
| OSD | Change volume with `wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-` or `ipc call audio volumeDown` | Pill above the taskbar with icon, bar and percent for 1.5 s; no pill during the first 2 s after start |
| OSD | `ipc call audio toggleMicrophoneMute` | Pill reads "Microphone muted" / "Microphone on" |
| OSD | `ipc call brightness up` on a laptop | Brightness rises 5% and the pill shows it |
| Session menu | `ipc call session menu` | Full-screen dim with Lock, Sign out, Sleep, Restart, Shut down and Cancel; Escape closes |
| Lock screen | Enable `features.lockScreen.enabled`, `ipc call session lock` | Session locks with clock and date; any key shows the avatar and password field; a wrong password shows an error and a 2 s cooldown; the right one unlocks |
| Idle | Enable `features.idle.enabled`, set `idle.dimSeconds` to 10 | Screens dim after 10 s idle, undim on input; later stages lock, run `commands.screenOff`, then sleep |
| Battery alerts | On battery, drop below `power.lowBatteryPercent` | One "Battery low" notification per crossing; critical level runs `power.criticalAction` |
| Task View | `ipc call taskView toggle` (or the taskbar button) | Cards for windows on the focused workspace; Hyprland adds a desktops strip that switches workspace on click; hover shows a close button |
| Alt+Tab | Bind `altTab next` to Alt+Tab and `altTab commit` to Alt release, press Alt+Tab twice | Switcher in recent-use order, selection advances, releasing Alt focuses it |
| Show desktop | `ipc call desktop toggle` on a compositor that honors minimize (labwc, KDE) | All windows minimize; again restores exactly those. Hidden on Hyprland, which has no minimize |
| Widgets | `ipc call widgets toggle` or the weather button on the taskbar | Board slides in from the left with weather, 5-day forecast, CPU and memory, media when playing, and the calendar |
| Widgets | Open widgets | Performance card lists CPU, GPU (AMD sysfs or nvidia-smi), memory with live graphs, storage used of total, network down/up rates, battery; `widgets.performanceMetrics` reorders or hides rows |
| Visualizer | Install cava, `settings set features.visualizer.enabled true`, play music, open widgets | Accent bars under the media card move with the audio; cava stops when the board closes or playback pauses |
| Desktop clock | `settings set features.desktopClock.enabled true` | Large time and date on the desktop under windows, at `desktopClock.position`; clicks pass through |
| Snipping | `ipc call snip open` (suggested Super+Shift+S) | Screen freezes and dims; toolbar with Rectangle / Window (Hyprland) / Full screen and Screenshot / Record; dragging saves to `capture.screenshotDirectory`, copies it, and a notification offers Open, Edit, Show folder |
| Snipping | `ipc call snip screen` or `snip area "0,0 800x600"` | Saved without the overlay |
| Recording | Choose Record, drag an area | Red record button on the taskbar; clicking it or `snip stop` ends the recording (gpu-screen-recorder, else wf-recorder) and notifies with the file |
| Color picker | `ipc call colorPicker open`, hover, click | Loupe magnifies the frozen screen; the clicked color's hex lands on the clipboard with a notification |
| Emoji panel | `ipc call panel emoji` (suggested Super+.), type `heart` | Panel above the taskbar with Emoji, Kaomoji, Symbols, Clipboard tabs; results filter live; clicking one copies it and types it with wtype (`clipboard.typeAfterPick`); recent picks lead the Emoji tab |
| Clipboard history | Run `wl-paste --watch cliphist store` (or `clipboard.runWatcher`), copy two things, `ipc call panel clipboard` | Newest first, images marked; click restores it to the clipboard; trash deletes one; Clear all wipes |
| Weather | Leave `weather.locationMode` on `auto` without GeoClue | `location.resolved` with `ipLookup` once; `state.json` caches the location for 6 hours; "Approximate location" shown |
| Weather | `settings set weather.allowIpLookup false` with no GeoClue and no cache | Weather card asks for a location; nothing is sent to ipwho.is |
| Weather | Disconnect the network | Card shows "Couldn't load weather"; the rest of the board still works |
| Settings app | `ipc call settings open`, Quick Settings gear, or Quick Link → Settings | Window with a section per schema section plus About; every setting has a control; changes apply live and land in `settings.json` |
| Settings app | Put an invalid value in `settings.json` by hand | Warning banner listing the key, the row outlined, and one notification |
| Settings app | About page | Version, compositor, settings file path, and each feature with its effective state and off reason |
| Snap layouts | On Hyprland, focus a window, `ipc call snap open`, pick a zone | Window floats and fills that zone of the focused monitor's usable area (taskbar excluded) with small gaps; log shows `window.placed` with `usingLua` |
| Hover thumbnails | `settings set experimental.hoverThumbnails true`, hover a running app | Live previews of its windows above the taskbar |
| Values | `settings set text.taskbar.start Begin`, `settings set icons.grid fluent:apps_24`, `settings set colors.dark.taskbarBackground '#ff3a1f5d'` | Tooltip, Start icon and taskbar color change live; `settings reset <key>` restores each |
| Values | `settings set tuning.brightnessPollMs 1` | Rejected (`false`); with `experimental.unboundedValues` on it is accepted and Settings shows the red warning |
| Icons | `settings set icons.search 'image:/path/to/icon.svg'` or `'font:Material Symbols Rounded:e8b6'` | That icon renders from the file or font |
| Settings app | "Changed only" | Lists only overridden keys, each with its default and a reset button |
| Effects | Settings → Appearance, drag the level slider | Table shows what the level allows, your choice and the result per effect; surfaces change live (0 opaque and still, 4 translucent with layered shadows, edge highlight and scale-in) |
| Effects | `settings set appearance.override.backdrop mica` at level 0 | Result reads "solid (limited by level)"; raising the level applies mica |
| Effects | `settings set appearance.levelOnBattery 1`, unplug | Level drops to Light on battery, back on AC |
| Effects | `settings set appearance.style flat` | Today's flat look at any level |
| Corners | Level 2+ (continuous corners), zoom on a flyout corner | No visible kink where the edge starts to curve; `corners.smoothing 0` gives a circle, `1` the softest curve |
| Corners | `settings set corners.model superellipse`, `corners.exponent 4` | Corners switch to a superellipse live |
| Corners | `settings set appearance.override.corners circular` | Plain circular corners (cheapest) |
| Mica | `settings set wallpaper.path /path/to/image.jpg` at level 3+ | Taskbar and flyouts show the blurred wallpaper slice under them, tinted, with faint grain; flyouts line up with the wallpaper behind them |
| Mica | Clear `wallpaper.path` | Falls back to acrylic tint (compositor blur if you added the layer rules) |
| Wallpaper | `settings set wallpaper.mode shell` | The shell draws the wallpaper on the background layer; `external` leaves it to your tool |
| Wallpaper | Settings → Wallpaper, or `ipc call settings openSection wallpaper` | Grid of images from `wallpaper.directory`; clicking one sets `wallpaper.path`; `ipc call wallpaper next` / `previous` cycle through them |
| Accent | `settings set theme.accentFromWallpaper true` with ImageMagick installed | Accent changes to the wallpaper's most vivid color; `state.json` caches it per wallpaper; turning it off restores `theme.accentColor` |
| Lock screen | Lock with a wallpaper set and something playing | Wallpaper behind the clock; weather bottom-left, media card with play/pause, network, battery and notification count bottom-right; the background blurs and dims when the password field shows |
| App theming | `ipc call theming render` | `~/.config/qs-win-11/themes/` holds gtk, qt, foot, kitty, alacritty, btop, fish, starship, nvim, zed, vscode and fuzzel files in the current colors; nothing else on disk changes |
| App theming | `settings set features.appTheming.enabled true`, then switch dark mode | Files re-render after `tuning.appThemeDelayMs`; `commands.afterAppTheme` runs once; log shows `appTheme.rendered` |
| App theming | Add `~/.config/qs-win-11/themes/templates/mako.tmpl` with `background-color={{ background }}` | `themes/custom/mako` appears with the hex color; unknown placeholders are logged, not dropped |
| Backdrop | Change `backdrop.micaBlur`, `micaSaturation`, `grainOpacity` | Live change on the next open flyout |
| Profiles | `ipc call settings exportProfile /tmp/look.json`, change things, `ipc call settings importProfile /tmp/look.json` | Every changed setting returns to the exported state; unknown or invalid keys are listed in `profile.imported` as skipped |
| Search | Type in Start or the Search flyout | Results list on the left, details pane (icon, name, Open, pin actions) fills the right side |
| Effects | Change `appearance.level` or `appearance.style` while Start is open | Start re-renders with the new material and keeps its content |
| Profiles | `ipc call profiles create neon icons`, reset your icon changes, `ipc call profiles activate neon` | Icons come back from the profile; the Icons rows say "From profile neon" |
| Profiles | Profile with `"activateWhen": {"theme": "light"}` in the stack | Applies only while your theme resolves to light |
| Profiles | Profile that sets `commands.lock` | Key skipped and a warning with a Trust button; after trusting, the command applies |
| App icons | `settings set appIcons.theme Papirus` | Taskbar, Start, search and notifications use Papirus app icons; icons Papirus lacks fall back to the system theme; log shows `icons.themeIndexed` |
| App icons | `settings set appIcons.overrides firefox=/path/fox.svg` | Only Firefox's icon changes, everywhere |
| Motion | Open and close any flyout | Opens with an eased slide and fade (`motion.durations.enter`), closes with a quick fade-down (`motion.durations.exit`); clicks pass through while it closes |
| Motion | Toggle dark mode | Every color crossfades (`motion.durations.theme`) instead of snapping |
| Motion | Click a taskbar icon | Icon dips and springs back (`motion.durations.press`, `effects.elevation.pressOvershoot`) |
| Motion | `settings set theme.reduceMotion true` or effects level 0 | All of the above become instant |
| Motion | Open Quick Settings, open the Wi-Fi page, go back | Detail page slides in from the right, main page slides back from the left (`motion.durations.page`) |
| Motion | Change month in the calendar | Day grid slides vertically in the direction of travel |
| Motion | Open Start or the notification center | Tiles and groups fade and rise in sequence (`motion.durations.stagger`, `effects.elevation.staggerLimit`) |
| Notifications | Drag a toast or card to the right past `effects.elevation.swipeDismissFraction` | It slides out and is dismissed; a short drag springs back |
| Taskbar | Launch a pinned app from the taskbar or Start | Its taskbar icon bounces once (`motion.durations.bounce`, `effects.elevation.launchBounce`) |
| Tooltips | Hover across taskbar buttons | Tooltip fades in, glides between buttons and fades out |
| Comfort | `settings set theme.fontScale 1.25`, `settings set theme.textContrast 0.3` | Text grows everywhere; secondary text gets darker in light mode, brighter in dark mode |
| Theme sync | Switch theme mode | `gsettings get org.gnome.desktop.interface color-scheme` follows |
