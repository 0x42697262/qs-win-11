import QtQuick
import QtQuick.Layouts
import qs.src.ui.theme
import "../../domain/catalog/uiEnums.mjs" as UiEnums

Interactive {
    id: root

    property string text: ""
    property var icon: null
    property string variant: UiEnums.ButtonVariant.Standard
    property bool checked: false

    implicitHeight: Theme.size.buttonHeight
    implicitWidth: content.implicitWidth + Theme.spacing.large * 2

    ButtonSurface {
        anchors.fill: parent
        variant: root.variant
        hovered: root.hovered
        pressed: root.pressed
        enabledState: root.enabledState
        checked: root.checked
    }

    RowLayout {
        id: content
        anchors.centerIn: parent
        spacing: Theme.spacing.small

        FluentIcon {
            visible: root.icon !== null
            glyph: root.icon
            color: label.color
        }

        Label {
            id: label
            text: root.text
            visible: root.text !== ""
            tone: !root.enabledState ? UiEnums.TextTone.Disabled : (root.variant === UiEnums.ButtonVariant.Accent || root.checked) ? UiEnums.TextTone.OnAccent : UiEnums.TextTone.Primary
        }
    }
}
