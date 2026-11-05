pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
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
        readonly property bool previewing: ToolTips.previewWindowIds.length > 0
        width: previewing ? previews.implicitWidth + Theme.spacing.small * 2 : label.implicitWidth + Theme.spacing.small * 2
        height: previewing ? previews.implicitHeight + Theme.spacing.small * 2 : label.implicitHeight + Theme.spacing.xSmall * 2
        x: Math.max(Theme.spacing.small, Math.min(ToolTips.anchorX - width / 2, root.width - width - Theme.spacing.small))
        anchors.bottom: parent.bottom
        radius: Theme.radius.control
        color: Theme.colors.flyoutBackground
        border.width: Theme.size.stroke
        border.color: Theme.colors.surfaceStroke

        RowLayout {
            id: previews
            visible: bubble.previewing
            anchors.centerIn: parent
            spacing: Theme.spacing.small

            Repeater {
                model: ToolTips.previewWindowIds

                ColumnLayout {
                    id: preview

                    required property string modelData
                    readonly property var window: Windows.windows.find(candidate => candidate.id === modelData) ?? null

                    spacing: Theme.spacing.xSmall

                    Label {
                        Layout.preferredWidth: Theme.size.thumbnailWidth
                        text: preview.window ? preview.window.title : ""
                        variant: UiEnums.TextVariant.Caption
                    }

                    ScreencopyView {
                        Layout.preferredWidth: Theme.size.thumbnailWidth
                        Layout.preferredHeight: Theme.size.thumbnailHeight
                        captureSource: Windows.handle(preview.modelData)
                        live: true
                        constraintSize: Qt.size(Theme.size.thumbnailWidth, Theme.size.thumbnailHeight)
                    }
                }
            }
        }

        Label {
            id: label
            visible: !bubble.previewing
            anchors.centerIn: parent
            text: ToolTips.text
            variant: UiEnums.TextVariant.Caption
        }
    }
}
