# Expose actions over IPC, never bind keys

Status: accepted

## Context

Users have their own keybind setups (plain binds, chord plugins, Lua configs).

## Decision

Every action is an `IpcHandler` function listed in `ipcCatalog.mjs`. The shell never edits compositor config or registers shortcuts. `docs/keybinds.md` and `examples/` are generated from the catalog with suggested Windows 11 keys for users to copy.

## Consequences

No conflicts with existing binds. Works on any compositor.
