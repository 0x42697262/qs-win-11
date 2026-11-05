import QtQuick
import qs.src.services
import "../../../domain/apps/taskbarItems.mjs" as TaskbarRules
import "../../../domain/catalog/features.mjs" as FeatureCatalog
import "../../../domain/shell/surfaces.mjs" as Surfaces
import "../../../domain/catalog/icons.mjs" as Icons
import "../../../domain/catalog/strings.mjs" as Strings

TaskbarButton {
    id: root

    required property var modelData
    required property string screenName

    iconSource: Apps.iconSource(modelData.appId)
    toolTip: modelData.title !== "" ? modelData.title : Apps.displayName(modelData.appId)
    running: modelData.windowIds.length > 0
    active: modelData.active
    urgent: modelData.urgent
    acceptRightClick: true
    acceptMiddleClick: true

    onActivated: {
        const click = TaskbarRules.taskbarClick(modelData, Windows.activeWindowId, Windows.capabilities.includes(FeatureCatalog.Capability.Minimize));
        if (click.action === TaskbarRules.TaskbarClickAction.Launch) {
            Apps.launch(modelData.appId);
        } else if (click.action === TaskbarRules.TaskbarClickAction.Minimize) {
            Windows.toggleMinimize(click.windowId);
        } else {
            Windows.focus(click.windowId);
        }
    }
    onMiddleClicked: Apps.launch(modelData.appId)
    onRightClicked: ShellState.open(Surfaces.Surface.ContextMenu, screenName, {
        anchorX: mapToItem(null, width / 2, 0).x,
        title: Apps.displayName(modelData.appId),
        items: contextItems(),
    })

    function contextItems(): list<var> {
        const appId = modelData.appId;
        const windowIds = modelData.windowIds;
        const items = [
            { text: Strings.Strings.taskbar.newWindow, icon: Icons.Icon.open, action: () => Apps.launch(appId) },
            Apps.isPinnedToTaskbar(appId)
                ? { text: Strings.Strings.taskbar.unpinFromTaskbar, icon: Icons.Icon.pinOff, action: () => Apps.toggleTaskbarPin(appId) }
                : { text: Strings.Strings.taskbar.pinToTaskbar, icon: Icons.Icon.pin, action: () => Apps.toggleTaskbarPin(appId) },
        ];
        if (windowIds.length > 0) {
            items.push({
                text: windowIds.length > 1 ? Strings.Strings.taskbar.closeAllWindows : Strings.Strings.taskbar.closeWindow,
                icon: Icons.Icon.dismiss,
                action: () => windowIds.forEach(windowId => Windows.close(windowId)),
            });
        }
        return items;
    }
}
