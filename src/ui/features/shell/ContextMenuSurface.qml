pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/catalog/uiEnums.mjs" as UiEnums

FocusScope {
    id: root

    required property var payload

    FlyoutPanel {
        width: Theme.size.contextMenuWidth
        height: column.implicitHeight + Theme.spacing.xSmall * 2
        x: Math.max(Theme.spacing.small, Math.min(root.payload.anchorX - width / 2, root.width - width - Theme.spacing.small))
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.spacing.medium

        ColumnLayout {
            id: column
            anchors.fill: parent
            anchors.margins: Theme.spacing.xSmall
            spacing: 0

            Label {
                visible: (root.payload.title ?? "") !== ""
                Layout.fillWidth: true
                Layout.margins: Theme.spacing.small
                text: root.payload.title ?? ""
                variant: UiEnums.TextVariant.BodyStrong
            }

            Repeater {
                model: root.payload.items

                ListItem {
                    required property var modelData

                    Layout.fillWidth: true
                    icon: modelData.icon ?? null
                    title: modelData.text
                    onActivated: {
                        ShellState.close();
                        modelData.action();
                    }
                }
            }
        }
    }
}
