<!-- Generated from src/domain/catalog/ipcCatalog.mjs. Copy what you need; the shell never binds keys itself. -->

# IPC and keybinds

Every action is an IPC call:

```bash
qs -c qs-win-11 ipc call <target> <function>
```

Suggested keys follow Windows 11. Ready-to-copy versions for plain Hyprland binds, Hyprland Lua configs and hyprchords are in [`examples/hyprland/`](../examples/hyprland/). Check for clashes with your existing binds first.

| Call | Does | Suggested key |
|---|---|---|
| `shell reload` | Reload the shell configuration. |  |
| `settings get` | Print the effective value of a setting key, as JSON. |  |
| `settings set` | Set a setting key to a JSON value (bare words are treated as text). |  |
| `settings reset` | Return a setting key to its default. |  |
| `start toggle` | Open or close Start. | `SUPER+SUPER_L` (on release) |
| `start allApps` | Open Start on the All apps list. |  |
| `search toggle` | Open or close Search. | `SUPER+S` |
| `quickLink toggle` | Open or close the Quick Link menu. | `SUPER+X` |
| `quickSettings toggle` | Open or close Quick Settings. | `SUPER+A` |
| `notifications toggle` | Open or close the notification center. | `SUPER+N` |
| `notifications clearAll` | Dismiss every notification. |  |
| `notifications toggleDoNotDisturb` | Turn do not disturb on or off. |  |
| `audio volumeUp` | Raise volume by one step. | `XF86AudioRaiseVolume` |
| `audio volumeDown` | Lower volume by one step. | `XF86AudioLowerVolume` |
| `audio toggleMute` | Mute or unmute output. | `XF86AudioMute` |
| `audio toggleMicrophoneMute` | Mute or unmute the microphone. | `XF86AudioMicMute` |
| `brightness up` | Raise brightness by one step. | `XF86MonBrightnessUp` |
| `brightness down` | Lower brightness by one step. | `XF86MonBrightnessDown` |
| `session lock` | Lock the session. | `SUPER+L` |
| `session menu` | Open the full-screen session menu. | `CTRL+ALT+Delete` |
| `session suspend` | Sleep. |  |
| `session hibernate` | Hibernate. |  |
| `session signOut` | Sign out of the session. |  |
| `session restart` | Restart the computer. |  |
| `session powerOff` | Shut down the computer. |  |
