pragma Singleton
import QtQuick
import Quickshell
import "../domain/shell/windowSwitching.mjs" as SwitchRules
import "../domain/shell/surfaces.mjs" as Surfaces
import "../domain/catalog/features.mjs" as FeatureCatalog
import "../domain/catalog/compositor.mjs" as CompositorCatalog

Singleton {
    id: root

    property int selectedIndex: 0
    property list<string> hiddenByShowDesktop: []
    readonly property bool open: ShellState.openSurface === Surfaces.Surface.AltTab
    readonly property list<var> windows: Windows.windowsByRecentUse
    readonly property bool canShowDesktop: Windows.capabilities.includes(FeatureCatalog.Capability.Minimize)

    function step(direction: int): void {
        if (windows.length === 0) {
            return;
        }
        if (!open) {
            selectedIndex = SwitchRules.cycleIndex(0, windows.length, direction);
            ShellState.open(Surfaces.Surface.AltTab, "", null);
            return;
        }
        selectedIndex = SwitchRules.cycleIndex(selectedIndex, windows.length, direction);
    }

    function commit(): void {
        if (!open) {
            return;
        }
        const target = windows[selectedIndex];
        ShellState.close();
        if (target) {
            Windows.focus(target.id);
        }
    }

    function cancel(): void {
        if (open) {
            ShellState.close();
        }
    }

    function toggleDesktop(): void {
        if (!canShowDesktop) {
            Windows.adapter?.unsupported(CompositorCatalog.CompositorAction.ShowDesktop);
            return;
        }
        const plan = SwitchRules.showDesktopPlan(hiddenByShowDesktop, Windows.windows);
        plan.minimize.forEach(windowId => Windows.toggleMinimize(windowId));
        plan.restore.forEach(windowId => Windows.toggleMinimize(windowId));
        hiddenByShowDesktop = plan.minimize;
    }
}
