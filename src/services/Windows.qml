pragma Singleton
import QtQuick
import Quickshell
import qs.src.adapters.compositor
import "../domain/compositor/windows.mjs" as WindowRules
import "../domain/catalog/tuning.mjs" as Tuning

Singleton {
    id: root

    readonly property CompositorAdapter adapter: Compositor.adapter
    readonly property list<var> windows: adapter ? adapter.windows : []
    readonly property list<var> workspaces: adapter ? adapter.workspaces : []
    readonly property string activeWindowId: adapter ? adapter.activeWindowId : ""
    readonly property string focusedMonitorName: adapter ? adapter.focusedMonitorName : ""
    readonly property list<string> capabilities: adapter ? adapter.capabilities : []
    property list<string> mostRecentlyUsed: []
    readonly property list<var> windowsByRecentUse: WindowRules.sortByMostRecentlyUsed(windows, mostRecentlyUsed)

    onActiveWindowIdChanged: trackRecentUse()
    onWindowsChanged: trackRecentUse()

    function trackRecentUse(): void {
        mostRecentlyUsed = WindowRules.updateMostRecentlyUsed(mostRecentlyUsed, activeWindowId, windows.map(window => window.id));
    }

    function windowsForMonitor(monitorName: string, allMonitors: bool): list<var> {
        return WindowRules.windowsForMonitor(windows, monitorName, allMonitors);
    }

    function focus(windowId: string): void {
        adapter?.focusWindow(windowId);
    }

    function close(windowId: string): void {
        adapter?.closeWindow(windowId);
    }

    function toggleMinimize(windowId: string): void {
        adapter?.toggleMinimize(windowId);
    }

    function activateWorkspace(workspaceId: int): void {
        adapter?.activateWorkspace(workspaceId);
    }

    function handle(windowId: string): var {
        return adapter ? adapter.windowHandle(windowId) : null;
    }

    Timer {
        running: root.adapter !== null
        repeat: true
        interval: Tuning.COMPOSITOR_RESYNC_INTERVAL_MS
        onTriggered: root.adapter.resync()
    }
}
