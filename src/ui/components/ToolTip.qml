import QtQuick
import qs.src.config
import Quickshell
import qs.src.services

Item {
    id: root

    required property Item target
    required property bool hovered
    property string text: ""
    property list<string> previewWindowIds: []
    readonly property string screenName: ((target.QsWindow.window as QsWindow)?.screen as ShellScreen)?.name ?? ""

    onHoveredChanged: if (!hovered) ToolTips.hide(target)

    Timer {
        interval: Settings.values.tuning.tooltipDelayMs
        running: root.hovered && root.text !== ""
        onTriggered: ToolTips.showWithPreview(root.target, root.screenName, root.text, root.previewWindowIds)
    }
}
