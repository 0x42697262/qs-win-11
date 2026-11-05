import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import qs.src.config
import qs.src.services
import "../../domain/compositor/windows.mjs" as WindowRules
import "../../domain/catalog/features.mjs" as FeatureCatalog
import "../../domain/catalog/enums.mjs" as Enums
import "../../domain/catalog/logEvents.mjs" as LogEvents
import "../../domain/catalog/compositor.mjs" as CompositorCatalog
import "../../domain/snap/placement.mjs" as Placement
import "../../domain/system/keyboard.mjs" as KeyboardRules
import "../../domain/catalog/system.mjs" as SystemCatalog

CompositorAdapter {
    id: root

    readonly property list<QtObject> toplevels: Hyprland.toplevels.values
    readonly property bool usingLua: Hyprland.usingLua

    kind: Enums.CompositorKind.Hyprland
    capabilities: [FeatureCatalog.Capability.WindowList, FeatureCatalog.Capability.Workspaces, FeatureCatalog.Capability.Screencopy, FeatureCatalog.Capability.WindowPlacement, FeatureCatalog.Capability.KeyboardLayouts]
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

    function windowGeometries(): list<var> {
        Hyprland.refreshToplevels();
        return toplevels
            .filter(toplevel => toplevel.workspace && toplevel.workspace.active)
            .map(toplevel => {
                const info = toplevel.lastIpcObject;
                const position = info[CompositorCatalog.HYPRLAND_POSITION_FIELD] ?? [0, 0];
                const size = info[CompositorCatalog.HYPRLAND_SIZE_FIELD] ?? [0, 0];
                return { id: toplevel.address, x: position[0], y: position[1], width: size[0], height: size[1] };
            })
            .filter(geometry => geometry.width > 0 && geometry.height > 0);
    }

    function nextKeyboardLayout(): void {
        Quickshell.execDetached(Array.prototype.slice.call(SystemCatalog.HyprctlCommand.nextLayout));
    }

    function refreshKeyboard(): void {
        devicesReader.running = false;
        devicesReader.running = true;
        layoutOptionReader.running = false;
        layoutOptionReader.running = true;
    }

    function readJson(text: string): var {
        try {
            return JSON.parse(text);
        } catch (error) {
            return null;
        }
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

    Component.onCompleted: {
        resync();
        refreshKeyboard();
    }

    Process {
        id: devicesReader
        command: Array.prototype.slice.call(SystemCatalog.HyprctlCommand.devices)
        stdout: StdioCollector {
            onStreamFinished: {
                const keyboard = KeyboardRules.mainKeyboard(root.readJson(text));
                root.keyboardLayout = keyboard ? keyboard.layout : "";
            }
        }
    }

    Process {
        id: layoutOptionReader
        command: Array.prototype.slice.call(SystemCatalog.HyprctlCommand.layoutOption)
        stdout: StdioCollector {
            onStreamFinished: root.keyboardLayoutCount = KeyboardRules.layoutCountFromOption(root.readJson(text))
        }
    }

    Timer {
        running: true
        repeat: true
        interval: Settings.values.tuning.keyboardRefreshMs
        onTriggered: root.refreshKeyboard()
    }

    Connections {
        target: Hyprland
        function onRawEvent(event: HyprlandEvent): void {
            if (CompositorCatalog.REFRESH_TOPLEVEL_EVENTS.includes(event.name)) {
                Hyprland.refreshToplevels();
            } else if (event.name === CompositorCatalog.HYPRLAND_LAYOUT_EVENT) {
                root.keyboardLayout = KeyboardRules.layoutFromEvent(event.data);
            }
        }
    }
}
