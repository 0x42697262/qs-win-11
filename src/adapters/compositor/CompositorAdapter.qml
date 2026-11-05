import QtQuick
import Quickshell
import qs.src.services
import "../../domain/catalog/logEvents.mjs" as LogEvents
import "../../domain/catalog/compositor.mjs" as CompositorCatalog

Scope {
    id: root

    required property string kind
    property list<var> windows: []
    property list<var> workspaces: []
    property string activeWindowId: ""
    property string focusedMonitorName: ""
    property list<string> capabilities: []

    function unsupported(action: string): void {
        Log.info(LogEvents.LogEvent.CompositorUnsupported, { kind: root.kind, action });
    }

    function focusWindow(windowId: string): void {
        unsupported(CompositorCatalog.CompositorAction.FocusWindow);
    }

    function closeWindow(windowId: string): void {
        unsupported(CompositorCatalog.CompositorAction.CloseWindow);
    }

    function toggleMinimize(windowId: string): void {
        unsupported(CompositorCatalog.CompositorAction.ToggleMinimize);
    }

    function activateWorkspace(workspaceId: int): void {
        unsupported(CompositorCatalog.CompositorAction.ActivateWorkspace);
    }

    function windowHandle(windowId: string): var {
        return null;
    }

    function resync(): void {
    }
}
