import QtQuick
import QtQuick.Layouts
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/catalog/uiEnums.mjs" as UiEnums

Card {
    id: root

    required property string title
    default property alias cardContent: body.data

    Layout.preferredWidth: Theme.size.widgetCard
    implicitHeight: column.implicitHeight + Theme.spacing.large * 2
    color: Theme.surfaceFill

    ColumnLayout {
        id: column
        anchors.fill: parent
        anchors.margins: Theme.spacing.large
        spacing: Theme.spacing.medium

        Label {
            text: root.title
            variant: UiEnums.TextVariant.Caption
            tone: UiEnums.TextTone.Secondary
        }

        ColumnLayout {
            id: body
            Layout.fillWidth: true
            spacing: Theme.spacing.small
        }
    }
}
