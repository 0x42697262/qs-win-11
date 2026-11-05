import QtQuick
import QtQuick.Layouts
import qs.src.ui.theme
import "../../domain/catalog/icons.mjs" as Icons
import "../../domain/catalog/uiEnums.mjs" as UiEnums

Rectangle {
    id: root

    property string severity: UiEnums.InfoSeverity.Informational
    property string title: ""
    property string message: ""

    readonly property var iconBySeverity: ({
        informational: Icons.Icon.info,
        success: Icons.Icon.checkmark,
        warning: Icons.Icon.warning,
        error: Icons.Icon.errorCircle,
    })
    readonly property var colorBySeverity: ({
        informational: Theme.colors.accent,
        success: Theme.colors.success,
        warning: Theme.colors.caution,
        error: Theme.colors.critical,
    })

    implicitHeight: row.implicitHeight + Theme.spacing.medium * 2
    radius: Theme.radius.control
    color: Theme.colors.cardBackground
    border.width: Theme.size.stroke
    border.color: Theme.colors.cardStroke

    RowLayout {
        id: row
        anchors.fill: parent
        anchors.margins: Theme.spacing.medium
        spacing: Theme.spacing.medium

        FluentIcon {
            Layout.alignment: Qt.AlignTop
            glyph: root.iconBySeverity[root.severity]
            filled: true
            color: root.colorBySeverity[root.severity]
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing.xSmall

            Label {
                Layout.fillWidth: true
                text: root.title
                variant: UiEnums.TextVariant.BodyStrong
            }

            Label {
                Layout.fillWidth: true
                text: root.message
                wrapMode: Text.WordWrap
                elide: Text.ElideNone
                tone: UiEnums.TextTone.Secondary
            }
        }
    }
}
