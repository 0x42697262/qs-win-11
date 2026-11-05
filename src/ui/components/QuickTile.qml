import QtQuick
import QtQuick.Layouts
import qs.src.ui.theme
import "../../domain/catalog/icons.mjs" as Icons
import "../../domain/catalog/uiEnums.mjs" as UiEnums

ColumnLayout {
    id: root

    required property var icon
    required property string label
    required property bool checked
    property bool hasDetails: false
    property bool enabledState: true

    signal toggled
    signal detailsRequested

    spacing: Theme.spacing.small

    Item {
        Layout.preferredWidth: Theme.size.quickTileWidth
        Layout.preferredHeight: Theme.size.quickTileHeight

        Interactive {
            id: main
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: root.hasDetails ? parent.width / 2 : parent.width
            enabledState: root.enabledState
            onActivated: root.toggled()

            ButtonSurface {
                anchors.fill: parent
                variant: UiEnums.ButtonVariant.Standard
                hovered: main.hovered
                pressed: main.pressed
                enabledState: root.enabledState
                checked: root.checked
            }

            FluentIcon {
                anchors.centerIn: parent
                glyph: root.icon
                filled: root.checked
                color: root.checked ? Theme.colors.textOnAccent : Theme.colors.textPrimary
            }
        }

        Interactive {
            id: details
            visible: root.hasDetails
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: main.right
            anchors.leftMargin: Theme.size.stroke
            enabledState: root.enabledState
            onActivated: root.detailsRequested()

            ButtonSurface {
                anchors.fill: parent
                variant: UiEnums.ButtonVariant.Standard
                hovered: details.hovered
                pressed: details.pressed
                enabledState: root.enabledState
                checked: root.checked
            }

            FluentIcon {
                anchors.centerIn: parent
                glyph: Icons.Icon.chevronRight
                size: Theme.iconSize.small
                color: root.checked ? Theme.colors.textOnAccent : Theme.colors.textPrimary
            }
        }
    }

    Label {
        Layout.preferredWidth: Theme.size.quickTileWidth
        horizontalAlignment: Text.AlignHCenter
        text: root.label
        variant: UiEnums.TextVariant.Caption
        tone: root.enabledState ? UiEnums.TextTone.Primary : UiEnums.TextTone.Disabled
    }
}
