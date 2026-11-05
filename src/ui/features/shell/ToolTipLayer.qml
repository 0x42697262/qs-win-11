import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/catalog/compositor.mjs" as CompositorCatalog
import "../../../domain/catalog/uiEnums.mjs" as UiEnums

PanelWindow {
    id: root

    required property ShellScreen modelData
    readonly property bool shown: ToolTips.text !== "" && ToolTips.screenName === modelData.name

    screen: modelData
    visible: shown
    anchors.bottom: true
    anchors.left: true
    anchors.right: true
    implicitHeight: bubble.height + Theme.spacing.small
    exclusionMode: ExclusionMode.Normal
    color: Theme.colors.transparent
    mask: Region {}
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: CompositorCatalog.LayerNamespace.Overlay

    Rectangle {
        id: bubble
        width: label.implicitWidth + Theme.spacing.small * 2
        height: label.implicitHeight + Theme.spacing.xSmall * 2
        x: Math.max(Theme.spacing.small, Math.min(ToolTips.anchorX - width / 2, root.width - width - Theme.spacing.small))
        anchors.bottom: parent.bottom
        radius: Theme.radius.control
        color: Theme.colors.flyoutBackground
        border.width: Theme.size.stroke
        border.color: Theme.colors.surfaceStroke

        Label {
            id: label
            anchors.centerIn: parent
            text: ToolTips.text
            variant: UiEnums.TextVariant.Caption
        }
    }
}
