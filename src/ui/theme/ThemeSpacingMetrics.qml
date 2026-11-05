import QtQuick
import "../../domain/catalog/tokens.mjs" as Tokens

QtObject {
    required property real scale

    readonly property real xxSmall: Tokens.SPACING.xxSmall * scale
    readonly property real xSmall: Tokens.SPACING.xSmall * scale
    readonly property real small: Tokens.SPACING.small * scale
    readonly property real medium: Tokens.SPACING.medium * scale
    readonly property real large: Tokens.SPACING.large * scale
    readonly property real xLarge: Tokens.SPACING.xLarge * scale
    readonly property real xxLarge: Tokens.SPACING.xxLarge * scale
    readonly property real xxxLarge: Tokens.SPACING.xxxLarge * scale
}
