import QtQuick
import Quickshell.Hyprland
import qs.src.services
import "../../domain/compositor/windows.mjs" as WindowRules
import "../../domain/catalog/features.mjs" as FeatureCatalog
import "../../domain/catalog/enums.mjs" as Enums
import "../../domain/catalog/logEvents.mjs" as LogEvents
import "../../domain/catalog/compositor.mjs" as CompositorCatalog
import "../../domain/snap/placement.mjs" as Placement

CompositorAdapter {
    id: root

    readonly property list<QtObject> toplevels: Hyprland.toplevels.values
    readonly property bool usingLua: Hyprland.usingLua

    kind: Enums.CompositorKind.Hyprland
    capabilities: [FeatureCatalog.Capability.WindowList, FeatureCatalog.Capability.Workspaces, FeatureCatalog.Capability.Screencopy, FeatureCatalog.Capability.WindowPlacement]
    activeWindowId: Hyprland.activeToplevel ? Hyprland.activeToplevel.address : ""
    focusedMonitorName: Hyprland.focusedMonitor ? Hyprland.focusedMonitor.name : ""
    windows: toplevels.map(toplevel => WindowRules.makeWindowInfo({
        id: toplevel.address,
        appId: toplevel.wayland ? toplevel.wayland.appId : (toplevel.lastIpcObject[CompositorCatalog.HYPRLAND_CLASS_FIELD] ?? ""),
        title: toplevel.title,
        active: toplevel.activated,
        urgent: toplevel.urgent,
        workspaceId: toplevel.workspace ? toplevel.workspace.id : WindowRules.NO_WORKSPACE,
        monitorName: toplevel.monitor ? toplevel.monitor.name : "",
    }))
    workspaces: Hyprland.workspaces.values.filter(workspace => workspace.id > 0).map(workspace => ({
        id: workspace.id,
        name: workspace.name,
        active: workspace.active,
        focused: workspace.focused,
        urgent: workspace.urgent,
        monitorName: workspace.monitor ? workspace.monitor.name : "",
        windowCount: workspace.toplevels.values.length,
    }))

    function toplevelFor(windowId: string): var {
        return toplevels.find(toplevel => toplevel.address === windowId) ?? null;
    }

    function focusWindow(windowId: string): void {
        const handle = toplevelFor(windowId)?.wayland;
        if (handle) {
            handle.activate();
        } else {
            unsupported(CompositorCatalog.CompositorAction.FocusWindow);
        }
    }

    function closeWindow(windowId: string): void {
        const handle = toplevelFor(windowId)?.wayland;
        if (handle) {
            handle.close();
        } else {
            unsupported(CompositorCatalog.CompositorAction.CloseWindow);
        }
    }

    function activateWorkspace(workspaceId: int): void {
        Hyprland.workspaces.values.find(workspace => workspace.id === workspaceId)?.activate();
    }

    function focusedMonitorGeometry(): var {
        const monitor = Hyprland.focusedMonitor;
        if (!monitor) {
            return null;
        }
        return { x: monitor.x, y: monitor.y, width: monitor.width, height: monitor.height, scale: monitor.scale, reserved: monitor.lastIpcObject[CompositorCatalog.HYPRLAND_RESERVED_FIELD] ?? [] };
    }

    function placeWindow(windowId: string, rect: var): void {
        const toplevel = toplevelFor(windowId);
        if (!toplevel) {
            return;
        }
        const floating = toplevel.lastIpcObject[CompositorCatalog.HYPRLAND_FLOATING_FIELD] === true;
        Placement.hyprlandPlacementCommands(windowId, rect, root.usingLua, floating).forEach(command => Hyprland.dispatch(command));
        Log.info(LogEvents.LogEvent.WindowPlaced, { windowId, usingLua: root.usingLua, width: rect.width, height: rect.height });
    }

    function windowHandle(windowId: string): var {
        return toplevelFor(windowId)?.wayland ?? null;
    }

    function resync(): void {
        Hyprland.refreshToplevels();
        Hyprland.refreshWorkspaces();
        Hyprland.refreshMonitors();
        Log.info(LogEvents.LogEvent.CompositorResync, { kind: root.kind });
    }

    Component.onCompleted: resync()

    Connections {
        target: Hyprland
        function onRawEvent(event: HyprlandEvent): void {
            if (CompositorCatalog.REFRESH_TOPLEVEL_EVENTS.includes(event.name)) {
                Hyprland.refreshToplevels();
            }
        }
    }
}
