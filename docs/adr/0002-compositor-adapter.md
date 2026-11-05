# Compositor adapter with capability flags

Status: accepted

## Context

We target Hyprland now and want other compositors later.

## Decision

A `CompositorAdapter` contract exposes windows, workspaces, monitors, actions and a `capabilities` object. `HyprlandAdapter` and `WlrToplevelAdapter` (any wlr-foreign-toplevel compositor) ship together; the second is also the fallback when Hyprland IPC is unavailable. Selection is a map keyed by `CompositorKind`, chosen by setting or detected from the environment. UI checks capabilities, never the compositor name.

## Consequences

Adding a compositor is one adapter file and one map entry. Two real implementations justify the interface.
