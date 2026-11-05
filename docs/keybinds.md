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
| `session lock` | Lock the session. | `SUPER+L` |
| `session suspend` | Sleep. |  |
| `session hibernate` | Hibernate. |  |
| `session signOut` | Sign out of the session. |  |
| `session restart` | Restart the computer. |  |
| `session powerOff` | Shut down the computer. |  |
