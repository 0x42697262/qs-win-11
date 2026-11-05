import QtQuick
import Quickshell.Wayland
import "../../domain/compositor/windows.mjs" as WindowRules
import "../../domain/catalog/features.mjs" as FeatureCatalog
import "../../domain/catalog/enums.mjs" as Enums

CompositorAdapter {
    id: root

    property var identities: new Map()
    property int nextIdentity: 1
    readonly property list<QtObject> handles: ToplevelManager.toplevels.values

    kind: Enums.CompositorKind.Generic
    capabilities: [FeatureCatalog.Capability.WindowList, FeatureCatalog.Capability.Minimize, FeatureCatalog.Capability.Screencopy]
    activeWindowId: ToplevelManager.activeToplevel ? identityOf(ToplevelManager.activeToplevel) : ""
    windows: handles.map(handle => WindowRules.makeWindowInfo({
        id: identityOf(handle),
        appId: handle.appId,
        title: handle.title,
        active: handle.activated,
        minimized: handle.minimized,
        monitorName: handle.screens.length > 0 ? handle.screens[0].name : "",
    }))

    onHandlesChanged: {
        const alive = new Set(handles);
        Array.from(identities.keys()).filter(handle => !alive.has(handle)).forEach(handle => identities.delete(handle));
    }

    function identityOf(handle: var): string {
        if (!identities.has(handle)) {
            identities.set(handle, String(nextIdentity));
            nextIdentity += 1;
        }
        return identities.get(handle);
    }

    function handleFor(windowId: string): var {
        return handles.find(handle => identityOf(handle) === windowId) ?? null;
    }

    function focusWindow(windowId: string): void {
        const handle = handleFor(windowId);
        if (handle) {
            handle.minimized = false;
            handle.activate();
        }
    }

    function closeWindow(windowId: string): void {
        handleFor(windowId)?.close();
    }

    function toggleMinimize(windowId: string): void {
        const handle = handleFor(windowId);
        if (handle) {
            handle.minimized = !handle.minimized;
        }
    }

    function windowHandle(windowId: string): var {
        return handleFor(windowId);
    }
}
