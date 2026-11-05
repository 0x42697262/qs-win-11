import QtQuick
import QtQuick.Layouts
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/catalog/uiEnums.mjs" as UiEnums

Interactive {
    id: root

    implicitWidth: column.implicitWidth + Theme.spacing.small * 2
    implicitHeight: Theme.size.taskbarButton
    onActivated: Keyboard.nextLayout()

    Rectangle {
        anchors.fill: parent
        radius: Theme.radius.control
        color: root.pressed ? Theme.colors.subtleFillPressed : root.hovered ? Theme.colors.subtleFillHover : Theme.colors.transparent
    }

    ColumnLayout {
        id: column
        anchors.centerIn: parent
        spacing: 0

        Label {
            Layout.alignment: Qt.AlignHCenter
            text: Keyboard.abbreviation.language
            variant: UiEnums.TextVariant.Caption
        }

        Label {
            visible: Keyboard.abbreviation.variant !== ""
            Layout.alignment: Qt.AlignHCenter
            text: Keyboard.abbreviation.variant
            variant: UiEnums.TextVariant.Caption
        }
    }

    ToolTip {
        target: root
        hovered: root.hovered
        text: Keyboard.layoutName
    }
}
