import QtQuick
import QtQuick.Layouts
import qs.src.ui.theme
import "../../domain/catalog/uiEnums.mjs" as UiEnums

Interactive {
    id: root

    property var icon: null
    property string iconSource: ""
    property string title: ""
    property string subtitle: ""
    property bool selected: false
    default property alias trailing: trailingSlot.data

    implicitHeight: Math.max(Theme.size.buttonHeight, row.implicitHeight + Theme.spacing.small * 2)
    implicitWidth: row.implicitWidth + Theme.spacing.medium * 2

    SmoothRectangle {
        anchors.fill: parent
        radius: Theme.radius.control
        smoothingOverride: Theme.controlSmoothing
        color: root.pressed ? Theme.colors.subtleFillPressed : (root.hovered || root.selected) ? Theme.colors.subtleFillHover : Theme.colors.transparent
    }

    Rectangle {
        visible: root.selected
        width: Theme.size.indicatorHeight
        height: parent.height / 2
        radius: width / 2
        anchors.verticalCenter: parent.verticalCenter
        color: Theme.colors.accent
    }

    RowLayout {
        id: row
        anchors.fill: parent
        anchors.leftMargin: Theme.spacing.medium
        anchors.rightMargin: Theme.spacing.medium
        spacing: Theme.spacing.medium

        FluentIcon {
            visible: root.icon !== null
            glyph: root.icon
        }

        Image {
            visible: root.iconSource !== ""
            source: root.iconSource
            sourceSize.width: Theme.iconSize.xLarge
            sourceSize.height: Theme.iconSize.xLarge
            Layout.preferredWidth: Theme.iconSize.xLarge
            Layout.preferredHeight: Theme.iconSize.xLarge
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            Label {
                Layout.fillWidth: true
                text: root.title
            }

            Label {
                Layout.fillWidth: true
                visible: root.subtitle !== ""
                text: root.subtitle
                variant: UiEnums.TextVariant.Caption
                tone: UiEnums.TextTone.Secondary
            }
        }

        RowLayout {
            id: trailingSlot
            spacing: Theme.spacing.small
        }
    }
}
