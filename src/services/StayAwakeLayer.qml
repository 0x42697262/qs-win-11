import QtQuick
import Quickshell
import Quickshell.Wayland
import "../domain/catalog/compositor.mjs" as CompositorCatalog

PanelWindow {
    id: root

    anchors.top: true
    anchors.left: true
    implicitWidth: 1
    implicitHeight: 1
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"
    mask: Region {}
    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.namespace: CompositorCatalog.LayerNamespace.Overlay

    IdleInhibitor {
        window: root
        enabled: true
    }
}
