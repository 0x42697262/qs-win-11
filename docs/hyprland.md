# Hyprland setup

The shell never edits your Hyprland config and never binds keys. Everything
below is opt-in and copy-paste.

## 1. Start the shell

Run `qs -c qs-win-11` from your autostart. Stop any other bar, notification
daemon (mako, dunst, swaync) or tray host first, or turn the matching feature
off; the shell detects a taken D-Bus name and turns that feature off by
itself, logging `feature.disabled` with `busNameTaken`.

## 2. Blur

Copy one of these into your config:

| Hyprland | File |
|---|---|
| 0.55+ (Lua) | [`examples/hyprland/layerrules.lua`](../examples/hyprland/layerrules.lua) |
| Before 0.55 (hyprlang) | [`examples/hyprland/layerrules.conf`](../examples/hyprland/layerrules.conf) |

Turn `theme.transparency` off if you prefer solid surfaces.

Without compositor blur, set `wallpaper.path` to your wallpaper file: at
effects level 3 and up the shell renders Mica (a blurred wallpaper slice)
itself. Set `wallpaper.mode` to `shell` if you want the shell to draw the
wallpaper too instead of hyprpaper/swww.

## 3. Keybinds

Pick the format that matches your config:

| Format | File |
|---|---|
| Lua keymap entries `{ action, bind, chord, opts }` | [`examples/hyprland/keybinds.lua`](../examples/hyprland/keybinds.lua) |
| Plain Lua `hl.bind()` | [`examples/hyprland/binds.lua`](../examples/hyprland/binds.lua) |
| hyprchords plugin | [`examples/hyprland/hyprchords.conf`](../examples/hyprland/hyprchords.conf) |
| Legacy hyprlang `bind =` | [`examples/hyprland/keybinds.conf`](../examples/hyprland/keybinds.conf) |

All of them are generated from the IPC catalog; the full list of calls is in
[keybinds.md](keybinds.md).

### Clashes with a typical chord-based setup

The suggested Windows 11 keys can collide with existing binds. Ones to check:

| Suggested | Common clash | Option |
|---|---|---|
| `SUPER + W` (widgets) | `SUPER+W` as a chord prefix for workspaces | Bind widgets to a chord such as `SUPER+X ; W` |
| `SUPER + X` (Quick Link) | `SUPER+X` as a chord prefix | Use a chord step instead, or right-click Start |
| `SUPER + L` (lock) | An existing screen locker bind | Keep your locker; with `features.lockScreen.enabled` off, `session lock` runs `commands.lock` |
| `SUPER` on release (Start) | Any `SUPER` chord prefix | Release binds fire only when no other key was pressed in between; test it with your chords |
| `ALT + Tab` with commit on `ALT_L` release | Window cycling binds | Drop yours or bind Alt+Tab only to `altTab next` |

## 4. Idle and lock

If you already run `hypridle`, keep `features.idle.enabled` off and point its
lock command at `qs -c qs-win-11 ipc call session lock`. With
`features.lockScreen.enabled` on, that shows the shell's lock screen;
otherwise it runs `commands.lock`.

The idle screen-off step defaults to `hyprctl dispatch dpms off`. On a Lua
config, set `commands.screenOff` and `commands.screenOn` to whatever works for
your Hyprland version.

## 5. Snap layouts in Lua mode

Snap layouts build Lua dispatcher calls when `Hyprland.usingLua` is true
(`hl.dsp.window.float/resize/move`). The float `action` value is unverified;
see `AGENTS.md` → Confirmed facts. If a zone does not apply, check the shell log
for `window.placed` and Hyprland's own log for the dispatch error.
