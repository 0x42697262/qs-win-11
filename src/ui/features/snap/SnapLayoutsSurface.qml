pragma ComponentBehavior: Bound
import QtQuick
import qs.src.config
import QtQuick.Layouts
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/catalog/snapLayouts.mjs" as SnapCatalog
import "../../../domain/catalog/uiEnums.mjs" as UiEnums

FocusScope {
    id: root

    FlyoutPanel {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: Theme.spacing.large
        width: column.implicitWidth + Theme.spacing.large * 2
        height: column.implicitHeight + Theme.spacing.large * 2

        ColumnLayout {
            id: column
            anchors.centerIn: parent
            spacing: Theme.spacing.medium

            Label { text: Settings.values.text.snap.title; variant: UiEnums.TextVariant.BodyStrong }
            Label { text: Settings.values.text.snap.hint; variant: UiEnums.TextVariant.Caption; tone: UiEnums.TextTone.Secondary }

            RowLayout {
                spacing: Theme.spacing.medium

                Repeater {
                    model: SnapCatalog.SNAP_LAYOUTS

                    Rectangle {
                        id: layout

                        required property var modelData

                        implicitWidth: Theme.size.snapPreviewWidth
                        implicitHeight: Theme.size.snapPreviewHeight
                        radius: Theme.radius.control
                        color: Theme.colors.cardBackground
                        border.width: Theme.size.stroke
                        border.color: Theme.colors.cardStroke

                        Repeater {
                            model: layout.modelData.zones

                            Interactive {
                                id: zoneButton

                                required property var modelData

                                x: modelData.x * layout.width + Theme.spacing.xxSmall
                                y: modelData.y * layout.height + Theme.spacing.xxSmall
                                width: modelData.width * layout.width - Theme.spacing.xxSmall * 2
                                height: modelData.height * layout.height - Theme.spacing.xxSmall * 2
                                onActivated: {
                                    ShellState.close();
                                    Windows.placeActive(modelData);
                                }

                                Rectangle {
                                    anchors.fill: parent
                                    radius: Theme.radius.control
                                    color: zoneButton.hovered ? Theme.colors.accent : Theme.colors.controlFill
                                    border.width: Theme.size.stroke
                                    border.color: Theme.colors.controlStroke
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
