import QtQuick
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/catalog/uiEnums.mjs" as UiEnums

Interactive {
    id: root

    required property string glyph

    implicitWidth: Theme.size.emojiCell
    implicitHeight: Theme.size.emojiCell
    onActivated: ClipboardHistory.insertText(glyph)

    Rectangle {
        anchors.fill: parent
        anchors.margins: Theme.spacing.xxSmall
        radius: Theme.radius.control
        color: root.pressed ? Theme.colors.subtleFillPressed : root.hovered ? Theme.colors.subtleFillHover : Theme.colors.transparent
    }

    Label {
        anchors.centerIn: parent
        text: root.glyph
        variant: UiEnums.TextVariant.Subtitle
        scale: root.pressed ? Theme.pressScale : 1

        Behavior on scale {
            NumberAnimation { duration: Theme.motion.press; easing.type: Easing.OutBack; easing.overshoot: Theme.elevation.pressOvershoot }
        }
    }
}
