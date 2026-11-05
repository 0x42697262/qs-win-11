import QtQuick
import "../../domain/catalog/tokens.mjs" as Tokens

QtObject {
    required property real scale

    readonly property real caption: Tokens.FONT_SIZE.caption * scale
    readonly property real body: Tokens.FONT_SIZE.body * scale
    readonly property real bodyLarge: Tokens.FONT_SIZE.bodyLarge * scale
    readonly property real subtitle: Tokens.FONT_SIZE.subtitle * scale
    readonly property real title: Tokens.FONT_SIZE.title * scale
    readonly property real titleLarge: Tokens.FONT_SIZE.titleLarge * scale
    readonly property real display: Tokens.FONT_SIZE.display * scale
}
