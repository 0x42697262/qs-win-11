import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.src.services
import qs.src.ui.theme
import "../../../domain/catalog/compositor.mjs" as CompositorCatalog

PanelWindow {
    required property ShellScreen modelData

    screen: modelData
    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true
    exclusionMode: ExclusionMode.Ignore
    color: Theme.colors.micaBase
    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.namespace: CompositorCatalog.LayerNamespace.Wallpaper

    Image {
        anchors.fill: parent
        source: Wallpaper.source
        fillMode: Wallpaper.fillMode
        asynchronous: true
        cache: true
    }
}
