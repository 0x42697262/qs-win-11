import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.src.config
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/catalog/enums.mjs" as Enums
import "../../../domain/catalog/uiEnums.mjs" as UiEnums
import "../../../domain/catalog/compositor.mjs" as CompositorCatalog
import "../../../domain/catalog/appearance.mjs" as AppearanceCatalog

PanelWindow {
    id: root

    required property ShellScreen modelData
    readonly property string position: Settings.values.desktopClock.position
    readonly property bool left: position === Enums.ScreenCorner.TopLeft || position === Enums.ScreenCorner.BottomLeft
    readonly property bool right: position === Enums.ScreenCorner.TopRight || position === Enums.ScreenCorner.BottomRight
    readonly property bool top: position === Enums.ScreenCorner.TopLeft || position === Enums.ScreenCorner.TopRight
    readonly property bool bottom: position === Enums.ScreenCorner.BottomLeft || position === Enums.ScreenCorner.BottomRight

    screen: modelData
    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true
    exclusionMode: ExclusionMode.Ignore
    color: Theme.colors.transparent
    mask: Region {}
    WlrLayershell.layer: WlrLayer.Bottom
    WlrLayershell.namespace: CompositorCatalog.LayerNamespace.Wallpaper

    ColumnLayout {
        id: clock
        x: root.left ? Theme.size.desktopClockMargin : root.right ? parent.width - width - Theme.size.desktopClockMargin : (parent.width - width) / 2
        y: root.top ? Theme.size.desktopClockMargin : root.bottom ? parent.height - height - Theme.size.desktopClockMargin - Theme.size.taskbarHeight : (parent.height - height) / 2
        spacing: 0

        Label {
            Layout.alignment: root.right ? Qt.AlignRight : root.left ? Qt.AlignLeft : Qt.AlignHCenter
            text: Clock.timeText
            variant: UiEnums.TextVariant.Display
            font.weight: Theme.weightSemibold
        }

        Label {
            visible: Settings.values.desktopClock.showDate
            Layout.alignment: root.right ? Qt.AlignRight : root.left ? Qt.AlignLeft : Qt.AlignHCenter
            text: Clock.longDateText
            variant: UiEnums.TextVariant.Subtitle
        }

        layer.enabled: Appearance.shadows !== AppearanceCatalog.Shadows.None
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Theme.colors.shadow
            shadowBlur: 1
        }
    }
}
