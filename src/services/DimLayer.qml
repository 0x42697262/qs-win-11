import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.src.config
import "../domain/catalog/compositor.mjs" as CompositorCatalog

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
        color: Settings.values.colors.dim
        opacity: Settings.values.effects.dimOpacity
    }
}
