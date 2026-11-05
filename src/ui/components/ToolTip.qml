import QtQuick
import Quickshell
import qs.src.services
import "../../domain/catalog/tuning.mjs" as Tuning

Item {
    id: root

    required property Item target
    required property bool hovered
    property string text: ""
    readonly property string screenName: ((target.QsWindow.window as QsWindow)?.screen as ShellScreen)?.name ?? ""

    onHoveredChanged: if (!hovered) ToolTips.hide(target)

    Timer {
        interval: Tuning.TOOLTIP_DELAY_MS
        running: root.hovered && root.text !== ""
        onTriggered: ToolTips.show(root.target, root.screenName, root.text)
    }
}
