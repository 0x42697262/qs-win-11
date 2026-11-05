import QtQuick
import qs.src.config
import QtQuick.Layouts
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/catalog/icons.mjs" as Icons
import "../../../domain/catalog/uiEnums.mjs" as UiEnums

Interactive {
    id: root

    property bool checked: false

    implicitWidth: row.implicitWidth + Theme.spacing.medium * 2
    implicitHeight: Theme.size.taskbarButton

    Rectangle {
        anchors.fill: parent
        radius: Theme.radius.control
        color: root.pressed ? Theme.colors.subtleFillPressed : (root.hovered || root.checked) ? Theme.colors.subtleFillHover : Theme.colors.transparent
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: Theme.spacing.small

        FluentIcon {
            glyph: Weather.current ? Weather.current.icon : Icons.Icon.weatherPartlyCloudyDay
            size: Theme.size.taskbarIcon
        }

        ColumnLayout {
            visible: Weather.available
            spacing: 0

            Label { text: Weather.temperatureText; variant: UiEnums.TextVariant.Caption }
            Label { text: Weather.current ? Weather.current.text : ""; variant: UiEnums.TextVariant.Caption; tone: UiEnums.TextTone.Secondary }
        }
    }

    ToolTip {
        target: root
        hovered: root.hovered
        text: Settings.values.text.taskbar.widgets
    }
}
