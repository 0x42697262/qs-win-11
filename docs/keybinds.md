<!-- Generated from src/domain/catalog. Copy what you need; the shell never binds keys or edits your config. -->

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
| `settings open` | Open the Settings app. | `SUPER+I` |
| `settings openSection` | Open the Settings app on a section, such as wallpaper or theme. |  |
| `settings exportProfile` | Write every changed setting to a profile file (absolute path). |  |
| `settings importProfile` | Replace all changed settings with a profile file; invalid keys are skipped and reported. |  |
| `start toggle` | Open or close Start. | `SUPER+SUPER_L` (on release) |
| `start allApps` | Open Start on the All apps list. |  |
| `search toggle` | Open or close Search. | `SUPER+S` |
| `run toggle` | Open or close the Run dialog. | `SUPER+R` |
| `modes toggleStayAwake` | Keep the screen on until turned off again. |  |
| `modes toggleGameMode` | Apply the game mode profile and silence banners. |  |
| `keyboard nextLayout` | Switch to the next keyboard layout (Hyprland). | `SUPER+SPACE` |
| `keyboard lockKeys` | Show Caps Lock and Num Lock state on screen; bind to the key release. | `Caps_Lock` (on release) |
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
| `taskView toggle` | Open or close Task View. | `SUPER+Tab` |
| `altTab next` | Open the switcher or move to the next window. | `ALT+Tab` |
| `altTab previous` | Move to the previous window. | `ALT+SHIFT+Tab` |
| `altTab commit` | Focus the selected window and close the switcher. | `ALT+ALT_L` (on release) |
| `altTab cancel` | Close the switcher without switching. |  |
| `desktop toggle` | Minimize all windows, or restore them. | `SUPER+D` |
| `widgets toggle` | Open or close the widgets board. | `SUPER+W` |
| `wallpaper set` | Use this image file as the wallpaper. |  |
| `wallpaper next` | Next image in wallpaper.directory. |  |
| `wallpaper previous` | Previous image in wallpaper.directory. |  |
| `theming render` | Write every themed file now, even while features.appTheming.enabled is off. |  |
| `snip open` | Open the snipping overlay. | `SUPER+SHIFT+S` |
| `snip screen` | Capture the focused screen now. | `Print` |
| `snip area` | Capture a grim geometry such as "0,0 800x600" without the overlay. |  |
| `snip record` | Open the overlay in recording mode, or stop a running recording. | `SUPER+ALT+R` |
| `snip stop` | Stop the running recording. |  |
| `colorPicker open` | Open the color picker. | `SUPER+SHIFT+C` |
| `colorPicker at` | Copy the color at global x and y without the overlay. |  |
| `snap open` | Open the snap layout picker. | `SUPER+Z` |
| `profiles list` | Installed profiles as JSON: name, active, conditions, problems. |  |
| `profiles activate` | Add a profile to the top of the active stack. |  |
| `profiles deactivate` | Remove a profile from the active stack. |  |
| `profiles order` | Set the whole active stack, comma-separated, first is lowest. |  |
| `profiles create` | Save your changed settings for some sections (comma-separated, e.g. icons,colors) as a new profile. |  |
| `profiles absorb` | Copy a profile's values into your own settings. |  |
| `profiles trust` | Allow a profile to change commands.*. |  |
| `profiles untrust` | Stop a profile from changing commands.*. |  |
| `session lock` | Lock the session. | `SUPER+L` |
| `session menu` | Open the full-screen session menu. | `CTRL+ALT+Delete` |
| `session suspend` | Sleep. |  |
| `session hibernate` | Hibernate. |  |
| `session signOut` | Sign out of the session. |  |
| `session restart` | Restart the computer. |  |
| `session powerOff` | Shut down the computer. |  |
