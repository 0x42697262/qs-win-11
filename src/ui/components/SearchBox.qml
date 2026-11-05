import QtQuick
import QtQuick.Layouts
import qs.src.ui.theme
import "../../domain/catalog/icons.mjs" as Icons
import "../../domain/catalog/uiEnums.mjs" as UiEnums

FocusScope {
    id: root

    property alias text: input.text
    property string placeholder: ""
    property var icon: Icons.Icon.search
    property bool secret: false

    signal accepted
    signal navigateDown
    signal navigateUp

    implicitHeight: Theme.size.buttonHeight
    implicitWidth: Theme.size.flyoutWidth

    Rectangle {
        anchors.fill: parent
        radius: Theme.radius.round
        color: input.activeFocus ? Theme.colors.flyoutBackground : Theme.colors.controlFill
        border.width: Theme.size.stroke
        border.color: Theme.colors.controlStroke

        Rectangle {
            visible: input.activeFocus
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.leftMargin: parent.radius / 2
            anchors.rightMargin: parent.radius / 2
            height: Theme.size.focusStroke
            color: Theme.colors.accent
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Theme.spacing.medium
        anchors.rightMargin: Theme.spacing.medium
        spacing: Theme.spacing.small

        FluentIcon {
            visible: root.icon !== null
            glyph: root.icon
            color: Theme.colors.textSecondary
        }

        TextInput {
            id: input
            Layout.fillWidth: true
            focus: true
            clip: true
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize.body
            color: Theme.colors.textPrimary
            selectionColor: Theme.colors.accent
            selectedTextColor: Theme.colors.textOnAccent
            echoMode: root.secret ? TextInput.Password : TextInput.Normal
            onAccepted: root.accepted()
            Keys.onDownPressed: root.navigateDown()
            Keys.onUpPressed: root.navigateUp()

            Label {
                visible: input.text === ""
                text: root.placeholder
                tone: UiEnums.TextTone.Secondary
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
