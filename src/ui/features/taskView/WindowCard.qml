import QtQuick
import QtQuick.Layouts
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/catalog/icons.mjs" as Icons
import "../../../domain/catalog/uiEnums.mjs" as UiEnums

Interactive {
    id: root

    required property var window
    property bool selected: false
    property bool closable: true
    property real cardWidth: Theme.size.taskViewCard

    implicitWidth: cardWidth
    implicitHeight: Theme.size.taskViewCardHeight

    AcrylicSurface {
        anchors.fill: parent
        fill: root.hovered || root.selected ? Theme.colors.controlFillHover : Theme.surfaceFill
        elevated: false
    }

    Rectangle {
        visible: root.selected
        anchors.fill: parent
        radius: Theme.radius.overlay
        color: Theme.colors.transparent
        border.width: Theme.size.focusStroke
        border.color: Theme.colors.accent
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.spacing.medium
        spacing: Theme.spacing.small

        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing.small

            Image {
                source: Apps.iconSource(root.window.appId)
                sourceSize.width: Theme.iconSize.medium
                sourceSize.height: Theme.iconSize.medium
                Layout.preferredWidth: Theme.iconSize.medium
                Layout.preferredHeight: Theme.iconSize.medium
            }

            Label {
                Layout.fillWidth: true
                text: Apps.displayName(root.window.appId)
                variant: UiEnums.TextVariant.Caption
            }

            IconButton {
                visible: root.closable && root.hovered
                icon: Icons.Icon.dismiss
                iconSize: Theme.iconSize.small
                buttonSize: Theme.iconSize.xLarge
                onActivated: Windows.close(root.window.id)
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Image {
                anchors.centerIn: parent
                source: Apps.iconSource(root.window.appId)
                sourceSize.width: Theme.iconSize.hero
                sourceSize.height: Theme.iconSize.hero
                width: Theme.iconSize.hero
                height: Theme.iconSize.hero
            }
        }

        Label {
            Layout.fillWidth: true
            text: root.window.title
            variant: UiEnums.TextVariant.Caption
            tone: UiEnums.TextTone.Secondary
        }
    }
}
