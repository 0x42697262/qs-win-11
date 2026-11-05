import QtQuick
import qs.src.ui.theme

Text {
    required property var glyph
    property bool filled: false
    property real size: Theme.iconSize.medium

    text: glyph ? (filled ? glyph.filled : glyph.regular) : ""
    font.family: filled ? Theme.iconFontFilled : Theme.iconFontRegular
    font.pixelSize: size
    color: Theme.colors.textPrimary
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    width: size
    height: size
    textFormat: Text.PlainText
}
