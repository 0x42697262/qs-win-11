import QtQuick
import QtQuick.Layouts
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/catalog/uiEnums.mjs" as UiEnums

Interactive {
    id: root

    property bool checked: false

    implicitWidth: Math.max(Theme.size.clockWidth, column.implicitWidth + Theme.spacing.small * 2)
    implicitHeight: Theme.size.taskbarButton

    Rectangle {
        anchors.fill: parent
        radius: Theme.radius.control
        color: root.pressed ? Theme.colors.subtleFillPressed : (root.hovered || root.checked) ? Theme.colors.subtleFillHover : Theme.colors.transparent
    }

    ColumnLayout {
        id: column
        anchors.centerIn: parent
        spacing: 0

        Label {
            Layout.alignment: Qt.AlignRight
            text: Clock.timeText
            variant: UiEnums.TextVariant.Caption
        }

        Label {
            Layout.alignment: Qt.AlignRight
            text: Clock.shortDateText
            variant: UiEnums.TextVariant.Caption
        }
    }
}
