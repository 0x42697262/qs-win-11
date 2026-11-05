import QtQuick
import Quickshell
import Quickshell.Wayland
import "../domain/catalog/compositor.mjs" as CompositorCatalog
import "../domain/catalog/tokens.mjs" as Tokens

PanelWindow {
    required property ShellScreen modelData

    screen: modelData
    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"
    mask: Region {}
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: CompositorCatalog.LayerNamespace.Overlay

    Rectangle {
        anchors.fill: parent
        color: Tokens.BLACK
        opacity: Tokens.DIM_OPACITY
    }
}
