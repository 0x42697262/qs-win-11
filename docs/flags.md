# Flags

Every feature has `features.<name>.enabled` in settings. The effective value is
decided by `resolveFeatures(settings, capabilities, conflicts)`: a feature runs
only when its flag is on, every capability it needs is present and nothing else
owns the resource it needs. Every off decision is logged with its reason as
`feature.disabled`.

Defaults are listed in [configuration.md](configuration.md).

## Experimental flags

Experimental flags live under `experimental.*`, default off, and each has an
owner and a removal date. On the removal date the feature either graduates to
a normal flag or is deleted.

| Flag | Owner | Remove by | Graduates when |
|---|---|---|---|
| `experimental.hoverThumbnails` | @0x42697262 | 2027-05-01 | Screencopy is stable on Hyprland and wlroots |
