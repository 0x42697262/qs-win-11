# App theming

The shell can write color files for other apps from its own palette: the
accent (or the accent picked from your wallpaper), light or dark mode,
surfaces, text and a 16-color terminal palette. It is **off by default**
and never edits another app's config. It only writes files into its own
folder, and you include them from each app yourself.

## Turning it on

- `settings set features.appTheming.enabled true` re-renders automatically
  whenever the colors change (theme switch, accent, wallpaper accent,
  profiles), after `tuning.appThemeDelayMs`.
- `qs -c qs-win-11 ipc call theming render` writes everything once, even
  while the feature is off.
- `commands.afterAppTheme` runs after a render, for example
  `pkill -USR1 kitty` to make kitty reload.

Files land in `appTheming.outputDirectory` (default
`~/.config/qs-win-11/themes`, written `<themes>` below).
`appTheming.targets` picks which bundled templates render.

## Bundled templates

| Target | Output | How to use it |
|---|---|---|
| gtk | `<themes>/gtk/colors.css` | `@import url("file://<themes>/gtk/colors.css");` in `~/.config/gtk-3.0/gtk.css` and `gtk-4.0/gtk.css` |
| qt | `<themes>/qt/qs-win-11.conf` | Link into `~/.config/qt6ct/colors/` (and qt5ct), pick it in qt6ct |
| foot | `<themes>/foot/colors.ini` | `include=<themes>/foot/colors.ini` in `foot.ini` |
| kitty | `<themes>/kitty/colors.conf` | `include <themes>/kitty/colors.conf` in `kitty.conf` |
| alacritty | `<themes>/alacritty/colors.toml` | Add to `general.import` |
| btop | `<themes>/btop/qs-win-11.theme` | Link into `~/.config/btop/themes/`, `color_theme = "qs-win-11"` |
| fish | `<themes>/fish/colors.fish` | `source <themes>/fish/colors.fish` in `config.fish` |
| starship | `<themes>/starship/palette.toml` | Copy the palette table, `palette = "qs-win-11"` |
| nvim | `<themes>/nvim/qs-win-11.lua` | `dofile("<themes>/nvim/qs-win-11.lua")` |
| zed | `<themes>/zed/qs-win-11.json` | Link into `~/.config/zed/themes/` |
| vscode | `<themes>/vscode/settings-colors.json` | Merge into `workbench.colorCustomizations` |
| fuzzel | `<themes>/fuzzel/colors.ini` | `include=<themes>/fuzzel/colors.ini` |

## Your own templates

Put `<name>.tmpl` files in `appTheming.templateDirectory` (default
`<themes>/templates`).

- A file with a bundled template's name (`kitty.conf.tmpl`) replaces the
  bundled one.
- Any other name renders to `<themes>/custom/<name>`.

Placeholders are `{{ color }}` or `{{ color.format }}`:

- **Colors:** `background`, `surface`, `surfaceAlt`, `foreground`,
  `foregroundMuted`, `foregroundSubtle`, `foregroundDisabled`, `border`,
  `divider`, `accent`, `accentForeground`, `selection`, `cursor`,
  `success`, `warning`, `error`, `attention`.
- **Terminal colors:** `black` `red` `green` `yellow` `blue` `magenta`
  `cyan` `white`, plus a `bright…` version of each.
- **Formats:**

  | Format | Output |
  |---|---|
  | `hex` (default) | `#rrggbb` |
  | `strip` | `rrggbb` |
  | `rgb` | `r, g, b` |
  | `rgbCss` | `rgb(r, g, b)` |
  | `red`, `green`, `blue` | One channel, 0–255 |
  | `float` | `0.0000 0.0000 0.0000` |
  | `argb` | `#ffrrggbb` |

- **Words:** `{{ mode }}` (`dark`/`light`) and `{{ font }}`.

An unknown placeholder is left as written and logged as
`appTheme.templateProblem`.

Translucent palette colors are flattened over the background, so every
value is opaque. The terminal colors are settings too:
`colors.dark.terminalRed` and the others.
