import QtQuick
import qs.src.config
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/catalog/enums.mjs" as Enums

FlyoutPanel {
    readonly property bool centered: Settings.values.taskbar.alignment === Enums.TaskbarAlignment.Center

    clipContent: true
    width: Theme.size.startMenuWidth
    height: Theme.size.startMenuHeight
    x: centered ? (parent.width - width) / 2 : Theme.spacing.medium
    anchors.bottom: parent.bottom
    anchors.bottomMargin: Theme.spacing.medium
}
