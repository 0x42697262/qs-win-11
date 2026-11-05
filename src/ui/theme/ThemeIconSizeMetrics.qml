import QtQuick
import "../../domain/catalog/tokens.mjs" as Tokens

QtObject {
    required property real scale

    readonly property real small: Tokens.ICON_SIZE.small * scale
    readonly property real medium: Tokens.ICON_SIZE.medium * scale
    readonly property real large: Tokens.ICON_SIZE.large * scale
    readonly property real xLarge: Tokens.ICON_SIZE.xLarge * scale
    readonly property real appTile: Tokens.ICON_SIZE.appTile * scale
    readonly property real hero: Tokens.ICON_SIZE.hero * scale
}
