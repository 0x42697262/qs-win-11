# Profiles

A profile is a partial settings file that can be stacked with others. Icon
packs, color schemes, effect modes and whole shared looks all use the same
mechanism.

## Layout

```
~/.config/qs-win-11/profiles/<name>/profile.json
~/.config/qs-win-11/profiles/<name>/<any assets>
```

```json
{
    "schemaVersion": 1,
    "description": "Neon icons and colors after sunset",
    "activateWhen": { "theme": "dark", "between": "19:00-07:00", "onBattery": false },
    "values": {
        "icons": { "grid": "image:./start.svg" },
        "colors": { "dark": { "accentMixLight": "#ff66ff" } },
        "wallpaper": { "path": "./wall.jpg" }
    }
}
```

- `values` holds any subset of settings, nested like `settings.json`. An icon
  pack is a profile with `icons.*` (shell icons), `appIcons.theme` (an app icon
  theme) and `appIcons.overrides` (`appId=./icon.svg` per app).
- Paths starting with `./` (and `image:./`) resolve against the profile folder,
  so a profile folder can be zipped and shared.
- `activateWhen` is optional. Every condition present must hold: `onBattery`
  (true/false), `theme` (`light`/`dark`, from your own theme settings), and
  `between` (`HH:MM-HH:MM`, may wrap past midnight).

## Stacking

```
catalog defaults  <  profiles.active[0]  <  …  <  profiles.active[n]  <  your settings.json
```

- `profiles.active` lists folder names; later ones win. Only your own settings
  decide which profiles are active; profiles cannot set `profiles.*`.
- `commands.*` keys run programs, so they are skipped unless the profile is in
  `profiles.trustedCommands`. The Settings app warns and offers a Trust button.
- Invalid or unknown keys in a profile are skipped and listed; the rest of the
  profile still applies.
- Settings rows show "From profile <name>" when a profile supplies the value.

## Commands

| IPC call | Does |
|---|---|
| `profiles list` | JSON with name, active, description, conditions, trust, skipped keys |
| `profiles activate <name>` / `deactivate <name>` | Add to the top of the stack / remove |
| `profiles order a,b,c` | Set the whole stack |
| `profiles create <name> icons,colors` | Save your own changes for those sections as a new profile |
| `profiles absorb <name>` | Copy a profile's values into your own settings |
| `profiles trust <name>` / `untrust <name>` | Allow or block `commands.*` |
| `settings exportProfile` / `importProfile` | Full snapshot of your own settings, as before |

## Rejected alternatives

- A separate icon-pack format: it would need its own loader, precedence rules
  and UI, and would not cover colors, effects or wallpapers.
- Letting profiles activate other profiles: it creates cycles and makes the
  effective stack hard to explain.
