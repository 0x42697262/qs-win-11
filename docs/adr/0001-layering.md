# Layering for a QML shell

Status: accepted

## Context

Business rules in QML files end up tangled with bindings and are hard to test. Quickshell gives us QML singletons and ES module imports.

## Decision

Four layers: entry (IPC handlers and UI events), services (QML singletons), domain (pure `.mjs`), adapters (compositor, storage, processes, HTTP). UI never imports system modules directly. Composition happens in `shell.qml` and the adapter selectors.

## Consequences

Domain logic is testable with plain Node. Services stay thin. A little more indirection than a typical dotfiles shell.
