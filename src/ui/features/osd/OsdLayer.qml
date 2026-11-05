import QtQuick
import qs.src.config
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/system/indicators.mjs" as Indicators
import "../../../domain/catalog/icons.mjs" as Icons
import "../../../domain/catalog/uiEnums.mjs" as UiEnums
import "../../../domain/catalog/compositor.mjs" as CompositorCatalog

PanelWindow {
    id: root

    readonly property bool microphone: Osd.kind === UiEnums.OsdKind.Microphone
    readonly property bool volume: Osd.kind === UiEnums.OsdKind.Volume
    readonly property real level: volume ? (Audio.muted ? 0 : Audio.volume) : Brightness.fraction

    screen: Quickshell.screens.find(candidate => candidate.name === ShellState.defaultScreenName()) ?? Quickshell.screens[0]
    visible: Osd.shown
    anchors.bottom: true
    implicitWidth: Theme.size.osdWidth
    implicitHeight: Theme.size.osdHeight + Theme.spacing.xxLarge
    exclusionMode: ExclusionMode.Normal
    color: Theme.colors.transparent
    mask: Region {}
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: CompositorCatalog.LayerNamespace.Osd

    AcrylicSurface {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: Theme.size.osdWidth
        height: Theme.size.osdHeight
        cornerRadius: height / 2
        fill: Theme.overlayFill

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: Theme.spacing.large
            anchors.rightMargin: Theme.spacing.large
            spacing: Theme.spacing.medium

            FluentIcon {
                glyph: root.microphone ? (Audio.microphoneMuted ? Icons.Icon.micOff : Icons.Icon.speaker2) : root.volume ? Indicators.volumeIcon(Audio.volume, Audio.muted) : Icons.Icon.brightnessHigh
            }

            ProgressBar {
                visible: !root.microphone
                Layout.fillWidth: true
                value: root.level
            }

            Label {
                visible: !root.microphone
                text: Indicators.toPercent(root.level)
                horizontalAlignment: Text.AlignRight
            }

            Label {
                visible: root.microphone
                Layout.fillWidth: true
                text: Audio.microphoneMuted ? Settings.values.text.osd.microphoneMuted : Settings.values.text.osd.microphoneOn
            }
        }
    }
}
