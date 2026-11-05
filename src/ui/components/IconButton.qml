import QtQuick
import qs.src.ui.theme
import "../../domain/catalog/uiEnums.mjs" as UiEnums

Interactive {
    id: root

    required property var icon
    property bool filled: false
    property string variant: UiEnums.ButtonVariant.Subtle
    property real iconSize: Theme.iconSize.medium
    property real buttonSize: Theme.size.buttonHeight
    property color iconColor: Theme.colors.textPrimary
    property string toolTip: ""

    implicitWidth: buttonSize
    implicitHeight: buttonSize

    ButtonSurface {
        anchors.fill: parent
        variant: root.variant
        hovered: root.hovered
        pressed: root.pressed
        enabledState: root.enabledState
    }

    FluentIcon {
        anchors.centerIn: parent
        glyph: root.icon
        filled: root.filled
        size: root.iconSize
        color: root.enabledState ? (root.variant === UiEnums.ButtonVariant.Accent ? Theme.colors.textOnAccent : root.iconColor) : Theme.colors.textDisabled
    }
}
